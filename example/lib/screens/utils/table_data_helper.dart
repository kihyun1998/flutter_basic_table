import 'package:flutter_basic_table/flutter_basic_table.dart';

/// 테이블 데이터 처리를 위한 유틸리티 클래스 (Map 기반)
class TableDataHelper {
  TableDataHelper._(); // private 생성자 (유틸리티 클래스)

  /// Map 기반 정렬 상태 정보를 문자열로 생성
  static String generateSortInfoFromMap(ColumnSortManager sortManager,
      Map<String, BasicTableColumn> visibleColumns) {
    final sortInfo = StringBuffer();
    sortInfo.writeln('🔍 정렬 상태 정보 (Map 기반):');
    sortInfo.writeln('');

    if (sortManager.hasSortedColumn) {
      final currentColumnId = sortManager.currentSortedColumnId!;
      final currentColumn = visibleColumns[currentColumnId];

      sortInfo.writeln('현재 정렬된 컬럼: $currentColumnId');

      if (currentColumn != null) {
        sortInfo.writeln('컬럼명: ${currentColumn.name}');
        sortInfo.writeln('Order: ${currentColumn.order}');
        sortInfo.writeln('정렬 상태: ${sortManager.getSortState(currentColumnId)}');
      } else {
        sortInfo.writeln('⚠️ 정렬 중인 컬럼이 현재 숨겨져 있습니다.');
      }
    } else {
      sortInfo.writeln('현재 정렬된 컬럼이 없습니다.');
    }

    sortInfo.writeln('');
    sortInfo.writeln('📋 보이는 컬럼 정보:');

    final sortedColumns = BasicTableColumn.mapToSortedList(visibleColumns);
    for (int i = 0; i < sortedColumns.length; i++) {
      final column = sortedColumns[i];
      final state = sortManager.getSortState(column.id);
      final stateIcon = state == ColumnSortState.ascending
          ? '↑'
          : state == ColumnSortState.descending
              ? '↓'
              : '○';
      sortInfo.writeln(
          '  [${column.order}] ${column.name} (${column.id}) $stateIcon');
    }

    // 활성 정렬 상태 요약
    final activeSorts = sortManager.activeSortStates;
    if (activeSorts.isNotEmpty) {
      sortInfo.writeln('');
      sortInfo.writeln('🎯 활성 정렬 상태:');
      for (final entry in activeSorts.entries) {
        sortInfo.writeln('  ${entry.key}: ${entry.value}');
      }
    }

    return sortInfo.toString();
  }

  /// Map 기반 Visibility 상태 정보를 문자열로 생성
  static String generateVisibilityInfoFromMap(
    Map<String, BasicTableColumn> allColumns,
    Map<String, BasicTableColumn> visibleColumns,
    Set<String> hiddenColumnIds,
  ) {
    final visibilityInfo = StringBuffer();
    visibilityInfo.writeln('👁️ 컬럼 Visibility 정보 (Map 기반):');
    visibilityInfo.writeln('');

    visibilityInfo.writeln('보이는 컬럼: ${visibleColumns.length}개');
    visibilityInfo.writeln('숨겨진 컬럼: ${hiddenColumnIds.length}개');
    visibilityInfo.writeln('전체 컬럼: ${allColumns.length}개');
    visibilityInfo.writeln('');

    visibilityInfo.writeln('📋 전체 컬럼 상태 (order 순서):');

    final sortedAllColumns = BasicTableColumn.mapToSortedList(allColumns);
    for (final column in sortedAllColumns) {
      final isVisible = !hiddenColumnIds.contains(column.id);
      final icon = isVisible ? '👁️' : '🙈';
      visibilityInfo
          .writeln('  [${column.order}] ${column.name} (${column.id}) $icon');
    }

    if (hiddenColumnIds.isNotEmpty) {
      visibilityInfo.writeln('');
      visibilityInfo.writeln('🙈 숨겨진 컬럼 ID들:');
      final hiddenColumnsList = hiddenColumnIds.toList()..sort();
      for (final columnId in hiddenColumnsList) {
        final column = allColumns[columnId];
        if (column != null) {
          visibilityInfo.writeln('  • $columnId (${column.name})');
        } else {
          visibilityInfo.writeln('  • $columnId (⚠️ 컬럼 정보 없음)');
        }
      }
    }

    // 보이는 컬럼의 order 연속성 체크
    final visibleOrders = BasicTableColumn.mapToSortedList(visibleColumns)
        .map((col) => col.order)
        .toList();

    visibilityInfo.writeln('');
    visibilityInfo.writeln('🔢 보이는 컬럼 Order: ${visibleOrders.join(', ')}');

    // Order 연속성 검사
    bool isOrderConsecutive = true;
    for (int i = 1; i < visibleOrders.length; i++) {
      if (visibleOrders[i] != visibleOrders[i - 1] + 1) {
        isOrderConsecutive = false;
        break;
      }
    }

    if (!isOrderConsecutive && visibleOrders.isNotEmpty) {
      visibilityInfo.writeln('⚠️ Order가 연속적이지 않습니다. 정규화가 필요할 수 있습니다.');
    }

    return visibilityInfo.toString();
  }

