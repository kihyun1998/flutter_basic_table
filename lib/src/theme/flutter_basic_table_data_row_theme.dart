import 'package:flutter/material.dart';

/// 데이터 행의 테마
class BasicTableDataRowTheme {
  final double height;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final BorderSide? border;
  final Color? splashColor;
  final Color? highlightColor;

  const BasicTableDataRowTheme({
    required this.height,
    this.backgroundColor,
    this.textStyle,
    this.padding,
    this.border,
    this.splashColor,
    this.highlightColor,
  });

  factory BasicTableDataRowTheme.defaultTheme() {
    return const BasicTableDataRowTheme(
      height: 45.0,
      backgroundColor: Colors.white,
      textStyle: TextStyle(fontSize: 13, color: Colors.black),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      border: BorderSide(color: Colors.grey, width: 0.3),
      splashColor: null,
      highlightColor: null,
    );
  }

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
  int get hashCode {
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
