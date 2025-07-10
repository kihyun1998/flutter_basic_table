import 'package:flutter/material.dart';

/// Defines the theme for row selection and hover states within the [BasicTable].
class BasicTableSelectionTheme {
  /// The background color of a row when it is selected.
  /// Defaults to `Colors.blue.withOpacity(0.1)`.
  final Color? selectedRowColor;

  /// The background color of a row when it is hovered over by the mouse.
  /// Defaults to `Colors.grey.withOpacity(0.05)`.
  final Color? hoverRowColor;

  /// Creates a [BasicTableSelectionTheme] instance.
  ///
  /// All parameters have default values.
  const BasicTableSelectionTheme({
    this.selectedRowColor = const Color(0x1A2196F3),
    this.hoverRowColor = const Color(0x0D9E9E9E),
  });

  /// Creates a copy of this [BasicTableSelectionTheme] with the given fields replaced
  /// with new values.
  BasicTableSelectionTheme copyWith({
    Color? selectedRowColor,
    Color? hoverRowColor,
  }) {
    return BasicTableSelectionTheme(
      selectedRowColor: selectedRowColor ?? this.selectedRowColor,
      hoverRowColor: hoverRowColor ?? this.hoverRowColor,
    );
  }
}
