import 'selectable_cell.dart';

/// SelectableTable에서 사용하는 행 모델
///
/// 선택 기능이 있는 테이블의 개별 행 데이터를 정의합니다.
class SelectableRow {
  /// 행 인덱스
  final int index;

  /// 셀 데이터 리스트
  final List<SelectableCell> cells;

  /// 행 높이 (null이면 기본 높이 사용)
  final double? height;

  const SelectableRow({
    required this.index,
    required this.cells,
    this.height,
  });

  /// 텍스트 리스트로 행 생성 팩토리
  factory SelectableRow.fromTexts(
    int index,
    List<String> texts, {
    double? height,
  }) {
    final cells = texts.map((text) => SelectableCell.text(text)).toList();

    return SelectableRow(
      index: index,
      cells: cells,
      height: height,
    );
  }

  /// 셀 개수
  int get cellCount => cells.length;

  /// 특정 인덱스의 셀 가져오기
  SelectableCell? getCell(int cellIndex) {
    if (cellIndex < 0 || cellIndex >= cells.length) return null;
    return cells[cellIndex];
  }

  /// 특정 인덱스의 셀 텍스트 가져오기
  String getCellText(int cellIndex) {
    final cell = getCell(cellIndex);
    return cell?.displayText ?? '';
  }

  /// 모든 셀의 텍스트를 리스트로 반환
  List<String> get allCellTexts {
    return cells.map((cell) => cell.displayText ?? '').toList();
  }

  /// 새로운 셀을 추가한 복사본 반환
  SelectableRow addCell(SelectableCell cell) {
    final newCells = List<SelectableCell>.from(cells)..add(cell);
    return SelectableRow(
      index: index,
      cells: newCells,
      height: height,
    );
  }

  /// 특정 인덱스의 셀을 교체한 복사본 반환
  SelectableRow replaceCell(int cellIndex, SelectableCell newCell) {
    if (cellIndex < 0 || cellIndex >= cells.length) return this;

    final newCells = List<SelectableCell>.from(cells);
    newCells[cellIndex] = newCell;

    return SelectableRow(
      index: index,
      cells: newCells,
      height: height,
    );
  }

  /// 특정 컬럼의 값으로 정렬 비교를 위한 값 반환
  String getComparableValue(int columnIndex) {
    return getCellText(columnIndex);
  }

  SelectableRow copyWith({
    int? index,
    List<SelectableCell>? cells,
    double? height,
  }) {
    return SelectableRow(
      index: index ?? this.index,
      cells: cells ?? this.cells,
      height: height ?? this.height,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SelectableRow &&
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
    return 'SelectableRow(index: $index, cellCount: $cellCount)';
  }

  // 리스트 비교를 위한 헬퍼 함수
  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
