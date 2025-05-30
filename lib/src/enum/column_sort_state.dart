/// 컬럼 정렬 상태를 나타내는 enum
enum ColumnSortState {
  none, // 정렬 안됨 (원래 상태)
  ascending, // 오름차순
  descending, // 내림차순
}

/// 정렬 정보를 담는 모델
class ColumnSortInfo {
  final int columnIndex;
  final ColumnSortState state;

  const ColumnSortInfo({
    required this.columnIndex,
    required this.state,
  });

  ColumnSortInfo copyWith({
    int? columnIndex,
    ColumnSortState? state,
  }) {
    return ColumnSortInfo(
      columnIndex: columnIndex ?? this.columnIndex,
      state: state ?? this.state,
    );
  }
}
