import 'package:flutter/material.dart';

/// 테두리의 테마
class BasicTableBorderTheme {
  final BorderSide? tableBorder;
  final BorderSide? headerBorder;
  final BorderSide? rowBorder;
  final BorderSide? cellBorder;

  const BasicTableBorderTheme({
    this.tableBorder = const BorderSide(color: Colors.black, width: 0.5),
    this.headerBorder = const BorderSide(color: Colors.grey, width: 2.0),
    this.rowBorder = const BorderSide(color: Colors.grey, width: 0.3),
    this.cellBorder = BorderSide.none,
  });

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableBorderTheme &&
        other.tableBorder == tableBorder &&
        other.headerBorder == headerBorder &&
        other.rowBorder == rowBorder &&
        other.cellBorder == cellBorder;
  }

  @override
  int get hashCode {
    return Object.hash(tableBorder, headerBorder, rowBorder, cellBorder);
  }
}
