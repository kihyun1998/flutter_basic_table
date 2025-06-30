// lib/src/selectable/theme/selectable_border_theme.dart
import 'package:flutter/material.dart';

/// SelectableTable 테두리의 테마
class SelectableBorderTheme {
  /// 테이블 외곽 테두리
  final BorderSide? tableBorder;

  /// 헤더 테두리
  final BorderSide? headerBorder;

  /// 행 테두리
  final BorderSide? rowBorder;

  /// 셀 테두리 (세로 구분선)
  final BorderSide? cellBorder;

  const SelectableBorderTheme({
    this.tableBorder,
    this.headerBorder,
    this.rowBorder,
    this.cellBorder,
  });

  /// 기본 테마
  factory SelectableBorderTheme.defaultTheme() {
    return const SelectableBorderTheme(
      tableBorder: BorderSide(color: Colors.black, width: 0.5),
      headerBorder: BorderSide(color: Colors.grey, width: 1.0),
      rowBorder: BorderSide(color: Colors.grey, width: 0.3),
      cellBorder: BorderSide.none,
    );
  }

  SelectableBorderTheme copyWith({
    BorderSide? tableBorder,
    BorderSide? headerBorder,
    BorderSide? rowBorder,
    BorderSide? cellBorder,
  }) {
    return SelectableBorderTheme(
      tableBorder: tableBorder ?? this.tableBorder,
      headerBorder: headerBorder ?? this.headerBorder,
      rowBorder: rowBorder ?? this.rowBorder,
      cellBorder: cellBorder ?? this.cellBorder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SelectableBorderTheme &&
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
