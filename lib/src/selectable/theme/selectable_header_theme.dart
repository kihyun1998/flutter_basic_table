// lib/src/selectable/theme/selectable_header_theme.dart
import 'package:flutter/material.dart';

/// SelectableTable 헤더의 테마
class SelectableHeaderTheme {
  /// 헤더 높이
  final double height;

  /// 배경색
  final Color? backgroundColor;

  /// 텍스트 스타일
  final TextStyle? textStyle;

  /// 패딩
  final EdgeInsets? padding;

  /// 테두리
  final BorderSide? border;

  /// 정렬 아이콘 색상
  final Color? sortIconColor;

  /// 정렬 활성화 여부
  final bool enableSorting;

  /// 리오더링 활성화 여부
  final bool enableReordering;

  /// 리사이징 활성화 여부
  final bool enableResizing;

  /// 드래그 핸들 표시 여부
  final bool showDragHandles;

  /// 오름차순 아이콘
  final IconData? ascendingIcon;

  /// 내림차순 아이콘
  final IconData? descendingIcon;

  /// 정렬 아이콘 크기
  final double? sortIconSize;

  /// 클릭 효과 색상
  final Color? splashColor;
  final Color? highlightColor;

  const SelectableHeaderTheme({
    required this.height,
    this.backgroundColor,
    this.textStyle,
    this.padding,
    this.border,
    this.sortIconColor,
    required this.enableSorting,
    required this.enableReordering,
    required this.enableResizing,
    required this.showDragHandles,
    this.ascendingIcon,
    this.descendingIcon,
    this.sortIconSize,
    this.splashColor,
    this.highlightColor,
  });

  /// 기본 테마
  factory SelectableHeaderTheme.defaultTheme() {
    return const SelectableHeaderTheme(
      height: 50.0,
      backgroundColor: Colors.white,
      textStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      border: BorderSide(color: Colors.grey, width: 1.0),
      sortIconColor: Colors.blue,
      enableSorting: true,
      enableReordering: true,
      enableResizing: true,
      showDragHandles: true,
      ascendingIcon: Icons.keyboard_arrow_up,
      descendingIcon: Icons.keyboard_arrow_down,
      sortIconSize: 18.0,
      splashColor: null,
      highlightColor: null,
    );
  }

  SelectableHeaderTheme copyWith({
    double? height,
    Color? backgroundColor,
    TextStyle? textStyle,
    EdgeInsets? padding,
    BorderSide? border,
    Color? sortIconColor,
    bool? enableSorting,
    bool? enableReordering,
    bool? enableResizing,
    bool? showDragHandles,
    IconData? ascendingIcon,
    IconData? descendingIcon,
    double? sortIconSize,
    Color? splashColor,
    Color? highlightColor,
  }) {
    return SelectableHeaderTheme(
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      border: border ?? this.border,
      sortIconColor: sortIconColor ?? this.sortIconColor,
      enableSorting: enableSorting ?? this.enableSorting,
      enableReordering: enableReordering ?? this.enableReordering,
      enableResizing: enableResizing ?? this.enableResizing,
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
    return other is SelectableHeaderTheme &&
        other.height == height &&
        other.backgroundColor == backgroundColor &&
        other.textStyle == textStyle &&
        other.padding == padding &&
        other.border == border &&
        other.sortIconColor == sortIconColor &&
        other.enableSorting == enableSorting &&
        other.enableReordering == enableReordering &&
        other.enableResizing == enableResizing &&
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
      enableSorting,
      enableReordering,
      enableResizing,
      showDragHandles,
      ascendingIcon,
      descendingIcon,
      sortIconSize,
      splashColor,
      highlightColor,
    );
  }
}
