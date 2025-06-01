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
    required this.height,
    this.backgroundColor,
    this.textStyle,
    this.padding,
    this.border,
    this.sortIconColor,
    required this.enableReorder,
    required this.enableSorting,
    required this.showDragHandles,
    this.ascendingIcon,
    this.descendingIcon,
    this.sortIconSize,
    this.splashColor,
    this.highlightColor,
  });

  factory BasicTableHeaderCellTheme.defaultTheme() {
    return const BasicTableHeaderCellTheme(
      height: 50.0,
      backgroundColor: Colors.white,
      textStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      border: BorderSide(color: Colors.grey, width: 2.0),
      sortIconColor: Colors.blue,
      enableReorder: false,
      enableSorting: false,
      showDragHandles: true,
      ascendingIcon: Icons.keyboard_arrow_up,
      descendingIcon: Icons.keyboard_arrow_down,
      sortIconSize: 18.0,
      splashColor: null,
      highlightColor: null,
    );
  }

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
        other.ascendingIcon == ascendingIcon && // ✅ 추가
        other.descendingIcon == descendingIcon && // ✅ 추가
        other.sortIconSize == sortIconSize && // ✅ 추가
        other.splashColor == splashColor && // ✅ 추가
        other.highlightColor == highlightColor; // ✅ 추가
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
      ascendingIcon, // ✅ 추가
      descendingIcon, // ✅ 추가
      sortIconSize, // ✅ 추가
      splashColor, // ✅ 추가
      highlightColor, // ✅ 추가
    );
  }
}
