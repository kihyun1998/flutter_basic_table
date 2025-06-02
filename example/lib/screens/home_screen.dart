// example/lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

import '../data/sample_data.dart';
import '../themes/table_theme.dart';

/// 메인 테이블 화면
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 상태 관리
  Set<int> selectedRows = {};

  // 새로운 ID 기반 정렬 관리자 (기존 Map 대신 사용)
  late ColumnSortManager sortManager;

  // 테이블 데이터 (전체)
  late List<BasicTableColumn> allTableColumns;
  late List<BasicTableRow> allTableRows;

  // 백업 데이터 (정렬 해제시 복원용)
  late List<BasicTableColumn> originalTableColumns;
  late List<BasicTableRow> originalTableRows;

  // 현재 데이터 모드
  bool _useVariableHeight = false;

  // 🆕 컬럼 visibility 관리
  Set<String> hiddenColumnIds = {};

  @override
  void initState() {
    super.initState();
    sortManager = ColumnSortManager(); // 새로운 정렬 관리자 초기화
    _initializeData();
  }

  /// 데이터 초기화 및 백업 생성
  void _initializeData() {
    // 컬럼에 고유 ID 추가 (name을 ID로 사용)
    allTableColumns = SampleData.columns
        .map((col) => BasicTableColumn(
              id: col.name, // 명시적으로 ID 설정 (name과 동일)
              name: col.name,
              minWidth: col.minWidth,
              maxWidth: col.maxWidth,
              isResizable: col.isResizable,
              tooltipFormatter: col.tooltipFormatter,
              forceTooltip: col.forceTooltip,
            ))
        .toList();

    allTableRows = _useVariableHeight
        ? SampleData.generateRowsWithVariableHeight()
        : SampleData.generateRows();

    // 백업 데이터 생성
    originalTableColumns = SampleData.deepCopyColumns(allTableColumns);
    originalTableRows = SampleData.deepCopyRows(allTableRows);

    // 정렬 상태 초기화
    sortManager.clearAll();
  }

  // 🆕 Visibility 관련 메서드들

  /// 보이는 컬럼들만 필터링
  List<BasicTableColumn> get visibleColumns => allTableColumns
      .where((col) => !hiddenColumnIds.contains(col.effectiveId))
      .toList();

  /// 보이는 컬럼들의 원본 인덱스
  List<int> get visibleColumnIndices {
    final indices = <int>[];
    for (int i = 0; i < allTableColumns.length; i++) {
      if (!hiddenColumnIds.contains(allTableColumns[i].effectiveId)) {
        indices.add(i);
      }
    }
    return indices;
  }

  /// 보이는 셀들만 포함한 행들 생성 (패키지 수정 없이 example에서 직접 처리)
  List<BasicTableRow> get visibleRows {
    return allTableRows
        .map((row) => _createFilteredRow(row, visibleColumnIndices))
        .toList();
  }

  /// 특정 인덱스들의 셀만 포함한 새로운 행 생성 (example 내부 헬퍼)
  BasicTableRow _createFilteredRow(
      BasicTableRow originalRow, List<int> indices) {
    final filteredCells = <BasicTableCell>[];

    for (final index in indices) {
      if (index >= 0 && index < originalRow.cells.length) {
        filteredCells.add(originalRow.cells[index]);
      }
    }

    return BasicTableRow(
      cells: filteredCells,
      index: originalRow.index,
      height: originalRow.height, // 높이 정보 유지
    );
  }

  /// 컬럼 visibility 토글
  void toggleColumnVisibility(String columnId) {
    setState(() {
      if (hiddenColumnIds.contains(columnId)) {
        hiddenColumnIds.remove(columnId);
      } else {
        hiddenColumnIds.add(columnId);

        // 숨기는 컬럼이 현재 정렬 중이면 정렬 해제
        if (sortManager.currentSortedColumnId == columnId) {
          _resetToOriginalState();
        }
      }

      // 선택 상태 초기화 (인덱스가 바뀔 수 있으므로)
      selectedRows.clear();
    });

    debugPrint(
        'Column $columnId visibility toggled. Hidden columns: $hiddenColumnIds');
  }

  /// 모든 컬럼 보이기
  void showAllColumns() {
    setState(() {
      hiddenColumnIds.clear();
      selectedRows.clear();
    });
    debugPrint('All columns are now visible');
  }

  /// 원본 상태로 완전 복원 (정렬 해제)
  void _resetToOriginalState() {
    setState(() {
      allTableRows = SampleData.deepCopyRows(originalTableRows);
      allTableColumns = List.from(originalTableColumns);
      sortManager.clearAll();
    });
  }

  /// 데이터 모드 전환
  void _toggleHeightMode() {
    setState(() {
      _useVariableHeight = !_useVariableHeight;
      selectedRows.clear(); // 선택 상태 초기화
      hiddenColumnIds.clear(); // visibility 상태 초기화
      _initializeData(); // 데이터 재초기화
    });
  }

  /// 행 선택/해제 콜백
  void onRowSelectionChanged(int index, bool selected) {
    setState(() {
      if (selected) {
        selectedRows.add(index);
      } else {
        selectedRows.remove(index);
      }
    });

    debugPrint(
        'Row $index ${selected ? 'selected' : 'deselected'}. Total selected: ${selectedRows.length}');
  }

  /// 전체 선택/해제 콜백
  void onSelectAllChanged(bool selectAll) {
    setState(() {
      if (selectAll) {
        selectedRows =
            Set.from(List.generate(visibleRows.length, (index) => index));
      } else {
        selectedRows.clear();
      }
    });

    debugPrint(
        '${selectAll ? 'Select all' : 'Deselect all'}. Total selected: ${selectedRows.length}');
  }

  /// 행 클릭 콜백
  void onRowTap(int index) {
    debugPrint('Row $index tapped');
  }

  /// 행 더블클릭 콜백
  void onRowDoubleTap(int index) {
    debugPrint('Row $index double-tapped');
    _showDialog('더블클릭!', '$index번 행을 더블클릭했습니다.');
  }

  /// 행 우클릭 콜백
  void onRowSecondaryTap(int index) {
    debugPrint('Row $index right-clicked');
    _showDialog('우클릭!', '$index번 행을 우클릭했습니다.');
  }

  /// 컬럼 정렬 콜백
  void onColumnSort(int visibleColumnIndex, ColumnSortState sortState) {
    setState(() {
      // 보이는 컬럼 인덱스를 원본 컬럼 인덱스로 변환
      final originalColumnIndex = visibleColumnIndices[visibleColumnIndex];
      final String columnId = allTableColumns[originalColumnIndex].effectiveId;

      // 정렬 관리자 업데이트
      sortManager.setSortState(columnId, sortState);

      if (sortState != ColumnSortState.none) {
        _sortTableData(originalColumnIndex, sortState);
      } else {
        // 원래 상태로 완전히 복원
        _resetToOriginalState();
      }
    });

    debugPrint('Column sort: visible column $visibleColumnIndex -> $sortState');
    sortManager.printDebugInfo(allTableColumns);
  }

  /// ID 기반 컬럼 정렬 콜백
  void onColumnSortById(String columnId, ColumnSortState sortState) {
    debugPrint('🆔 Column sort by ID: $columnId -> $sortState');

    // 보이는 컬럼에서 해당 ID의 인덱스 찾기
    int visibleColumnIndex = -1;
    for (int i = 0; i < visibleColumns.length; i++) {
      if (visibleColumns[i].effectiveId == columnId) {
        visibleColumnIndex = i;
        break;
      }
    }

    if (visibleColumnIndex >= 0) {
      onColumnSort(visibleColumnIndex, sortState);
    }
  }

  /// 컬럼 순서 변경 콜백
  void onColumnReorder(int oldVisibleIndex, int newVisibleIndex) {
    setState(() {
      // newIndex 보정
      if (newVisibleIndex > oldVisibleIndex) {
        newVisibleIndex -= 1;
      }

      debugPrint(
          '🔄 Column reorder: $oldVisibleIndex -> $newVisibleIndex (visible columns)');

      // 보이는 컬럼 인덱스를 원본 인덱스로 변환
      final originalOldIndex = visibleColumnIndices[oldVisibleIndex];
      final originalNewIndex = visibleColumnIndices[newVisibleIndex];

      debugPrint('🔄 Original indices: $originalOldIndex -> $originalNewIndex');

      // 원본 컬럼 순서 변경
      final BasicTableColumn movedColumn =
          allTableColumns.removeAt(originalOldIndex);
      allTableColumns.insert(originalNewIndex, movedColumn);

      // 모든 행의 데이터도 재정렬
      allTableRows = allTableRows
          .map((row) =>
              _reorderRowCells(row, originalOldIndex, originalNewIndex))
          .toList();

      // 원본 데이터도 함께 업데이트
      final BasicTableColumn movedOriginalColumn =
          originalTableColumns.removeAt(originalOldIndex);
      originalTableColumns.insert(originalNewIndex, movedOriginalColumn);

      originalTableRows = originalTableRows
          .map((row) =>
              _reorderRowCells(row, originalOldIndex, originalNewIndex))
          .toList();

      debugPrint('🔄 AFTER reorder:');
      debugPrint(
          '   Visible column names: ${visibleColumns.map((c) => c.name).join(', ')}');
    });
  }

  /// 행의 셀 순서 변경 (example 내부 헬퍼)
  BasicTableRow _reorderRowCells(
      BasicTableRow row, int oldIndex, int newIndex) {
    if (oldIndex < 0 ||
        oldIndex >= row.cells.length ||
        newIndex < 0 ||
        newIndex >= row.cells.length ||
        oldIndex == newIndex) {
      return row;
    }

    final newCells = List<BasicTableCell>.from(row.cells);
    final BasicTableCell movedCell = newCells.removeAt(oldIndex);
    newCells.insert(newIndex, movedCell);

    return BasicTableRow(
      cells: newCells,
      index: row.index,
      height: row.height,
    );
  }

  /// 테이블 데이터 정렬 (원본 데이터 기준)
  void _sortTableData(int originalColumnIndex, ColumnSortState sortState) {
    if (originalColumnIndex >= allTableColumns.length) return;

    allTableRows.sort((a, b) {
      final String valueA = a.cells[originalColumnIndex].displayText ?? '';
      final String valueB = b.cells[originalColumnIndex].displayText ?? '';

      // 숫자 파싱 시도
      final numA = num.tryParse(valueA);
      final numB = num.tryParse(valueB);

      int comparison;
      if (numA != null && numB != null) {
        // 둘 다 숫자면 숫자로 비교
        comparison = numA.compareTo(numB);
      } else {
        // 문자열로 비교
        comparison = valueA.compareTo(valueB);
      }

      // 내림차순이면 결과 반전
      return sortState == ColumnSortState.descending ? -comparison : comparison;
    });
  }

  /// 현재 정렬 상태를 보이는 컬럼 기준 인덱스 맵으로 변환
  Map<int, ColumnSortState> _getCurrentSortStates() {
    final Map<int, ColumnSortState> indexMap = {};

    for (int i = 0; i < visibleColumns.length; i++) {
      final String columnId = visibleColumns[i].effectiveId;
      final ColumnSortState state = sortManager.getSortState(columnId);

      if (state != ColumnSortState.none) {
        indexMap[i] = state;
      }
    }

    return indexMap;
  }

  /// 다이얼로그 표시 헬퍼
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

  /// 선택된 항목 보기
  void _showSelectedItems() {
    _showDialog('선택된 항목', '선택된 행들의 인덱스:\n${selectedRows.toList()..sort()}');
  }

  /// 높이 정보 표시
  void _showHeightInfo() {
    final heightInfo = StringBuffer();
    heightInfo.writeln('📏 행별 높이 정보:');
    heightInfo.writeln('');

    final rows = visibleRows;
    for (int i = 0; i < rows.length && i < 10; i++) {
      final row = rows[i];
      final effectiveHeight = row.getEffectiveHeight(45.0);
      final hasCustom = row.hasCustomHeight ? ' (커스텀)' : ' (테마 기본값)';
      heightInfo.writeln('Row ${i + 1}: ${effectiveHeight}px$hasCustom');
    }

    if (rows.length > 10) {
      heightInfo.writeln('... (총 ${rows.length}개 행)');
    }

    _showDialog('높이 정보', heightInfo.toString());
  }

  /// 정렬 상태 정보 표시
  void _showSortInfo() {
    final sortInfo = StringBuffer();
    sortInfo.writeln('🔍 정렬 상태 정보:');
    sortInfo.writeln('');

    if (sortManager.hasSortedColumn) {
      sortInfo.writeln('현재 정렬된 컬럼: ${sortManager.currentSortedColumnId}');

      final currentIndex =
          sortManager.getCurrentSortedColumnIndex(visibleColumns);
      if (currentIndex != null) {
        sortInfo.writeln('보이는 컬럼 위치: $currentIndex번');
        sortInfo.writeln('컬럼명: ${visibleColumns[currentIndex].name}');
      }
    } else {
      sortInfo.writeln('현재 정렬된 컬럼이 없습니다.');
    }

    sortInfo.writeln('');
    sortInfo.writeln('📋 보이는 컬럼 정보:');
    for (int i = 0; i < visibleColumns.length; i++) {
      final column = visibleColumns[i];
      final state = sortManager.getSortState(column.effectiveId);
      final stateIcon = state == ColumnSortState.ascending
          ? '↑'
          : state == ColumnSortState.descending
              ? '↓'
              : '○';
      sortInfo
          .writeln('  [$i] ${column.name} (${column.effectiveId}) $stateIcon');
    }

    _showDialog('정렬 정보', sortInfo.toString());
  }

  /// 컬럼 visibility 정보 표시
  void _showVisibilityInfo() {
    final visibilityInfo = StringBuffer();
    visibilityInfo.writeln('👁️ 컬럼 Visibility 정보:');
    visibilityInfo.writeln('');

    visibilityInfo.writeln('보이는 컬럼: ${visibleColumns.length}개');
    visibilityInfo.writeln('숨겨진 컬럼: ${hiddenColumnIds.length}개');
    visibilityInfo.writeln('');

    visibilityInfo.writeln('📋 전체 컬럼 상태:');
    for (int i = 0; i < allTableColumns.length; i++) {
      final column = allTableColumns[i];
      final isVisible = !hiddenColumnIds.contains(column.effectiveId);
      final icon = isVisible ? '👁️' : '🙈';
      visibilityInfo.writeln('  [$i] ${column.name} $icon');
    }

    if (hiddenColumnIds.isNotEmpty) {
      visibilityInfo.writeln('');
      visibilityInfo.writeln('숨겨진 컬럼들: ${hiddenColumnIds.join(', ')}');
    }

    _showDialog('Visibility 정보', visibilityInfo.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_useVariableHeight
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
            onPressed: _toggleHeightMode,
            icon: Icon(
                _useVariableHeight ? Icons.view_agenda : Icons.view_stream),
            tooltip: _useVariableHeight ? '기본 높이로 전환' : '가변 높이로 전환',
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // 선택 상태 + 컬럼 순서 + 높이 모드 + 정렬 상태 표시 카드
          _buildInfoCard(),

          // 컬럼 visibility 컨트롤 카드
          _buildVisibilityControlCard(),

          // 테이블 카드
          _buildTableCard(),
        ],
      ),
    );
  }

  /// 정보 표시 카드 위젯
  Widget _buildInfoCard() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '선택된 행: ${selectedRows.length}개',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                ),
                Row(
                  children: [
                    if (selectedRows.isNotEmpty)
                      ElevatedButton(
                        onPressed: _showSelectedItems,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('선택 항목 보기'),
                      ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _showSortInfo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: sortManager.hasSortedColumn
                            ? Colors.green
                            : Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('정렬 정보'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _toggleHeightMode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _useVariableHeight ? Colors.orange : Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(_useVariableHeight ? '기본 높이 모드' : '가변 높이 모드'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '보이는 컬럼: ${visibleColumns.map((col) => col.name).join(' → ')}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  sortManager.hasSortedColumn
                      ? Icons.sort
                      : Icons.sort_outlined,
                  size: 16,
                  color: sortManager.hasSortedColumn
                      ? Colors.green
                      : Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  sortManager.hasSortedColumn
                      ? '정렬됨: ${sortManager.currentSortedColumnId}'
                      : '정렬 없음',
                  style: TextStyle(
                    fontSize: 12,
                    color: sortManager.hasSortedColumn
                        ? Colors.green
                        : Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  hiddenColumnIds.isNotEmpty
                      ? Icons.visibility_off
                      : Icons.visibility,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${visibleColumns.length}/${allTableColumns.length} 컬럼 표시',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  _useVariableHeight ? Icons.height : Icons.horizontal_rule,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  _useVariableHeight ? '가변 높이 모드' : '기본 높이 모드',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 컬럼 visibility 컨트롤 카드 위젯
  Widget _buildVisibilityControlCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '👁️ 컬럼 표시 설정',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed:
                          hiddenColumnIds.isNotEmpty ? showAllColumns : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('모두 보이기'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _showVisibilityInfo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Visibility 정보'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: allTableColumns.map((column) {
                final isVisible = !hiddenColumnIds.contains(column.effectiveId);
                return FilterChip(
                  label: Text(column.name),
                  selected: isVisible,
                  onSelected: (_) => toggleColumnVisibility(column.effectiveId),
                  selectedColor: Colors.green.withOpacity(0.2),
                  checkmarkColor: Colors.green,
                  avatar: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    size: 18,
                    color: isVisible ? Colors.green : Colors.grey,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// 테이블 카드 위젯
  Widget _buildTableCard() {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(8.0),
        color: Colors.white,
        elevation: 1,
        child: BasicTable(
          columns: visibleColumns, // 보이는 컬럼만 전달
          rows: visibleRows, // 보이는 셀만 포함한 행들 전달
          theme: AppTableTheme.monochrome,
          selectedRows: selectedRows,
          onRowSelectionChanged: onRowSelectionChanged,
          onSelectAllChanged: onSelectAllChanged,
          onRowTap: onRowTap,
          onRowDoubleTap: onRowDoubleTap,
          onRowSecondaryTap: onRowSecondaryTap,
          doubleClickTime: const Duration(milliseconds: 250),
          onColumnReorder: onColumnReorder,
          onColumnSort: onColumnSort,
          onColumnSortById: onColumnSortById,
          sortManager: sortManager,
        ),
      ),
    );
  }
}
