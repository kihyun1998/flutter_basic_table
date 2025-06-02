import 'package:flutter_basic_table/flutter_basic_table.dart';

/// 테이블 데이터 처리를 위한 유틸리티 클래스
class TableDataHelper {
  TableDataHelper._(); // private 생성자 (유틸리티 클래스)

  /// 보이는 셀들만 포함한 행들 생성
  static List<BasicTableRow> createVisibleRows(
    List<BasicTableRow> allRows,
    List<int> visibleColumnIndices,
  ) {
    return allRows
        .map((row) => _createFilteredRow(row, visibleColumnIndices))
        .toList();
  }

  /// 특정 인덱스들의 셀만 포함한 새로운 행 생성
  static BasicTableRow _createFilteredRow(
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

  /// 정렬 상태 정보를 문자열로 생성
  static String generateSortInfo(
      ColumnSortManager sortManager, List<BasicTableColumn> visibleColumns) {
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

    return sortInfo.toString();
  }

  /// Visibility 상태 정보를 문자열로 생성
  static String generateVisibilityInfo(
    List<BasicTableColumn> allColumns,
    List<BasicTableColumn> visibleColumns,
    Set<String> hiddenColumnIds,
  ) {
    final visibilityInfo = StringBuffer();
    visibilityInfo.writeln('👁️ 컬럼 Visibility 정보:');
    visibilityInfo.writeln('');

    visibilityInfo.writeln('보이는 컬럼: ${visibleColumns.length}개');
    visibilityInfo.writeln('숨겨진 컬럼: ${hiddenColumnIds.length}개');
    visibilityInfo.writeln('');

    visibilityInfo.writeln('📋 전체 컬럼 상태:');
    for (int i = 0; i < allColumns.length; i++) {
      final column = allColumns[i];
      final isVisible = !hiddenColumnIds.contains(column.effectiveId);
      final icon = isVisible ? '👁️' : '🙈';
      visibilityInfo.writeln('  [$i] ${column.name} $icon');
    }

    if (hiddenColumnIds.isNotEmpty) {
      visibilityInfo.writeln('');
      visibilityInfo.writeln('숨겨진 컬럼들: ${hiddenColumnIds.join(', ')}');
    }

    return visibilityInfo.toString();
  }

  /// 높이 정보를 문자열로 생성
  static String generateHeightInfo(List<BasicTableRow> visibleRows) {
    final heightInfo = StringBuffer();
    heightInfo.writeln('📏 행별 높이 정보:');
    heightInfo.writeln('');

    for (int i = 0; i < visibleRows.length && i < 10; i++) {
      final row = visibleRows[i];
      final effectiveHeight = row.getEffectiveHeight(45.0);
      final hasCustom = row.hasCustomHeight ? ' (커스텀)' : ' (테마 기본값)';
      heightInfo.writeln('Row ${i + 1}: ${effectiveHeight}px$hasCustom');
    }

    if (visibleRows.length > 10) {
      heightInfo.writeln('... (총 ${visibleRows.length}개 행)');
    }

    return heightInfo.toString();
  }

  /// 선택된 항목 정보를 문자열로 생성
  static String generateSelectedItemsInfo(Set<int> selectedRows) {
    return '선택된 행들의 인덱스:\n${selectedRows.toList()..sort()}';
  }
}
