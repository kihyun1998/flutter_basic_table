import 'package:flutter/material.dart';

/// 데이터 행의 테마 - ✅ 클릭 효과 색상 추가!
class BasicTableDataRowTheme {
  final double height;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final BorderSide? border;

  // ✅ 클릭 효과 색상 추가!
  final Color? splashColor;
  final Color? highlightColor;

  const BasicTableDataRowTheme({
    required this.height,
    this.backgroundColor,
    this.textStyle,
    this.padding,
    this.border,
    this.splashColor, // ✅ 추가
    this.highlightColor, // ✅ 추가
  });

  factory BasicTableDataRowTheme.defaultTheme() {
    return const BasicTableDataRowTheme(
      height: 45.0,
      backgroundColor: Colors.white,
      textStyle: TextStyle(fontSize: 13, color: Colors.black),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      border: BorderSide(color: Colors.grey, width: 0.3),
      splashColor: null, // ✅ 기본값 (Material 기본값 사용)
      highlightColor: null, // ✅ 기본값 (Material 기본값 사용)
    );
  }

  BasicTableDataRowTheme copyWith({
    double? height,
    Color? backgroundColor,
    TextStyle? textStyle,
    EdgeInsets? padding,
    BorderSide? border,
    Color? splashColor, // ✅ 추가
    Color? highlightColor, // ✅ 추가
  }) {
    return BasicTableDataRowTheme(
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      border: border ?? this.border,
      splashColor: splashColor ?? this.splashColor, // ✅ 추가
      highlightColor: highlightColor ?? this.highlightColor, // ✅ 추가
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
      splashColor, // ✅ 추가
      highlightColor, // ✅ 추가
    );
  }
}
