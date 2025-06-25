import 'package:flutter/material.dart';

import 'flutter_basic_table_cell.dart';

/// 테이블 행 데이터를 나타내는 모델
class BasicTableRow {
  /// 컬럼 ID를 키로 하는 셀 데이터 Map
  final Map<String, BasicTableCell> cells;

  final int index;

  /// 개별 행의 높이 (null이면 테마 높이 사용)
  final double? height;

  const BasicTableRow({
    required this.cells,
    required this.index,
    this.height,
  });

  /// Map과 String 리스트로부터 BasicTableRow 생성
  factory BasicTableRow.fromStrings({
    required Map<String, String> cellTexts,
    required int index,
    double? height,
  }) {
    final Map<String, BasicTableCell> cells = {};

    for (final entry in cellTexts.entries) {
      cells[entry.key] = BasicTableCell.fromString(entry.value);
    }

    return BasicTableRow(
      cells: cells,
      index: index,
      height: height,
    );
  }

  /// 순서가 있는 컬럼 리스트와 텍스트 리스트로 생성 (순서 기반)
  factory BasicTableRow.fromOrderedStrings({
    required List<String> columnIds,
    required List<String> cellTexts,
    required int index,
    double? height,
  }) {
    assert(columnIds.length == cellTexts.length,
        'columnIds and cellTexts must have same length');

    final Map<String, BasicTableCell> cells = {};

    for (int i = 0; i < columnIds.length; i++) {
      cells[columnIds[i]] = BasicTableCell.fromString(cellTexts[i]);
    }

    return BasicTableRow(
      cells: cells,
      index: index,
      height: height,
    );
  }

  /// 편의 생성자 - 텍스트 셀들로 구성
  factory BasicTableRow.text({
    required Map<String, String> cellTexts,
    required int index,
    double? height,
    TextStyle? style,
    Color? backgroundColor,
    Alignment? alignment,
    EdgeInsets? padding,
  }) {
    final Map<String, BasicTableCell> cells = {};

    for (final entry in cellTexts.entries) {
      cells[entry.key] = BasicTableCell.text(
        entry.value,
        style: style,
        backgroundColor: backgroundColor,
        alignment: alignment,
        padding: padding,
      );
    }

    return BasicTableRow(
      cells: cells,
      index: index,
      height: height,
    );
  }

  /// 높이가 설정된 행 생성 (편의 메서드)
  factory BasicTableRow.withHeight({
    required Map<String, BasicTableCell> cells,
    required int index,
    required double height,
  }) {
    return BasicTableRow(
      cells: cells,
      index: index,
      height: height,
    );
  }

  /// 셀 개수 반환
  int get cellCount => cells.length;

  /// 특정 컬럼 ID의 셀 반환 (안전한 접근)
  BasicTableCell? getCell(String columnId) {
    return cells[columnId];
  }

  /// 특정 컬럼 ID의 셀 반환 (기본값 제공)
  BasicTableCell getCellOrDefault(String columnId,
      {BasicTableCell? defaultCell}) {
    return cells[columnId] ?? defaultCell ?? BasicTableCell.text('');
  }

  /// 컬럼 순서에 따른 셀 텍스트 리스트 반환
  List<String> getCellTexts(List<String> columnOrder) {
    return columnOrder.map((columnId) {
      final cell = cells[columnId];
      return cell?.displayText ?? '';
    }).toList();
  }

  /// 모든 셀의 텍스트를 Map으로 반환
  Map<String, String> get allCellTexts {
    final Map<String, String> result = {};

    for (final entry in cells.entries) {
      result[entry.key] = entry.value.displayText ?? '';
    }

    return result;
  }

  /// 현재 행의 실제 높이 반환 (개별 높이가 있으면 그것을, 없으면 테마 높이)
  double getEffectiveHeight(double themeHeight) {
    return height ?? themeHeight;
  }

  /// 커스텀 높이가 설정되어 있는지 확인
  bool get hasCustomHeight => height != null;

  /// 특정 컬럼에 셀이 있는지 확인
  bool hasCell(String columnId) {
    return cells.containsKey(columnId);
  }

  /// 새로운 셀을 추가한 복사본 반환
  BasicTableRow addCell(String columnId, BasicTableCell cell) {
    final newCells = Map<String, BasicTableCell>.from(cells);
    newCells[columnId] = cell;

    return BasicTableRow(
      cells: newCells,
      index: index,
      height: height,
    );
  }