  /// 높이 정보를 문자열로 생성 (Map 기반 행)
  static String generateHeightInfo(List<BasicTableRow> rows) {
    final heightInfo = StringBuffer();
    heightInfo.writeln('📏 행별 높이 정보 (Map 기반):');
    heightInfo.writeln('');

    // 높이별 분류
    final Map<double, int> heightCounts = {};
    final List<BasicTableRow> customHeightRows = [];

    for (final row in rows) {
      final height = row.height ?? 45.0; // 기본 높이 45px
      heightCounts[height] = (heightCounts[height] ?? 0) + 1;

      if (row.hasCustomHeight) {
        customHeightRows.add(row);
      }
    }

    heightInfo.writeln('📊 높이별 분포:');
    final sortedHeights = heightCounts.keys.toList()..sort();
    for (final height in sortedHeights) {
      final count = heightCounts[height]!;
      final isDefault = height == 45.0;
      heightInfo
          .writeln('  ${height}px: $count행 ${isDefault ? '(기본값)' : '(커스텀)'}');
    }

    if (customHeightRows.isNotEmpty) {
      heightInfo.writeln('');
      heightInfo.writeln('🎨 커스텀 높이 행들:');
      for (int i = 0; i < customHeightRows.length && i < 10; i++) {
        final row = customHeightRows[i];
        final nameCell = row.getCell('name');
        final name = nameCell?.displayText ?? 'Unknown';
        heightInfo.writeln('  Row ${row.index}: ${row.height}px ($name)');
      }

      if (customHeightRows.length > 10) {
        heightInfo.writeln('  ... (총 ${customHeightRows.length}개)');
      }
    }

    heightInfo.writeln('');
    heightInfo.writeln('📋 요약:');
    heightInfo.writeln('  전체 행 수: ${rows.length}');
    heightInfo.writeln('  커스텀 높이 행: ${customHeightRows.length}');
    heightInfo.writeln('  기본 높이 행: ${rows.length - customHeightRows.length}');

    return heightInfo.toString();
  }

  /// 선택된 항목 정보를 문자열로 생성
  static String generateSelectedItemsInfo(Set<int> selectedRows) {
    final selectedInfo = StringBuffer();
    selectedInfo.writeln('✅ 선택된 항목 정보:');
    selectedInfo.writeln('');

    if (selectedRows.isEmpty) {
      selectedInfo.writeln('선택된 행이 없습니다.');
      return selectedInfo.toString();
    }

    selectedInfo.writeln('선택된 행 수: ${selectedRows.length}개');
    selectedInfo.writeln('');

    final sortedIndices = selectedRows.toList()..sort();

    if (sortedIndices.length <= 20) {
      selectedInfo.writeln('선택된 행 인덱스:');
      selectedInfo.writeln(sortedIndices.join(', '));
    } else {
      selectedInfo.writeln('선택된 행 인덱스 (처음 20개):');
      selectedInfo.writeln(sortedIndices.take(20).join(', '));
      selectedInfo.writeln('... (총 ${sortedIndices.length}개)');
    }

    // 연속된 범위 표시
    final ranges = _findConsecutiveRanges(sortedIndices);
    if (ranges.isNotEmpty) {
      selectedInfo.writeln('');
      selectedInfo.writeln('📊 연속된 범위:');
      for (final range in ranges) {
        if (range.length == 1) {
          selectedInfo.writeln('  ${range.first}');
        } else {
          selectedInfo
              .writeln('  ${range.first}-${range.last} (${range.length}개)');
        }
      }
    }

    return selectedInfo.toString();
  }

