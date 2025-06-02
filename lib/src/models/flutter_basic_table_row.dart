import 'package:flutter/material.dart';

import 'flutter_basic_table_cell.dart';

/// 테이블 행 데이터를 나타내는 모델
class BasicTableRow {
  final List<BasicTableCell> cells;
  final int index;

  /// 개별 행의 높이 (null이면 테마 높이 사용)
  final double? height;

  const BasicTableRow({
    required this.cells,
    required this.index,
    this.height,
  });

  /// String 리스트로부터 BasicTableRow 생성 (하위 호환성)
  factory BasicTableRow.fromStrings({
    required List<String> cells,
    required int index,
    double? height,
  }) {
    return BasicTableRow(
      cells: cells.map((str) => BasicTableCell.fromString(str)).toList(),
      index: index,
      height: height,
    );
  }

  /// 편의 생성자 - 텍스트 셀들로 구성
  factory BasicTableRow.text({
    required List<String> texts,
    required int index,
    double? height,
    TextStyle? style,
    Color? backgroundColor,
    Alignment? alignment,
    EdgeInsets? padding,
  }) {
    return BasicTableRow(
      cells: texts
          .map((text) => BasicTableCell.text(
                text,
                style: style,
                backgroundColor: backgroundColor,
                alignment: alignment,
                padding: padding,
              ))
          .toList(),
      index: index,
      height: height,
    );
  }

  /// 높이가 설정된 행 생성 (편의 메서드)
  factory BasicTableRow.withHeight({
    required List<BasicTableCell> cells,
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

  /// 특정 인덱스의 셀 반환 (안전한 접근)
  BasicTableCell? cellAt(int index) {
    if (index < 0 || index >= cells.length) return null;
    return cells[index];
  }

  /// 모든 셀의 텍스트 데이터를 String 리스트로 반환 (하위 호환성)
  List<String> get cellTexts {
    return cells.map((cell) => cell.displayText ?? '').toList();
  }

  /// 현재 행의 실제 높이 반환 (개별 높이가 있으면 그것을, 없으면 테마 높이)
  double getEffectiveHeight(double themeHeight) {
    return height ?? themeHeight;
  }

  /// 커스텀 높이가 설정되어 있는지 확인
  bool get hasCustomHeight => height != null;

  /// 새로운 셀을 추가한 복사본 반환
  BasicTableRow addCell(BasicTableCell cell) {
    return BasicTableRow(
      cells: [...cells, cell],
      index: index,
      height: height,
    );
  }

  /// 특정 인덱스의 셀을 교체한 복사본 반환
  BasicTableRow replaceCell(int cellIndex, BasicTableCell newCell) {
    if (cellIndex < 0 || cellIndex >= cells.length) return this;

    final newCells = List<BasicTableCell>.from(cells);
    newCells[cellIndex] = newCell;

    return BasicTableRow(
      cells: newCells,
      index: index,
      height: height,
    );
  }

  /// 특정 인덱스의 셀을 제거한 복사본 반환
  BasicTableRow removeCell(int cellIndex) {
    if (cellIndex < 0 || cellIndex >= cells.length) return this;

    final newCells = List<BasicTableCell>.from(cells);
    newCells.removeAt(cellIndex);

    return BasicTableRow(
      cells: newCells,
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

  /// 컬럼 순서 변경을 위한 셀 재정렬 (외부 상태 관리용)
  BasicTableRow reorderCells(int oldIndex, int newIndex) {
    if (oldIndex < 0 ||
        oldIndex >= cells.length ||
        newIndex < 0 ||
        newIndex >= cells.length ||
        oldIndex == newIndex) {
      return this;
    }

    // newIndex 보정 (ReorderableListView와 동일한 로직)
    final int adjustedNewIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;

    final newCells = List<BasicTableCell>.from(cells);
    final BasicTableCell movedCell = newCells.removeAt(oldIndex);
    newCells.insert(adjustedNewIndex, movedCell);

    return BasicTableRow(
      cells: newCells,
      index: index,
      height: height, // 높이 정보 유지
    );
  }

  /// 정렬을 위한 특정 셀의 비교 가능한 값 반환
  String getComparableValue(int cellIndex) {
    if (cellIndex < 0 || cellIndex >= cells.length) return '';
    return cells[cellIndex].displayText ?? '';
  }

  /// 정렬을 위한 특정 셀의 숫자 값 반환 (숫자가 아니면 null)
  num? getNumericValue(int cellIndex) {
    final textValue = getComparableValue(cellIndex);
    return num.tryParse(textValue);
  }

  BasicTableRow copyWith({
    List<BasicTableCell>? cells,
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
        _listEquals(other.cells, cells);
  }

  @override
  int get hashCode {
    return Object.hash(index, height, Object.hashAll(cells));
  }

  @override
  String toString() {
    return 'BasicTableRow(index: $index, height: $height, cells: $cells)';
  }

  // List 비교를 위한 헬퍼 함수
  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