  /// 특정 컬럼의 셀을 교체한 복사본 반환
  BasicTableRow replaceCell(String columnId, BasicTableCell newCell) {
    final newCells = Map<String, BasicTableCell>.from(cells);
    newCells[columnId] = newCell;

    return BasicTableRow(
      cells: newCells,
      index: index,
      height: height,
    );
  }

  /// 특정 컬럼의 셀을 제거한 복사본 반환
  BasicTableRow removeCell(String columnId) {
    final newCells = Map<String, BasicTableCell>.from(cells);
    newCells.remove(columnId);

    return BasicTableRow(
      cells: newCells,
      index: index,
      height: height,
    );
  }

  /// 여러 셀을 한번에 추가/교체한 복사본 반환
  BasicTableRow updateCells(Map<String, BasicTableCell> newCells) {
    final updatedCells = Map<String, BasicTableCell>.from(cells);
    updatedCells.addAll(newCells);

    return BasicTableRow(
      cells: updatedCells,
      index: index,
      height: height,
    );
  }

  /// 높이를 변경한 복사본 반환
  BasicTableRow withNewHeight(double? newHeight) {
    return BasicTableRow(
      cells: cells,
      index: index,
      height: newHeight,
    );
  }

  /// 정렬을 위한 특정 컬럼의 비교 가능한 값 반환
  String getComparableValue(String columnId) {
    final cell = cells[columnId];
    return cell?.displayText ?? '';
  }

  /// 정렬을 위한 특정 컬럼의 숫자 값 반환 (숫자가 아니면 null)
  num? getNumericValue(String columnId) {
    final textValue = getComparableValue(columnId);
    return num.tryParse(textValue);
  }

  /// 특정 컬럼들만 포함하는 새로운 행 생성 (필터링)
  BasicTableRow filterColumns(Set<String> columnIds) {
    final filteredCells = <String, BasicTableCell>{};

    for (final columnId in columnIds) {
      if (cells.containsKey(columnId)) {
        filteredCells[columnId] = cells[columnId]!;
      }
    }

    return BasicTableRow(
      cells: filteredCells,
      index: index,
      height: height,
    );
  }

  /// 컬럼 순서에 따라 정렬된 셀 리스트 반환 (렌더링용)
  List<BasicTableCell> getSortedCells(List<String> columnOrder) {
    return columnOrder.map((columnId) {
      return cells[columnId] ?? BasicTableCell.text(''); // 없으면 빈 셀
    }).toList();
  }

  /// 누락된 컬럼들을 기본 셀로 채운 복사본 반환
  BasicTableRow fillMissingColumns(Set<String> requiredColumnIds,
      {BasicTableCell? defaultCell}) {
    final newCells = Map<String, BasicTableCell>.from(cells);
    final defaultCellValue = defaultCell ?? BasicTableCell.text('');

    for (final columnId in requiredColumnIds) {
      if (!newCells.containsKey(columnId)) {
        newCells[columnId] = defaultCellValue;
      }
    }

    return BasicTableRow(
      cells: newCells,
      index: index,
      height: height,
    );
  }

  /// 데이터 검증 - 중복 컬럼 ID 체크 등
  bool isValid() {
    // Map 자체가 중복 키를 허용하지 않으므로 기본적으로 유효
    // 추가 검증 로직이 필요하면 여기에 구현
    return cells.isNotEmpty;
  }

  BasicTableRow copyWith({
    Map<String, BasicTableCell>? cells,
    int? index,
    double? height,
  }) {
    return BasicTableRow(
      cells: cells ?? this.cells,
      index: index ?? this.index,
      height: height ?? this.height,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableRow &&
        other.index == index &&
        other.height == height &&
        _mapEquals(other.cells, cells);
  }

  @override
  int get hashCode {
    return Object.hash(index, height, Object.hashAllUnordered(cells.entries));
  }

  @override
  String toString() {
    return 'BasicTableRow(index: $index, height: $height, cells: ${cells.keys.toList()})';
  }

  // Map 비교를 위한 헬퍼 함수
  bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
    if (a.length != b.length) return false;

    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) {
        return false;
      }
    }

    return true;
  }
}
