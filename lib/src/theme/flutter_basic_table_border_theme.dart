import 'package:flutter/material.dart';

/// Defines the theme for the borders within the [BasicTable].
class BasicTableBorderTheme {
  /// The border around the entire table.
  final BorderSide? tableBorder;

  /// The border for the table header section.
  final BorderSide? headerBorder;

  /// The border for individual data rows.
  final BorderSide? rowBorder;

  /// The border for individual cells within data rows.
  final BorderSide? cellBorder;

  /// Creates a [BasicTableBorderTheme] instance.
  ///
  /// All parameters have default values.
  const BasicTableBorderTheme({
    this.tableBorder = const BorderSide(color: Colors.black, width: 0.5),
    this.headerBorder = const BorderSide(color: Colors.grey, width: 2.0),
    this.rowBorder = const BorderSide(color: Colors.grey, width: 0.3),
    this.cellBorder = BorderSide.none,
  });

  /// Creates a copy of this [BasicTableBorderTheme] with the given fields replaced
  /// with new values.
  BasicTableBorderTheme copyWith({
    BorderSide? tableBorder,
    BorderSide? headerBorder,
    BorderSide? rowBorder,
    BorderSide? cellBorder,
  }) {
    return BasicTableBorderTheme(
      tableBorder: tableBorder ?? this.tableBorder,
      headerBorder: headerBorder ?? this.headerBorder,
      rowBorder: rowBorder ?? this.rowBorder,
      cellBorder: cellBorder ?? this.cellBorder,
    );
  }
}
