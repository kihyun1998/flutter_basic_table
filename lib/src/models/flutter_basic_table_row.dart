import 'package:flutter/material.dart';

import 'flutter_basic_table_cell.dart';

/// A model representing a single row of data in the table.
///
/// Each row contains a collection of [BasicTableCell] objects, keyed by their
/// corresponding column IDs. It also provides methods for accessing, manipulating,
/// and transforming cell data within the row.
class BasicTableRow {
  /// A [Map] where keys are column IDs (String) and values are [BasicTableCell]
  /// objects representing the data for each cell in this row.
  final Map<String, BasicTableCell> cells;

  /// The unique index of this row within the table. This is typically the
  /// 0-based position of the row in the original data list.
  final int index;

  /// An optional custom height for this specific row.
  /// If `null`, the row will use the default height defined in [BasicTableThemeData.dataRowTheme.height].
  final double? height;

  /// Creates a [BasicTableRow] with the specified cells and index.
  const BasicTableRow({
    required this.cells,
    required this.index,
    this.height,
  });

  /// Creates a [BasicTableRow] from a [Map] of string data.
  ///
  /// Each entry in `cellTexts` represents a cell, where the key is the column ID
  /// and the value is the string content of the cell. These strings are converted
  /// into [BasicTableCell] objects using [BasicTableCell.fromString].
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

  /// Creates a [BasicTableRow] from an ordered list of column IDs and cell texts.
  ///
  /// This factory is useful when the order of cell data corresponds directly
  /// to a predefined list of column IDs.
  ///
  /// Throws an [AssertionError] if `columnIds` and `cellTexts` do not have the same length.
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

  /// Creates a [BasicTableRow] composed entirely of text cells.
  ///
  /// This factory allows applying a common style, background color, alignment,
  /// and padding to all text cells within the row.
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

  /// Creates a [BasicTableRow] with a predefined custom height.
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

  /// Returns the number of cells in this row.
  int get cellCount => cells.length;

  /// Retrieves a [BasicTableCell] by its `columnId`.
  ///
  /// Returns `null` if no cell exists for the given `columnId`.
  BasicTableCell? getCell(String columnId) {
    return cells[columnId];
  }

  /// Retrieves a [BasicTableCell] by its `columnId`, providing a default cell
  /// if the specified `columnId` does not exist.
  ///
  /// If `defaultCell` is not provided, an empty [BasicTableCell.text] is returned.
  BasicTableCell getCellOrDefault(String columnId,
      {BasicTableCell? defaultCell}) {
    return cells[columnId] ?? defaultCell ?? BasicTableCell.text('');
  }

  /// Returns a [List] of string representations of cells, ordered by the provided `columnOrder`.
  ///
  /// If a cell for a given `columnId` does not exist, an empty string is used.
  List<String> getCellTexts(List<String> columnOrder) {
    return columnOrder.map((columnId) {
      final cell = cells[columnId];
      return cell?.displayText ?? '';
    }).toList();
  }

  /// Returns a [Map] containing the string representation of all cells in this row,
  /// keyed by their column IDs.
  Map<String, String> get allCellTexts {
    final Map<String, String> result = {};

    for (final entry in cells.entries) {
      result[entry.key] = entry.value.displayText ?? '';
    }

    return result;
  }

  /// Calculates the effective height of the row.
  ///
  /// If a custom `height` is defined for this row, that value is returned.
  /// Otherwise, the `themeHeight` (typically from [BasicTableThemeData.dataRowTheme.height])
  /// is used.
  double getEffectiveHeight(double themeHeight) {
    return height ?? themeHeight;
  }

  /// Returns `true` if this row has a custom height defined, `false` otherwise.
  bool get hasCustomHeight => height != null;

  /// Checks if a cell exists for the given `columnId` in this row.
  bool hasCell(String columnId) {
    return cells.containsKey(columnId);
  }

