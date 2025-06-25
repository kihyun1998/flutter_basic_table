import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

import '../../data/sample_data.dart';

/// 테이블의 모든 상태를 관리하는 컨트롤러
class TableStateController extends ChangeNotifier {
  // 상태 변수들
  Set<int> selectedRows = {};
  late ColumnSortManager sortManager;

  /// 현재 테이블 컬럼 Map
  late Map<String, BasicTableColumn> allTableColumns;

  /// 현재 테이블 행 List
  late List<BasicTableRow> allTableRows;

  /// 백업용 원본 데이터
  late Map<String, BasicTableColumn> originalTableColumns;
  late List<BasicTableRow> originalTableRows;

  bool _useVariableHeight = false;
  Set<String> hiddenColumnIds = {};

  // Getters
  bool get useVariableHeight => _useVariableHeight;

  /// 보이는 컬럼 Map (숨겨진 컬럼 제외)
  Map<String, BasicTableColumn> get visibleColumns {
    final Map<String, BasicTableColumn> result = {};

    for (final entry in allTableColumns.entries) {
      if (!hiddenColumnIds.contains(entry.key)) {
        result[entry.key] = entry.value;
      }
    }

    return result;
  }

  /// 보이는 컬럼을 order 기준으로 정렬한 리스트
  List<BasicTableColumn> get visibleColumnsList {
    return BasicTableColumn.mapToSortedList(visibleColumns);
  }

  /// 보이는 컬럼 ID 리스트 (order 순서)
  List<String> get visibleColumnIds {
    return visibleColumnsList.map((col) => col.id).toList();
  }

  /// 모든 컬럼을 order 기준으로 정렬한 리스트
  List<BasicTableColumn> get allColumnsList {
    return BasicTableColumn.mapToSortedList(allTableColumns);
  }

  /// 생성자
  TableStateController() {
    sortManager = ColumnSortManager();
    initializeData();
  }

  /// 데이터 초기화
  void initializeData() {
    // SampleData에서 Map 형태로 직접 가져오기
    allTableColumns = Map<String, BasicTableColumn>.from(SampleData.columns);

    allTableRows = _useVariableHeight
        ? SampleData.generateRowsWithVariableHeight()
        : SampleData.generateRows();

    // 백업 데이터 생성
    originalTableColumns = SampleData.deepCopyColumns(allTableColumns);
    originalTableRows = SampleData.deepCopyRows(allTableRows);

    // 정렬 관리자 초기화
    sortManager.clearAll();

    debugPrint(
        '📊 Data initialized: ${allTableColumns.length} columns, ${allTableRows.length} rows');
    SampleData.printColumnInfo();
  }

  /// 높이 모드 전환
  void toggleHeightMode() {
    _useVariableHeight = !_useVariableHeight;
    selectedRows.clear();
    hiddenColumnIds.clear();
    initializeData();
    notifyListeners();

    debugPrint('🔄 Height mode toggled: $_useVariableHeight');
  }

  /// 컬럼 visibility 토글
  void toggleColumnVisibility(String columnId) {
    if (!allTableColumns.containsKey(columnId)) {
      debugPrint('❌ Column not found: $columnId');
      return;
    }

    if (hiddenColumnIds.contains(columnId)) {
      hiddenColumnIds.remove(columnId);
      debugPrint('👁️ Column shown: $columnId');
    } else {
      hiddenColumnIds.add(columnId);
      debugPrint('🙈 Column hidden: $columnId');

      // 숨기는 컬럼이 현재 정렬 중이면 정렬 해제
      if (sortManager.currentSortedColumnId == columnId) {
        resetToOriginalState();
        debugPrint('🔄 Sort reset due to hidden column: $columnId');
      }
    }

    selectedRows.clear(); // 선택 상태 초기화
    notifyListeners();

    debugPrint(
        '📊 Visible columns: ${visibleColumnIds.length}/${allTableColumns.length}');
  }

  /// 모든 컬럼 보이기
  void showAllColumns() {
    hiddenColumnIds.clear();
    selectedRows.clear();
    notifyListeners();
    debugPrint('👁️ All columns are now visible');
  }

