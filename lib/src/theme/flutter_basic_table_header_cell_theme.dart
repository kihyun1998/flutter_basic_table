import 'package:flutter/material.dart';

/// 헤더 셀의 테마
class BasicTableHeaderCellTheme {
  final double height;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final BorderSide? border;
  final Color? sortIconColor;
  final bool enableReorder;
  final bool enableSorting;
  final bool showDragHandles;

  final IconData? ascendingIcon;
  final IconData? descendingIcon;
  final double? sortIconSize;

  final Color? splashColor;
  final Color? highlightColor;

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableHeaderCellTheme &&
        other.height == height &&
        other.backgroundColor == backgroundColor &&
        other.textStyle == textStyle &&
        other.padding == padding &&
        other.border == border &&
        other.sortIconColor == sortIconColor &&
        other.enableReorder == enableReorder &&
        other.enableSorting == enableSorting &&
        other.showDragHandles == showDragHandles &&
        other.ascendingIcon == ascendingIcon &&
        other.descendingIcon == descendingIcon &&
        other.sortIconSize == sortIconSize &&
        other.splashColor == splashColor &&
        other.highlightColor == highlightColor;
  }

  @override
  int get hashCode {
    return Object.hash(
      height,
      backgroundColor,
      textStyle,
      padding,
      border,
      sortIconColor,
      enableReorder,
      enableSorting,
      showDragHandles,
      ascendingIcon,
      descendingIcon,
      sortIconSize,
      splashColor,
      highlightColor,
    );
  }
}
