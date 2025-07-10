import 'package:flutter/material.dart';

/// 체크박스 셀의 테마
class BasicTableCheckboxCellTheme {
  final bool enabled;
  final double columnWidth;
  final EdgeInsets? padding;
  final Color? activeColor;
  final Color? checkColor;

  const BasicTableCheckboxCellTheme({
    this.enabled = false,
    this.columnWidth = 60.0,
    this.padding = const EdgeInsets.all(8.0),
    this.activeColor,
    this.checkColor,
  });

  BasicTableCheckboxCellTheme copyWith({
    bool? enabled,
    double? columnWidth,
    EdgeInsets? padding,
    Color? activeColor,
    Color? checkColor,
  }) {
    return BasicTableCheckboxCellTheme(
      enabled: enabled ?? this.enabled,
      columnWidth: columnWidth ?? this.columnWidth,
      padding: padding ?? this.padding,
      activeColor: activeColor ?? this.activeColor,
      checkColor: checkColor ?? this.checkColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableCheckboxCellTheme &&
        other.enabled == enabled &&
        other.columnWidth == columnWidth &&
        other.padding == padding &&
        other.activeColor == activeColor &&
        other.checkColor == checkColor;
  }

  @override
  int get hashCode {
    return Object.hash(enabled, columnWidth, padding, activeColor, checkColor);
  }
}