  /// 원본 상태로 복원
  void resetToOriginalState() {
    allTableRows = SampleData.deepCopyRows(originalTableRows);
    allTableColumns = Map<String, BasicTableColumn>.from(originalTableColumns);
    sortManager.clearAll();
    notifyListeners();
    debugPrint('🔄 Reset to original state');
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
        '✅ Row $index ${selected ? 'selected' : 'deselected'}. Total: ${selectedRows.length}');
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
        '📋 ${selectAll ? 'Select all' : 'Deselect all'}. Total: ${selectedRows.length}');
  }

  /// 컬럼 정렬 (visible 인덱스 기반)
  void updateColumnSort(int visibleColumnIndex, ColumnSortState sortState) {
    final visibleCols = visibleColumnsList;

    if (visibleColumnIndex < 0 || visibleColumnIndex >= visibleCols.length) {
      debugPrint('❌ Invalid visible column index: $visibleColumnIndex');
      return;
    }

    final String columnId = visibleCols[visibleColumnIndex].id;
    updateColumnSortById(columnId, sortState);
  }

  /// ID 기반 컬럼 정렬 (권장 방식)
  void updateColumnSortById(String columnId, ColumnSortState sortState) {
    if (!allTableColumns.containsKey(columnId)) {
      debugPrint('❌ Column not found for sort: $columnId');
      return;
    }

    debugPrint('🔄 Column sort: $columnId -> $sortState');

    // 정렬 관리자 업데이트
    sortManager.setSortState(columnId, sortState);

    if (sortState != ColumnSortState.none) {
      _sortTableData(columnId, sortState);
    } else {
      resetToOriginalState();
    }

    notifyListeners();
  }

  /// 컬럼 순서 변경 (columnId와 newOrder 기반)
  void updateColumnReorder(String columnId, int newOrder) {
    if (!allTableColumns.containsKey(columnId)) {
      debugPrint('❌ Column not found for reorder: $columnId');
      return;
    }

    final oldOrder = allTableColumns[columnId]!.order;

    if (oldOrder == newOrder) {
      debugPrint('ℹ️ Column $columnId already at order $newOrder');
      return;
    }

    debugPrint(
        '🔄 Column reorder: $columnId from order $oldOrder to $newOrder');

    // 컬럼 순서 재정렬
    allTableColumns =
        BasicTableColumn.reorderColumn(allTableColumns, columnId, newOrder);

    // 원본 데이터도 함께 업데이트
    originalTableColumns = BasicTableColumn.reorderColumn(
        originalTableColumns, columnId, newOrder);

    // 행 데이터는 Map 기반이므로 순서 변경이 불필요!
    // 렌더링시 order에 따라 자동으로 정렬됨

    notifyListeners();

    debugPrint(
        '✅ Column reorder completed. New order: ${visibleColumnIds.join(' → ')}');
  }

  /// visible 인덱스 기반 컬럼 순서 변경 (하위 호환성)
  void updateColumnReorderByIndex(int oldVisibleIndex, int newVisibleIndex) {
    final visibleCols = visibleColumnsList;

    if (oldVisibleIndex < 0 ||
        oldVisibleIndex >= visibleCols.length ||
        newVisibleIndex < 0 ||
        newVisibleIndex >= visibleCols.length) {
      debugPrint(
          '❌ Invalid reorder indices: $oldVisibleIndex -> $newVisibleIndex');
      return;
    }

    final columnId = visibleCols[oldVisibleIndex].id;

    // newIndex를 실제 order로 변환
    // visible 컬럼들 중에서의 새로운 위치를 전체 컬럼 순서로 매핑
    final newOrder = newVisibleIndex;

    updateColumnReorder(columnId, newOrder);
  }

  /// 현재 정렬 상태를 visible 인덱스 기준 Map으로 변환 (하위 호환성)
  Map<int, ColumnSortState> getCurrentSortStates() {
    return sortManager.toIndexMap(visibleColumnsList);
  }

  /// 테이블 데이터 정렬 (내부 메서드)
  void _sortTableData(String columnId, ColumnSortState sortState) {
    if (!allTableColumns.containsKey(columnId)) {
      debugPrint('❌ Cannot sort: column $columnId not found');
      return;
    }

    debugPrint('📊 Sorting data by column: $columnId ($sortState)');

    allTableRows.sort((a, b) {
      final String valueA = a.getComparableValue(columnId);
      final String valueB = b.getComparableValue(columnId);

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

    debugPrint('✅ Sort completed');
  }

  /// 데이터 유효성 검사
  bool validateData() {
    // 컬럼 중복 ID 검사
    final columnIds = allTableColumns.keys.toSet();
    if (columnIds.length != allTableColumns.length) {
      debugPrint('❌ Duplicate column IDs detected');
      return false;
    }

    // 컬럼 order 연속성 검사
    final orders = allTableColumns.values.map((col) => col.order).toList()
      ..sort();
    for (int i = 0; i < orders.length; i++) {
      if (orders[i] != i) {
        debugPrint('❌ Column order gap detected at index $i');
        return false;
      }
    }

    // 행 데이터 일관성 검사
    for (final row in allTableRows) {
      if (!row.isValid()) {
        debugPrint('❌ Invalid row data at index ${row.index}');
        return false;
      }
    }

    debugPrint('✅ Data validation passed');
    return true;
  }

  /// 컬럼 order 정규화 (개발시 유용)
  void normalizeColumnOrders() {
    allTableColumns = BasicTableColumn.normalizeOrders(allTableColumns);
    originalTableColumns =
        BasicTableColumn.normalizeOrders(originalTableColumns);
    notifyListeners();
    debugPrint('🔧 Column orders normalized');
  }

  /// 디버그 정보 출력
  void printDebugInfo() {
    debugPrint('🔍 === TableStateController Debug Info ===');
    debugPrint('📊 Total columns: ${allTableColumns.length}');
    debugPrint('👁️ Visible columns: ${visibleColumns.length}');
    debugPrint(
        '🙈 Hidden columns: ${hiddenColumnIds.length} (${hiddenColumnIds.join(', ')})');
    debugPrint('📋 Total rows: ${allTableRows.length}');
    debugPrint('✅ Selected rows: ${selectedRows.length}');
    debugPrint('🔄 Variable height: $_useVariableHeight');

    sortManager.printDebugInfoFromMap(allTableColumns);

    debugPrint('📝 Visible column order: ${visibleColumnIds.join(' → ')}');
    debugPrint('🔍 === End Debug Info ===');
  }

  /// 컬럼별 통계 정보
  Map<String, dynamic> getColumnStats(String columnId) {
    if (!allTableColumns.containsKey(columnId)) return {};

    final values = allTableRows
        .map((row) => row.getComparableValue(columnId))
        .where((value) => value.isNotEmpty)
        .toList();

    return {
      'total_rows': allTableRows.length,
      'non_empty_values': values.length,
      'empty_values': allTableRows.length - values.length,
      'unique_values': values.toSet().length,
      'sample_values': values.take(5).toList(),
    };
  }

  @override
  void dispose() {
    // 정리 작업
    selectedRows.clear();
    hiddenColumnIds.clear();
    super.dispose();
  }
}
