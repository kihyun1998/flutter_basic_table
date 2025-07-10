import 'package:flutter/material.dart';

/// Defines the theme for the data rows within the [BasicTable].
class BasicTableDataRowTheme {
  /// The default height of each data row.
  /// Individual rows can override this height using [BasicTableRow.height].
  /// Defaults to 45.0.
  final double height;

  /// The background color of the data rows.
  /// Defaults to `Colors.white`.
  final Color? backgroundColor;

  /// The default text style for cells within the data rows.
  /// Individual cells can override this style using [BasicTableCell.style].
  /// Defaults to `TextStyle(fontSize: 13, color: Colors.black)`.
  final TextStyle? textStyle;

  /// The default padding for cells within the data rows.
  /// Individual cells can override this padding using [BasicTableCell.padding].
  /// Defaults to `EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0)`.
  final EdgeInsets? padding;

  /// The border applied to each data row.
  /// Defaults to `BorderSide(color: Colors.grey, width: 0.3)`.
  final BorderSide? border;

  /// The splash color for ink effects when a row is tapped.
  /// If `null`, the Material default splash color is used.
  final Color? splashColor;

  /// The highlight color for ink effects when a row is pressed.
  /// If `null`, the Material default highlight color is used.
  final Color? highlightColor;

  /// Creates a [BasicTableDataRowTheme] instance.
  ///
  /// All parameters have default values.
  const BasicTableDataRowTheme({
    this.height = 45.0,
    this.backgroundColor = Colors.white,
    this.textStyle = const TextStyle(fontSize: 13, color: Colors.black),
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    this.border = const BorderSide(color: Colors.grey, width: 0.3),
    this.splashColor,
    this.highlightColor,
  });

  /// Creates a copy of this [BasicTableDataRowTheme] with the given fields replaced
  /// with new values.
  BasicTableDataRowTheme copyWith({
    double? height,
    Color? backgroundColor,
    TextStyle? textStyle,
    EdgeInsets? padding,
    BorderSide? border,
    Color? splashColor,
    Color? highlightColor,
  }) {
    return BasicTableDataRowTheme(
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      border: border ?? this.border,
      splashColor: splashColor ?? this.splashColor,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableDataRowTheme &&
        other.height == height &&
        other.backgroundColor == backgroundColor &&
        other.textStyle == textStyle &&
        other.padding == padding &&
        other.border == border &&
        other.splashColor == splashColor &&
        other.highlightColor == highlightColor;
  }

  @override
  int get hashCode() {
    return Object.hash(
      height,
      backgroundColor,
      textStyle,
      padding,
      border,
      splashColor,
      highlightColor,
    );
  }
}
