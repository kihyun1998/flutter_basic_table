import 'package:flutter_basic_table/flutter_basic_table.dart';

/// Manages the sorting state of columns based on their unique IDs.
///
/// This class ensures that sorting states persist correctly even if column
/// order changes, as it tracks sorting by column ID rather than by visible index.
class ColumnSortManager {
  /// Internal storage for column sorting states, keyed by column ID.
  final Map<String, ColumnSortState> _sortStates = {};

  /// The ID of the column that is currently sorted. Only one column can be
  /// sorted at a time. If no column is sorted, this will be `null`.
  String? _currentSortedColumnId;

  /// Creates a new [ColumnSortManager] instance.
  ColumnSortManager();

  /// Creates a [ColumnSortManager] from an index-based map of sorting states.
  ///
  /// This factory is primarily for backward compatibility with older APIs
  /// that managed sorting by visible column index.
  ///
  /// [indexMap]: A map where keys are visible column indices and values are their sort states.
  /// [sortedColumns]: A list of [BasicTableColumn] objects, sorted by their `order`,
  ///   representing the current visible order of columns.
  ColumnSortManager.fromIndexMap(
    Map<int, ColumnSortState> indexMap,
    List<BasicTableColumn> sortedColumns,
  ) {
    for (final entry in indexMap.entries) {
      final int index = entry.key;
      final ColumnSortState state = entry.value;

      if (index >= 0 && index < sortedColumns.length) {
        final String columnId = sortedColumns[index].id;
        _sortStates[columnId] = state;

        if (state != ColumnSortState.none) {
          _currentSortedColumnId = columnId;
        }
      }
    }
  }

  /// Creates a [ColumnSortManager] from a map of [BasicTableColumn] objects
  /// and an ID-based map of sorting states.
  ///
  /// [columns]: A map of all available [BasicTableColumn] objects, keyed by their IDs.
  /// [sortStates]: A map where keys are column IDs and values are their sort states.
  ColumnSortManager.fromColumnMap(
    Map<String, BasicTableColumn> columns,
    Map<String, ColumnSortState> sortStates,
  ) {
    for (final entry in sortStates.entries) {
      final columnId = entry.key;
      final state = entry.value;

      if (columns.containsKey(columnId)) {
        _sortStates[columnId] = state;

        if (state != ColumnSortState.none) {
          _currentSortedColumnId = columnId;
        }
      }
    }
  }

  /// Retrieves the sorting state for a specific column by its ID.
  ///
  /// Returns [ColumnSortState.none] if the column is not found or has no active sorting state.
  ColumnSortState getSortState(String columnId) {
    return _sortStates[columnId] ?? ColumnSortState.none;
  }

  /// Retrieves the sorting state for a column at a given visible index.
  ///
  /// This method is for backward compatibility. It's recommended to use
  /// [getSortState] with the column ID directly.
  ///
  /// [index]: The visible index of the column.
  /// [sortedColumns]: A list of [BasicTableColumn] objects, sorted by their `order`.
  ColumnSortState getSortStateByIndex(
      int index, List<BasicTableColumn> sortedColumns) {
    if (index < 0 || index >= sortedColumns.length) return ColumnSortState.none;
    return getSortState(sortedColumns[index].id);
  }

  /// Sets the sorting state for a specific column by its ID.
  ///
  /// When a column's state is set to anything other than [ColumnSortState.none],
  /// all other columns' sorting states are automatically reset to [ColumnSortState.none],
  /// ensuring only one column is sorted at a time.
  ///
  /// [columnId]: The ID of the column to update.
  /// [state]: The new [ColumnSortState] for the column.
  void setSortState(String columnId, ColumnSortState state) {
    // Reset sorting for all other columns (only one column can be sorted at a time)
    if (state != ColumnSortState.none) {
      _clearAllSortStates();
      _currentSortedColumnId = columnId;
    } else {
      _currentSortedColumnId = null;
    }

    _sortStates[columnId] = state;
  }

  /// Sets the sorting state for a column at a given visible index.
  ///
  /// This method is for backward compatibility. It's recommended to use
  /// [setSortState] with the column ID directly.
  ///
  /// [index]: The visible index of the column.
  /// [state]: The new [ColumnSortState] for the column.
  /// [sortedColumns]: A list of [BasicTableColumn] objects, sorted by their `order`.
  void setSortStateByIndex(
      int index, ColumnSortState state, List<BasicTableColumn> sortedColumns) {
    if (index < 0 || index >= sortedColumns.length) return;
    setSortState(sortedColumns[index].id, state);
  }

  /// Resets all column sorting states to [ColumnSortState.none] and clears
  /// the currently sorted column.
  void clearAll() {
    _sortStates.clear();
    _currentSortedColumnId = null;
  }

