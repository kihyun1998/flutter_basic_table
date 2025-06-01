import 'package:flutter/material.dart';
import 'package:flutter_basic_table/src/enum/tooltip_position.dart';

/// CustomTooltip의 테마 데이터
class BasicTableTooltipTheme {
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final double? verticalOffset;
  final Duration? waitDuration;
  final Duration? showDuration;
  final TooltipPosition preferredPosition;

  const BasicTableTooltipTheme({
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.margin,
    this.borderRadius,
    this.boxShadow,
    this.verticalOffset,
    this.waitDuration,
    this.showDuration,
    this.preferredPosition = TooltipPosition.auto,
  });

  /// 기본 모노톤 테마
  factory BasicTableTooltipTheme.defaultTheme() {
    return BasicTableTooltipTheme(
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      margin: const EdgeInsets.all(0),
      borderRadius: BorderRadius.circular(4.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 4.0,
          offset: const Offset(0, 2),
        ),
      ],
      verticalOffset: 24.0,
      waitDuration: const Duration(milliseconds: 500),
      showDuration: const Duration(milliseconds: 1500),
      preferredPosition: TooltipPosition.auto,
    );
  }

  BasicTableTooltipTheme copyWith({
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
    FontWeight? fontWeight,
    EdgeInsets? padding,
    EdgeInsets? margin,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    double? verticalOffset,
    Duration? waitDuration,
    Duration? showDuration,
    TooltipPosition? preferredPosition,
  }) {
    return BasicTableTooltipTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
      verticalOffset: verticalOffset ?? this.verticalOffset,
      waitDuration: waitDuration ?? this.waitDuration,
      showDuration: showDuration ?? this.showDuration,
      preferredPosition: preferredPosition ?? this.preferredPosition,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableTooltipTheme &&
        other.backgroundColor == backgroundColor &&
        other.textColor == textColor &&
        other.fontSize == fontSize &&
        other.fontWeight == fontWeight &&
        other.padding == padding &&
        other.margin == margin &&
        other.borderRadius == borderRadius &&
        other.boxShadow == boxShadow &&
        other.verticalOffset == verticalOffset &&
        other.waitDuration == waitDuration &&
        other.showDuration == showDuration &&
        other.preferredPosition == preferredPosition;
  }

  @override
  int get hashCode {
    return Object.hash(
      backgroundColor,
      textColor,
      fontSize,
      fontWeight,
      padding,
      margin,
      borderRadius,
      boxShadow,
      verticalOffset,
      waitDuration,
      showDuration,
      preferredPosition,
    );
  }
}