  /// Returns a new [BasicTableRow] instance with an additional cell.
  ///
  /// If a cell with the given `columnId` already exists, it will be overwritten.
  BasicTableRow addCell(String columnId, BasicTableCell cell) {
    final newCells = Map<String, BasicTableCell>.from(cells);
    newCells[columnId] = cell;

    return BasicTableRow(
      cells: newCells,
      index: index,
      height: height,
    );
  }

  /// Returns a new [BasicTableRow] instance with a cell replaced at the specified `columnId`.
  ///
  /// If no cell exists for the `columnId`, it will be added.
  BasicTableRow replaceCell(String columnId, BasicTableCell newCell) {
    final newCells = Map<String, BasicTableCell>.from(cells);
    newCells[columnId] = newCell;

    return BasicTableRow(
      cells: newCells,
      index: index,
      height: height,
    );
  }

  /// Returns a new [BasicTableRow] instance with the cell at the specified `columnId` removed.
  ///
  /// If no cell exists for the `columnId`, the row remains unchanged.
  BasicTableRow removeCell(String columnId) {
    final newCells = Map<String, BasicTableCell>.from(cells);
    newCells.remove(columnId);

    return BasicTableRow(
      cells: newCells,
      index: index,
      height: height,
    );
  }

  /// Returns a new [BasicTableRow] instance with multiple cells added or replaced.
  ///
  /// Existing cells with matching `columnId`s will be updated; new cells will be added.
  BasicTableRow updateCells(Map<String, BasicTableCell> newCells) {
    final updatedCells = Map<String, BasicTableCell>.from(cells);
    updatedCells.addAll(newCells);

    return BasicTableRow(
      cells: updatedCells,
      index: index,
      height: height,
    );
  }

  /// Returns a new [BasicTableRow] instance with its height updated.
  ///
  /// If `newHeight` is `null`, the row will revert to using the theme's default height.
  BasicTableRow withNewHeight(double? newHeight) {
    return BasicTableRow(
      cells: cells,
      index: index,
      height: newHeight,
    );
  }

  /// Returns a comparable string value for a specific column, used primarily for sorting.
  ///
  /// This retrieves the `displayText` of the cell at the given `columnId`.
  /// Returns an empty string if the cell or its display text is `null`.
  String getComparableValue(String columnId) {
    final cell = cells[columnId];
    return cell?.displayText ?? '';
  }

  /// Returns the numeric value of a cell for a specific column, used for numeric sorting.
  ///
  /// Attempts to parse the cell's `displayText` as a number. Returns `null` if parsing fails.
  num? getNumericValue(String columnId) {
    final textValue = getComparableValue(columnId);
    return num.tryParse(textValue);
  }

  /// Returns a new [BasicTableRow] instance containing only the cells for the specified `columnIds`.
  ///
  /// Cells for `columnIds` not present in the original row will be omitted.
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

  /// Returns a [List] of [BasicTableCell] objects, ordered according to the provided `columnOrder`.
  ///
  /// If a cell for a given `columnId` does not exist, an empty [BasicTableCell.text] is returned as a placeholder.
  List<BasicTableCell> getSortedCells(List<String> columnOrder) {
    return columnOrder.map((columnId) {
      return cells[columnId] ?? BasicTableCell.text(''); // Return empty cell if not found
    }).toList();
  }

  /// Returns a new [BasicTableRow] instance where any missing cells (i.e., cells
  /// for `requiredColumnIds` that are not present in this row) are filled with
  /// a `defaultCell`.
  ///
  /// If `defaultCell` is not provided, an empty [BasicTableCell.text] is used.
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

  /// Performs basic data validation for the row.
  ///
  /// Currently, it checks if the `cells` map is not empty. Additional validation
  /// logic can be implemented here.
  bool isValid() {
    return cells.isNotEmpty;
  }

  /// Creates a copy of this [BasicTableRow] with the given fields replaced
  /// with new values.
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

  // Helper function for deep comparison of maps
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
