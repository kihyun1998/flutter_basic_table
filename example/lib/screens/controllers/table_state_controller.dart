import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

import '../../data/sample_data.dart';

/// 테이블의 모든 상태를 관리하는 컨트롤러
class TableStateController extends ChangeNotifier {
  // 상태 변수들
  Set<int> selectedRows = {};
  late ColumnSortManager sortManager;
  late List<BasicTableColumn> allTableColumns;
  late List<BasicTableRow> allTableRows;
  late List<BasicTableColumn> originalTableColumns;
  late List<BasicTableRow> originalTableRows;
  bool _useVariableHeight = false;
  Set<String> hiddenColumnIds = {};

  // Getters
  bool get useVariableHeight => _useVariableHeight;

  List<BasicTableColumn> get visibleColumns => allTableColumns
      .where((col) => !hiddenColumnIds.contains(col.effectiveId))
      .toList();

  List<int> get visibleColumnIndices {
    final indices = <int>[];
    for (int i = 0; i < allTableColumns.length; i++) {
      if (!hiddenColumnIds.contains(allTableColumns[i].effectiveId)) {
        indices.add(i);
      }
    }
    return indices;
  }

  /// 생성자
  TableStateController() {
    sortManager = ColumnSortManager();
    initializeData();
  }

  /// 데이터 초기화
  void initializeData() {
    allTableColumns = SampleData.columns
        .map((col) => BasicTableColumn(
              id: col.name,
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

    originalTableColumns = SampleData.deepCopyColumns(allTableColumns);
    originalTableRows = SampleData.deepCopyRows(allTableRows);
    sortManager.clearAll();
  }

  /// 높이 모드 전환
  void toggleHeightMode() {
    _useVariableHeight = !_useVariableHeight;
    selectedRows.clear();
    hiddenColumnIds.clear();
    initializeData();
    notifyListeners();
  }

  /// 컬럼 visibility 토글
  void toggleColumnVisibility(String columnId) {
    if (hiddenColumnIds.contains(columnId)) {
      hiddenColumnIds.remove(columnId);
    } else {
      hiddenColumnIds.add(columnId);

      // 숨기는 컬럼이 현재 정렬 중이면 정렬 해제
      if (sortManager.currentSortedColumnId == columnId) {
        resetToOriginalState();
      }
    }

    selectedRows.clear(); // 인덱스가 바뀔 수 있으므로
    notifyListeners();

    debugPrint(
        'Column $columnId visibility toggled. Hidden columns: $hiddenColumnIds');
  }

  /// 모든 컬럼 보이기
  void showAllColumns() {
    hiddenColumnIds.clear();
    selectedRows.clear();
    notifyListeners();
    debugPrint('All columns are now visible');
  }

  /// 원본 상태로 복원
  void resetToOriginalState() {
    allTableRows = SampleData.deepCopyRows(originalTableRows);
    allTableColumns = List.from(originalTableColumns);
    sortManager.clearAll();
    notifyListeners();
  }

  /// 행 선택/해제
  void updateRowSelection(int index, bool selected) {
    if (selected) {
      selectedRows.add(index);
    } else {
      selectedRows.remove(index);
    }
    notifyListeners();

    debugPrint(
        'Row $index ${selected ? 'selected' : 'deselected'}. Total selected: ${selectedRows.length}');
  }

  /// 전체 선택/해제
  void updateSelectAll(bool selectAll, int totalRows) {
    if (selectAll) {
      selectedRows = Set.from(List.generate(totalRows, (index) => index));
    } else {
      selectedRows.clear();
    }
    notifyListeners();

    debugPrint(
        '${selectAll ? 'Select all' : 'Deselect all'}. Total selected: ${selectedRows.length}');
  }

  /// 컬럼 정렬
  void updateColumnSort(int visibleColumnIndex, ColumnSortState sortState) {
    // 보이는 컬럼 인덱스를 원본 컬럼 인덱스로 변환
    final originalColumnIndex = visibleColumnIndices[visibleColumnIndex];
    final String columnId = allTableColumns[originalColumnIndex].effectiveId;

    // 정렬 관리자 업데이트
    sortManager.setSortState(columnId, sortState);

    if (sortState != ColumnSortState.none) {
      _sortTableData(originalColumnIndex, sortState);
    } else {
      resetToOriginalState();
    }

    notifyListeners();
    debugPrint('Column sort: visible column $visibleColumnIndex -> $sortState');
  }

  /// ID 기반 컬럼 정렬
  void updateColumnSortById(String columnId, ColumnSortState sortState) {
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
      updateColumnSort(visibleColumnIndex, sortState);
    }
  }

  /// 컬럼 순서 변경
  void updateColumnReorder(int oldVisibleIndex, int newVisibleIndex) {
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
        .map((row) => _reorderRowCells(row, originalOldIndex, originalNewIndex))
        .toList();

    // 원본 데이터도 함께 업데이트
    final BasicTableColumn movedOriginalColumn =
        originalTableColumns.removeAt(originalOldIndex);
    originalTableColumns.insert(originalNewIndex, movedOriginalColumn);

    originalTableRows = originalTableRows
        .map((row) => _reorderRowCells(row, originalOldIndex, originalNewIndex))
        .toList();

    notifyListeners();
    debugPrint(
        '🔄 AFTER reorder: ${visibleColumns.map((c) => c.name).join(', ')}');
  }

  /// 현재 정렬 상태를 보이는 컬럼 기준 인덱스 맵으로 변환
  Map<int, ColumnSortState> getCurrentSortStates() {
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

  /// 테이블 데이터 정렬 (내부 메서드)
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
        comparison = numA.compareTo(numB);
      } else {
        comparison = valueA.compareTo(valueB);
      }

      return sortState == ColumnSortState.descending ? -comparison : comparison;
    });
  }

  /// 행의 셀 순서 변경 (내부 메서드)
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
}
