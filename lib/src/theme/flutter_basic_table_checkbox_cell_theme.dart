import 'package:flutter/material.dart';

/// Defines the theme for the checkbox column and individual checkboxes within the [BasicTable].
class BasicTableCheckboxCellTheme {
  /// Whether the checkbox column is enabled and visible.
  /// Defaults to `false`.
  final bool enabled;

  /// The fixed width of the checkbox column.
  /// Defaults to 60.0.
  final double columnWidth;

  /// The padding around the checkbox within its cell.
  /// Defaults to `EdgeInsets.all(8.0)`.
  final EdgeInsets? padding;

  /// The color of the checkbox when it is checked.
  /// If `null`, the Material default active color is used.
  final Color? activeColor;

  /// The color of the checkmark icon when the checkbox is checked.
  /// If `null`, the Material default check color is used.
  final Color? checkColor;

  /// Creates a [BasicTableCheckboxCellTheme] instance.
  ///
  /// All parameters have default values.
  const BasicTableCheckboxCellTheme({
    this.enabled = false,
    this.columnWidth = 60.0,
    this.padding = const EdgeInsets.all(8.0),
    this.activeColor,
    this.checkColor,
  });

  /// Creates a copy of this [BasicTableCheckboxCellTheme] with the given fields replaced
  /// with new values.
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
}
