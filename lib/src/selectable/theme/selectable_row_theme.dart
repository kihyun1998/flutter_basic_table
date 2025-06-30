// lib/src/selectable/theme/selectable_row_theme.dart
import 'package:flutter/material.dart';

/// SelectableTable 데이터 행의 테마
class SelectableRowTheme {
  /// 행 높이
  final double height;

  /// 기본 배경색
  final Color? backgroundColor;

  /// 선택된 행 배경색
  final Color? selectedBackgroundColor;

  /// 호버 시 배경색
  final Color? hoverBackgroundColor;

  /// 텍스트 스타일
  final TextStyle? textStyle;

  /// 패딩
  final EdgeInsets? padding;

  /// 테두리
  final BorderSide? border;

  /// 클릭 효과 색상
  final Color? splashColor;
  final Color? highlightColor;

  /// 체크박스 테마
  final SelectableCheckboxTheme checkboxTheme;

  const SelectableRowTheme({
    required this.height,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.hoverBackgroundColor,
    this.textStyle,
    this.padding,
    this.border,
    this.splashColor,
    this.highlightColor,
    required this.checkboxTheme,
  });

  /// 기본 테마
  factory SelectableRowTheme.defaultTheme() {
    return SelectableRowTheme(
      height: 45.0,
      backgroundColor: Colors.white,
      selectedBackgroundColor: Colors.blue.withOpacity(0.1),
      hoverBackgroundColor: Colors.grey.withOpacity(0.05),
      textStyle: const TextStyle(fontSize: 13, color: Colors.black),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      border: const BorderSide(color: Colors.grey, width: 0.3),
      splashColor: null,
      highlightColor: null,
      checkboxTheme: SelectableCheckboxTheme.defaultTheme(),
    );
  }

  SelectableRowTheme copyWith({
    double? height,
    Color? backgroundColor,
    Color? selectedBackgroundColor,
    Color? hoverBackgroundColor,
    TextStyle? textStyle,
    EdgeInsets? padding,
    BorderSide? border,
    Color? splashColor,
    Color? highlightColor,
    SelectableCheckboxTheme? checkboxTheme,
  }) {
    return SelectableRowTheme(
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      selectedBackgroundColor:
          selectedBackgroundColor ?? this.selectedBackgroundColor,
      hoverBackgroundColor: hoverBackgroundColor ?? this.hoverBackgroundColor,
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      border: border ?? this.border,
      splashColor: splashColor ?? this.splashColor,
      highlightColor: highlightColor ?? this.highlightColor,
      checkboxTheme: checkboxTheme ?? this.checkboxTheme,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SelectableRowTheme &&
        other.height == height &&
        other.backgroundColor == backgroundColor &&
        other.selectedBackgroundColor == selectedBackgroundColor &&
        other.hoverBackgroundColor == hoverBackgroundColor &&
        other.textStyle == textStyle &&
        other.padding == padding &&
        other.border == border &&
        other.splashColor == splashColor &&
        other.highlightColor == highlightColor &&
        other.checkboxTheme == checkboxTheme;
  }

  @override
  int get hashCode {
    return Object.hash(
      height,
      backgroundColor,
      selectedBackgroundColor,
      hoverBackgroundColor,
      textStyle,
      padding,
      border,
      splashColor,
      highlightColor,
      checkboxTheme,
    );
  }
}

/// SelectableTable 체크박스의 테마
class SelectableCheckboxTheme {
  /// 체크박스 활성화 여부
  final bool enabled;

  /// 체크박스 컬럼 너비
  final double columnWidth;

  /// 패딩
  final EdgeInsets? padding;

  /// 활성 색상
  final Color? activeColor;

  /// 체크 색상
  final Color? checkColor;

  const SelectableCheckboxTheme({
    required this.enabled,
    required this.columnWidth,
    this.padding,
    this.activeColor,
    this.checkColor,
  });

  /// 기본 테마
  factory SelectableCheckboxTheme.defaultTheme() {
    return const SelectableCheckboxTheme(
      enabled: true,
      columnWidth: 60.0,
      padding: EdgeInsets.all(8.0),
      activeColor: null, // Material 기본값 사용
      checkColor: null, // Material 기본값 사용
    );
  }

  SelectableCheckboxTheme copyWith({
    bool? enabled,
    double? columnWidth,
    EdgeInsets? padding,
    Color? activeColor,
    Color? checkColor,
  }) {
    return SelectableCheckboxTheme(
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
    return other is SelectableCheckboxTheme &&
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