  /// 연속된 숫자 범위 찾기
  static List<List<int>> _findConsecutiveRanges(List<int> sortedNumbers) {
    if (sortedNumbers.isEmpty) return [];

    final List<List<int>> ranges = [];
    List<int> currentRange = [sortedNumbers[0]];

    for (int i = 1; i < sortedNumbers.length; i++) {
      if (sortedNumbers[i] == sortedNumbers[i - 1] + 1) {
        currentRange.add(sortedNumbers[i]);
      } else {
        ranges.add(currentRange);
        currentRange = [sortedNumbers[i]];
      }
    }

    ranges.add(currentRange);
    return ranges.where((range) => range.length >= 3).toList(); // 3개 이상만 범위로 표시
  }

  /// Map 기반 컬럼에서 특정 통계 생성
  static Map<String, dynamic> generateColumnStatistics(
    Map<String, BasicTableColumn> columns,
    List<BasicTableRow> rows,
  ) {
    final stats = <String, dynamic>{};

    for (final entry in columns.entries) {
      final columnId = entry.key;
      final column = entry.value;

      final values = rows
          .map((row) => row.getComparableValue(columnId))
          .where((value) => value.isNotEmpty)
          .toList();

      stats[columnId] = {
        'name': column.name,
        'order': column.order,
        'total_rows': rows.length,
        'non_empty_values': values.length,
        'empty_values': rows.length - values.length,
        'unique_values': values.toSet().length,
        'min_width': column.minWidth,
        'max_width': column.maxWidth,
        'is_resizable': column.isResizable,
        'force_tooltip': column.forceTooltip,
      };
    }

    return stats;
  }

  /// 테이블 데이터 검증
  static Map<String, dynamic> validateTableData(
    Map<String, BasicTableColumn> columns,
    List<BasicTableRow> rows,
  ) {
    final validation = <String, dynamic>{
      'is_valid': true,
      'errors': <String>[],
      'warnings': <String>[],
      'summary': <String, dynamic>{},
    };

    final errors = validation['errors'] as List<String>;
    final warnings = validation['warnings'] as List<String>;

    // 컬럼 검증
    final columnIds = columns.keys.toSet();
    if (columnIds.length != columns.length) {
      errors.add('Duplicate column IDs detected');
      validation['is_valid'] = false;
    }

    // Order 연속성 검증
    final orders = columns.values.map((col) => col.order).toList()..sort();
    for (int i = 0; i < orders.length; i++) {
      if (orders[i] != i) {
        warnings.add(
            'Column order gap at index $i (expected: $i, actual: ${orders[i]})');
      }
    }

    // 행 데이터 검증
    int invalidRows = 0;
    for (final row in rows) {
      if (!row.isValid()) {
        invalidRows++;
      }
    }

    if (invalidRows > 0) {
      errors.add('$invalidRows invalid rows detected');
      validation['is_valid'] = false;
    }

    // 요약 정보
    validation['summary'] = {
      'total_columns': columns.length,
      'total_rows': rows.length,
      'invalid_rows': invalidRows,
      'order_gaps': warnings.where((w) => w.contains('order gap')).length,
    };

    return validation;
  }

  /// 컬럼 order 분석
  static String analyzeColumnOrders(Map<String, BasicTableColumn> columns) {
    final analysis = StringBuffer();
    analysis.writeln('🔢 컬럼 Order 분석:');
    analysis.writeln('');

    final sortedColumns = BasicTableColumn.mapToSortedList(columns);

    analysis.writeln('📊 현재 Order 상태:');
    for (final column in sortedColumns) {
      analysis.writeln('  [${column.order}] ${column.name} (${column.id})');
    }

    // 연속성 검사
    final orders = sortedColumns.map((col) => col.order).toList();
    final gaps = <int>[];

    for (int i = 0; i < orders.length; i++) {
      if (orders[i] != i) {
        gaps.add(i);
      }
    }

    if (gaps.isEmpty) {
      analysis.writeln('');
      analysis.writeln('✅ Order가 연속적입니다 (0부터 ${orders.length - 1}까지)');
    } else {
      analysis.writeln('');
      analysis.writeln('⚠️ Order 불연속 지점: ${gaps.join(', ')}');
      analysis.writeln('정규화를 권장합니다.');
    }

    return analysis.toString();
  }
}
