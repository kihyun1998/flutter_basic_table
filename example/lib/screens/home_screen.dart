import 'package:flutter/material.dart';

import 'controllers/table_state_controller.dart';
import 'utils/table_data_helper.dart';
import 'widgets/info_card_widget.dart';
import 'widgets/table_card_widget.dart';
import 'widgets/visibility_control_card_widget.dart';

/// 메인 테이블 화면 - Map 기반으로 리팩토링된 버전
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TableStateController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TableStateController();
    _controller.addListener(_onStateChanged);

    // 초기 유효성 검사
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.validateData();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    _controller.dispose();
    super.dispose();
  }

  /// 상태 변경 리스너
  void _onStateChanged() {
    setState(() {}); // UI 업데이트
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // 정보 표시 카드
          InfoCardWidget(
            selectedRowCount: _controller.selectedRows.length,
            visibleColumns: _controller.visibleColumns,
            allColumns: _controller.allTableColumns,
            sortManager: _controller.sortManager,
            hiddenColumnIds: _controller.hiddenColumnIds,
            useVariableHeight: _controller.useVariableHeight,
            onShowSelectedItems: _showSelectedItems,
            onShowSortInfo: _showSortInfo,
            onToggleHeightMode: _controller.toggleHeightMode,
            onShowDebugInfo: _showDebugInfo, // 새로운 디버그 기능
          ),

          // 컬럼 visibility 제어 카드
          VisibilityControlCardWidget(
            allColumns: _controller.allTableColumns,
            hiddenColumnIds: _controller.hiddenColumnIds,
            onToggleVisibility: _controller.toggleColumnVisibility,
            onShowAllColumns: _controller.showAllColumns,
            onShowVisibilityInfo: _showVisibilityInfo,
            onNormalizeOrders: _controller.normalizeColumnOrders, // 새로운 기능
          ),

          // 테이블 카드
          TableCardWidget(
            visibleColumns: _controller.visibleColumns,
            visibleRows: _controller.allTableRows, // Map 기반이므로 필터링 불필요
            selectedRows: _controller.selectedRows,
            sortManager: _controller.sortManager,
            columnSortStates: _controller.getCurrentSortStates(),
            onRowSelectionChanged: _onRowSelectionChanged,
            onSelectAllChanged: _onSelectAllChanged,
            onRowTap: _onRowTap,
            onRowDoubleTap: _onRowDoubleTap,
            onRowSecondaryTap: _onRowSecondaryTap,
            onColumnReorder: _onColumnReorder, // 새로운 시그니처
            onColumnSort: _controller.updateColumnSort,
            onColumnSortById: _controller.updateColumnSortById,
          ),
        ],
      ),
    );
  }

  /// AppBar 빌드
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(_controller.useVariableHeight
          ? 'Basic Table Demo - 가변 높이 모드 (Map 기반)'
          : 'Basic Table Demo - 기본 높이 모드 (Map 기반)'),
      backgroundColor: Colors.grey[200],
      foregroundColor: Colors.black87,
      actions: [
        IconButton(
          onPressed: _showSortInfo,
          icon: const Icon(Icons.sort),
          tooltip: '정렬 정보',
        ),
        IconButton(
          onPressed: _showVisibilityInfo,
          icon: const Icon(Icons.visibility),
          tooltip: 'Visibility 정보',
        ),
        IconButton(
          onPressed: _showDebugInfo,
          icon: const Icon(Icons.bug_report),
          tooltip: '디버그 정보',
        ),
        IconButton(
          onPressed: _showHeightInfo,
          icon: const Icon(Icons.info),
          tooltip: '높이 정보',
        ),
        IconButton(
          onPressed: _controller.toggleHeightMode,
          icon: Icon(_controller.useVariableHeight
              ? Icons.view_agenda
              : Icons.view_stream),
          tooltip: _controller.useVariableHeight ? '기본 높이로 전환' : '가변 높이로 전환',
        ),
        // 디버그 메뉴
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: _handleDebugAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'validate',
              child: Text('🔍 데이터 검증'),
            ),
            const PopupMenuItem(
              value: 'normalize',
              child: Text('🔧 Order 정규화'),
            ),
            const PopupMenuItem(
              value: 'reset',
              child: Text('🔄 원본으로 리셋'),
            ),
            const PopupMenuItem(
              value: 'column_stats',
              child: Text('📊 컬럼 통계'),
            ),
          ],
        ),
      ],
    );
  }

  // ===================
  // 이벤트 핸들러들
  // ===================

  /// 행 선택/해제 핸들러
  void _onRowSelectionChanged(int index, bool selected) {
    _controller.updateRowSelection(index, selected);
  }

  /// 전체 선택/해제 핸들러
  void _onSelectAllChanged(bool selectAll) {
    _controller.updateSelectAll(selectAll, _controller.allTableRows.length);
  }

  /// 행 클릭 핸들러
  void _onRowTap(int index) {
    debugPrint('Row $index tapped');
  }

  /// 행 더블클릭 핸들러
  void _onRowDoubleTap(int index) {
    debugPrint('Row $index double-tapped');
    _showDialog('더블클릭!', '$index번 행을 더블클릭했습니다.');
  }

  /// 행 우클릭 핸들러
  void _onRowSecondaryTap(int index) {
    debugPrint('Row $index right-clicked');
    _showDialog('우클릭!', '$index번 행을 우클릭했습니다.');
  }

  /// 컬럼 순서 변경 핸들러 (새로운 시그니처)
  void _onColumnReorder(String columnId, int newOrder) {
    debugPrint('🔄 Column reorder request: $columnId -> order $newOrder');
    _controller.updateColumnReorder(columnId, newOrder);
  }

  /// 디버그 액션 핸들러
  void _handleDebugAction(String action) {
    switch (action) {
      case 'validate':
        final isValid = _controller.validateData();
        _showDialog(
            '데이터 검증', isValid ? '✅ 모든 데이터가 유효합니다.' : '❌ 데이터에 문제가 있습니다.');
        break;
      case 'normalize':
        _controller.normalizeColumnOrders();
        _showDialog('Order 정규화', '✅ 컬럼 order가 정규화되었습니다.');
        break;
      case 'reset':
        _controller.resetToOriginalState();
        _showDialog('원본 리셋', '✅ 원본 상태로 복원되었습니다.');
        break;
      case 'column_stats':
        _showColumnStats();
        break;
    }
  }

  // ===================
  // 다이얼로그 표시 메서드들
  // ===================

  /// 선택된 항목 표시
  void _showSelectedItems() {
    final content =
        TableDataHelper.generateSelectedItemsInfo(_controller.selectedRows);
    _showDialog('선택된 항목', content);
  }

  /// 정렬 정보 표시
  void _showSortInfo() {
    final content = TableDataHelper.generateSortInfoFromMap(
      _controller.sortManager,
      _controller.visibleColumns,
    );
    _showDialog('정렬 정보', content);
  }

  /// Visibility 정보 표시
  void _showVisibilityInfo() {
    final content = TableDataHelper.generateVisibilityInfoFromMap(
      _controller.allTableColumns,
      _controller.visibleColumns,
      _controller.hiddenColumnIds,
    );
    _showDialog('Visibility 정보', content);
  }

  /// 디버그 정보 표시
  void _showDebugInfo() {
    _controller.printDebugInfo(); // 콘솔 출력

    final content = '''🔍 TableStateController 상태:

📊 컬럼: ${_controller.allTableColumns.length}개 (보이는 것: ${_controller.visibleColumns.length}개)
📋 행: ${_controller.allTableRows.length}개
✅ 선택된 행: ${_controller.selectedRows.length}개
🔄 가변 높이: ${_controller.useVariableHeight}
🙈 숨겨진 컬럼: ${_controller.hiddenColumnIds.join(', ')}

📝 보이는 컬럼 순서:
${_controller.visibleColumnIds.join(' → ')}

🔍 자세한 정보는 콘솔을 확인하세요.''';

    _showDialog('디버그 정보', content);
  }

  /// 높이 정보 표시
  void _showHeightInfo() {
    final content =
        TableDataHelper.generateHeightInfo(_controller.allTableRows);
    _showDialog('높이 정보', content);
  }

  /// 컬럼별 통계 표시
  void _showColumnStats() {
    final visibleColumns = _controller.visibleColumnsList;

    if (visibleColumns.isEmpty) {
      _showDialog('컬럼 통계', '표시할 컬럼이 없습니다.');
      return;
    }

    final firstColumn = visibleColumns.first;
    final stats = _controller.getColumnStats(firstColumn.id);

    final content = '''📊 컬럼 통계 (${firstColumn.name}):

총 행 수: ${stats['total_rows']}
비어있지 않은 값: ${stats['non_empty_values']}
빈 값: ${stats['empty_values']}
고유 값 수: ${stats['unique_values']}

샘플 값들:
${(stats['sample_values'] as List).join(', ')}

💡 다른 컬럼의 통계를 보려면 해당 컬럼을 첫 번째로 이동하세요.''';

    _showDialog('컬럼 통계', content);
  }

  /// 공통 다이얼로그 표시 헬퍼
  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