  /// Internal helper to set all existing sorting states to [ColumnSortState.none].
  void _clearAllSortStates() {
    for (final key in _sortStates.keys) {
      _sortStates[key] = ColumnSortState.none;
    }
  }

  /// Returns the ID of the column that is currently sorted.
  /// Returns `null` if no column is sorted.
  String? get currentSortedColumnId => _currentSortedColumnId;

  /// Returns the visible index of the currently sorted column.
  ///
  /// This method is for backward compatibility. It's recommended to use
  /// [currentSortedColumnId] directly.
  ///
  /// [sortedColumns]: A list of [BasicTableColumn] objects, sorted by their `order`.
  /// Returns `null` if no column is sorted or the sorted column is not found in the provided list.
  int? getCurrentSortedColumnIndex(List<BasicTableColumn> sortedColumns) {
    if (_currentSortedColumnId == null) return null;

    for (int i = 0; i < sortedColumns.length; i++) {
      if (sortedColumns[i].id == _currentSortedColumnId) {
        return i;
      }
    }
    return null;
  }

  /// Retrieves the [BasicTableColumn] object that is currently sorted.
  ///
  /// [columns]: A map of all available [BasicTableColumn] objects, keyed by their IDs.
  /// Returns `null` if no column is sorted or the sorted column is not found in the provided map.
  BasicTableColumn? getCurrentSortedColumn(
      Map<String, BasicTableColumn> columns) {
    if (_currentSortedColumnId == null) return null;
    return columns[_currentSortedColumnId];
  }

  /// Returns `true` if any column is currently sorted, `false` otherwise.
  bool get hasSortedColumn => _currentSortedColumnId != null;

  /// Returns a new map containing all stored sorting states, keyed by column ID.
  Map<String, ColumnSortState> get allSortStates {
    return Map<String, ColumnSortState>.from(_sortStates);
  }

  /// Returns a new map containing only the active sorting states (i.e., states not [ColumnSortState.none]),
  /// keyed by column ID.
  Map<String, ColumnSortState> get activeSortStates {
    final Map<String, ColumnSortState> result = {};

    for (final entry in _sortStates.entries) {
      if (entry.value != ColumnSortState.none) {
        result[entry.key] = entry.value;
      }
    }

    return result;
  }

  /// Converts the ID-based sorting states to an index-based map.
  ///
  /// This method is for backward compatibility. It's recommended to use
  /// the ID-based states directly.
  ///
  /// [sortedColumns]: A list of [BasicTableColumn] objects, sorted by their `order`.
  Map<int, ColumnSortState> toIndexMap(List<BasicTableColumn> sortedColumns) {
    final Map<int, ColumnSortState> indexMap = {};

    for (int i = 0; i < sortedColumns.length; i++) {
      final String columnId = sortedColumns[i].id;
      final ColumnSortState state = getSortState(columnId);

      if (state != ColumnSortState.none) {
        indexMap[i] = state;
      }
    }

    return indexMap;
  }

  /// Converts the ID-based sorting states to an index-based map, given a map of columns.
  ///
  /// This method is for backward compatibility. It's recommended to use
  /// the ID-based states directly.
  ///
  /// [columns]: A map of all available [BasicTableColumn] objects, keyed by their IDs.
  Map<int, ColumnSortState> toIndexMapFromColumnMap(
      Map<String, BasicTableColumn> columns) {
    final sortedColumns = BasicTableColumn.mapToSortedList(columns);
    return toIndexMap(sortedColumns);
  }

  /// Returns a new map containing sorting states only for the specified `columnIds`.
  ///
  /// [columnIds]: A set of column IDs to filter the sorting states by.
  Map<String, ColumnSortState> getFilteredSortStates(Set<String> columnIds) {
    final Map<String, ColumnSortState> result = {};

    for (final columnId in columnIds) {
      if (_sortStates.containsKey(columnId)) {
        result[columnId] = _sortStates[columnId]!;
      }
    }

    return result;
  }

  /// Removes sorting states for columns that are no longer visible (i.e., their IDs
  /// are not present in `visibleColumnIds`).
  ///
  /// If the currently sorted column becomes hidden, its sorting state is also cleared.
  /// [visibleColumnIds]: A set of IDs for currently visible columns.
  void cleanupHiddenColumns(Set<String> visibleColumnIds) {
    final keysToRemove = <String>[];

    for (final columnId in _sortStates.keys) {
      if (!visibleColumnIds.contains(columnId)) {
        keysToRemove.add(columnId);
      }
    }

    for (final key in keysToRemove) {
      _sortStates.remove(key);

      // If the currently sorted column is hidden, clear it
      if (_currentSortedColumnId == key) {
        _currentSortedColumnId = null;
      }
    }
  }

