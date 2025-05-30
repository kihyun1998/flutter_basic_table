// ignore_for_file: public_member_api_docs, sort_constructors_first
/// 테이블 행 데이터를 나타내는 모델
class BasicTableRow {
  final List<String> cells;
  final int index;

  const BasicTableRow({
    required this.cells,
    required this.index,
  });

  BasicTableRow copyWith({
    List<String>? cells,
    int? index,
  }) {
    return BasicTableRow(
      cells: cells ?? this.cells,
      index: index ?? this.index,
    );
  }
}
