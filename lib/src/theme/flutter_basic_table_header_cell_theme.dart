import 'package:flutter/material.dart';

/// Defines the theme for the header cells within the [BasicTable].
class BasicTableHeaderCellTheme {
  /// The height of the header row.
  /// Defaults to 50.0.
  final double height;

  /// The background color of the header cells.
  /// Defaults to `Colors.white`.
  final Color? backgroundColor;

  /// The text style for the header cell titles.
  /// Defaults to `TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)`.
  final TextStyle? textStyle;

  /// The padding around the content within the header cells.
  /// Defaults to `EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0)`.
  final EdgeInsets? padding;

  /// The border applied to each header cell.
  /// Defaults to `BorderSide(color: Colors.grey, width: 2.0)`.
  final BorderSide? border;

  /// The color of the sort icons displayed in sortable header cells.
  /// Defaults to `Colors.blue`.
  final Color? sortIconColor;

  /// Whether column reordering is enabled for the table headers.
  /// Defaults to `false`.
  final bool enableReorder;

  /// Whether column sorting is enabled for the table headers.
  /// Defaults to `false`.
  final bool enableSorting;

  /// Whether drag handles are shown on reorderable column headers.
  /// Defaults to `true`.
  final bool showDragHandles;

  /// The icon to display for ascending sort order.
  /// Defaults to `Icons.keyboard_arrow_up`.
  final IconData? ascendingIcon;

  /// The icon to display for descending sort order.
  /// Defaults to `Icons.keyboard_arrow_down`.
  final IconData? descendingIcon;

  /// The size of the sort icons.
  /// Defaults to 18.0.
  final double? sortIconSize;

  /// The splash color for ink effects when a header cell is tapped.
  /// If `null`, the Material default splash color is used.
  final Color? splashColor;

  /// The highlight color for ink effects when a header cell is pressed.
  /// If `null`, the Material default highlight color is used.
  final Color? highlightColor;

  /// Creates a [BasicTableHeaderCellTheme] instance.
  ///
  /// All parameters have default values.
  const BasicTableHeaderCellTheme({
    this.height = 50.0,
    this.backgroundColor = Colors.white,
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.black,
    ),
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    this.border = const BorderSide(color: Colors.grey, width: 2.0),
    this.sortIconColor = Colors.blue,
    this.enableReorder = false,
    this.enableSorting = false,
    this.showDragHandles = true,
    this.ascendingIcon = Icons.keyboard_arrow_up,
    this.descendingIcon = Icons.keyboard_arrow_down,
    this.sortIconSize = 18.0,
    this.splashColor,
    this.highlightColor,
  });

  /// Creates a copy of this [BasicTableHeaderCellTheme] with the given fields replaced
  /// with new values.
  BasicTableHeaderCellTheme copyWith({
    double? height,
    Color? backgroundColor,
    TextStyle? textStyle,
    EdgeInsets? padding,
    BorderSide? border,
    Color? sortIconColor,
    bool? enableReorder,
    bool? enableSorting,
    bool? showDragHandles,
    IconData? ascendingIcon,
    IconData? descendingIcon,
    double? sortIconSize,
    Color? splashColor,
    Color? highlightColor,
  }) {
    return BasicTableHeaderCellTheme(
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      border: border ?? this.border,
      sortIconColor: sortIconColor ?? this.sortIconColor,
      enableReorder: enableReorder ?? this.enableReorder,
      enableSorting: enableSorting ?? this.enableSorting,
      showDragHandles: showDragHandles ?? this.showDragHandles,
      ascendingIcon: ascendingIcon ?? this.ascendingIcon,
      descendingIcon: descendingIcon ?? this.descendingIcon,
      sortIconSize: sortIconSize ?? this.sortIconSize,
      splashColor: splashColor ?? this.splashColor,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }
}