  /// Validates if all stored sorting states correspond to existing columns.
  ///
  /// [columns]: A map of all available [BasicTableColumn] objects, keyed by their IDs.
  /// Returns `true` if all sorting states are valid, `false` otherwise.
  bool isValid(Map<String, BasicTableColumn> columns) {
    // Check if all column IDs in sort states exist in the actual columns
    for (final columnId in _sortStates.keys) {
      if (!columns.containsKey(columnId)) {
        return false;
      }
    }

    // Check if the currently sorted column exists
    if (_currentSortedColumnId != null &&
        !columns.containsKey(_currentSortedColumnId)) {
      return false;
    }

    return true;
  }

  /// Cleans up any invalid sorting states (i.e., states for non-existent columns).
  ///
  /// [columns]: A map of all available [BasicTableColumn] objects, keyed by their IDs.
  void cleanup(Map<String, BasicTableColumn> columns) {
    final keysToRemove = <String>[];

    for (final columnId in _sortStates.keys) {
      if (!columns.containsKey(columnId)) {
        keysToRemove.add(columnId);
      }
    }

    for (final key in keysToRemove) {
      _sortStates.remove(key);
    }

    // If the currently sorted column is invalid, clear it
    if (_currentSortedColumnId != null &&
        !columns.containsKey(_currentSortedColumnId)) {
      _currentSortedColumnId = null;
    }
  }

  /// Prints debug information about the current sorting states, based on a sorted list of columns.
  ///
  /// [sortedColumns]: A list of [BasicTableColumn] objects, sorted by their `order`.
  void printDebugInfo(List<BasicTableColumn> sortedColumns) {
    print('🔍 ColumnSortManager Debug Info:');
    print('   Current sorted column: $_currentSortedColumnId');
    print('   Sort states:');
    for (int i = 0; i < sortedColumns.length; i++) {
      final column = sortedColumns[i];
      final state = getSortState(column.id);
      print('     [$i] ${column.name} (${column.id}): $state');
    }
  }

  /// Prints debug information about the current sorting states, based on a map of columns.
  ///
  /// [columns]: A map of all available [BasicTableColumn] objects, keyed by their IDs.
  void printDebugInfoFromMap(Map<String, BasicTableColumn> columns) {
    final sortedColumns = BasicTableColumn.mapToSortedList(columns);
    printDebugInfo(sortedColumns);
  }

  /// Prints a summary of the current sorting state.
  void printSummary() {
    print(
        '🔍 Sort Summary: ${_currentSortedColumnId ?? 'None'} (${_sortStates.length} states)');
  }

  /// Creates a deep copy of this [ColumnSortManager] instance.
  ColumnSortManager copy() {
    final manager = ColumnSortManager();
    manager._sortStates.addAll(_sortStates);
    manager._currentSortedColumnId = _currentSortedColumnId;
    return manager;
  }

  /// Merges the sorting states from another [ColumnSortManager] into this one.
  ///
  /// This operation clears the current states of this manager and then copies
  /// all states from the `other` manager.
  void mergeWith(ColumnSortManager other) {
    // Clear existing states
    clearAll();

    // Copy states from other
    _sortStates.addAll(other._sortStates);
    _currentSortedColumnId = other._currentSortedColumnId;
  }

  @override
  String toString() {
    return 'ColumnSortManager(currentSorted: $_currentSortedColumnId, states: $_sortStates)';
  }

  /// Serializes the [ColumnSortManager] instance to a JSON-like map.
  ///
  /// Returns a [Map] containing the `currentSortedColumnId` and a map of `sortStates`
  /// where [ColumnSortState] enums are represented by their names.
  Map<String, dynamic> toJson() {
    return {
      'currentSortedColumnId': _currentSortedColumnId,
      'sortStates': _sortStates.map((key, value) => MapEntry(key, value.name)),
    };
  }

  /// Deserializes a [ColumnSortManager] instance from a JSON-like map.
  ///
  /// [json]: A map containing `currentSortedColumnId` and `sortStates`.
  factory ColumnSortManager.fromJson(Map<String, dynamic> json) {
    final manager = ColumnSortManager();

    manager._currentSortedColumnId = json['currentSortedColumnId'];

    final sortStatesMap = json['sortStates'] as Map<String, dynamic>? ?? {};
    for (final entry in sortStatesMap.entries) {
      final state = ColumnSortState.values.firstWhere(
        (s) => s.name == entry.value,
        orElse: () => ColumnSortState.none,
      );
      manager._sortStates[entry.key] = state;
    }

    return manager;
  }
}
