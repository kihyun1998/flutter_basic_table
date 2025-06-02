import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

import 'controllers/table_state_controller.dart';
import 'utils/table_data_helper.dart';
import 'widgets/info_card_widget.dart';
import 'widgets/table_card_widget.dart';
import 'widgets/visibility_control_card_widget.dart';

/// 메인 테이블 화면 - 간소화된 버전
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

  /// 보이는 행들 계산 (캐시된 getter처럼 사용)
  List<BasicTableRow> get _visibleRows {
    return TableDataHelper.createVisibleRows(
      _controller.allTableRows,
      _controller.visibleColumnIndices,
    );
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
          ),

          // 컬럼 visibility 제어 카드
          VisibilityControlCardWidget(
            allColumns: _controller.allTableColumns,
            hiddenColumnIds: _controller.hiddenColumnIds,
            onToggleVisibility: _controller.toggleColumnVisibility,
            onShowAllColumns: _controller.showAllColumns,
            onShowVisibilityInfo: _showVisibilityInfo,
          ),

          // 테이블 카드
          TableCardWidget(
            visibleColumns: _controller.visibleColumns,
            visibleRows: _visibleRows,
            selectedRows: _controller.selectedRows,
            sortManager: _controller.sortManager,
            columnSortStates: _controller.getCurrentSortStates(),
            onRowSelectionChanged: _onRowSelectionChanged,
            onSelectAllChanged: _onSelectAllChanged,
            onRowTap: _onRowTap,
            onRowDoubleTap: _onRowDoubleTap,
            onRowSecondaryTap: _onRowSecondaryTap,
            onColumnReorder: _controller.updateColumnReorder,
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
          ? 'Basic Table Demo - 가변 높이 모드'
          : 'Basic Table Demo - 기본 높이 모드'),
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
    _controller.updateSelectAll(selectAll, _visibleRows.length);
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
    final content = TableDataHelper.generateSortInfo(
      _controller.sortManager,
      _controller.visibleColumns,
    );
    _showDialog('정렬 정보', content);
  }

  /// Visibility 정보 표시
  void _showVisibilityInfo() {
    final content = TableDataHelper.generateVisibilityInfo(
      _controller.allTableColumns,
      _controller.visibleColumns,
      _controller.hiddenColumnIds,
    );
    _showDialog('Visibility 정보', content);
  }

  /// 높이 정보 표시
  void _showHeightInfo() {
    final content = TableDataHelper.generateHeightInfo(_visibleRows);
    _showDialog('높이 정보', content);
  }

  /// 공통 다이얼로그 표시 헬퍼
  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
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
