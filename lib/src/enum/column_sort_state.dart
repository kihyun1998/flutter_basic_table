/// Represents the sorting state of a table column.
enum ColumnSortState {
  /// No sorting applied (default state).
  none,

  /// Sorted in ascending order.
  ascending,

  /// Sorted in descending order.
  descending,
}

/// A model to hold information about a column's sorting state.
///
/// This class is primarily used for internal state management or for backward
/// compatibility with index-based sorting.
class ColumnSortInfo {
  /// The visible index of the column.
  final int columnIndex;

  /// The sorting state of the column.
  final ColumnSortState state;

  /// Creates a [ColumnSortInfo] instance.
  const ColumnSortInfo({
    required this.columnIndex,
    required this.state,
  });

  /// Creates a copy of this [ColumnSortInfo] with the given fields replaced
  /// with new values.
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
