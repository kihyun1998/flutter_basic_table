// lib/src/selectable/theme/selectable_theme.dart
import 'package:flutter/material.dart';

import 'selectable_border_theme.dart';
import 'selectable_header_theme.dart';
import 'selectable_row_theme.dart';

/// SelectableTable의 모든 스타일과 설정을 담는 테마 데이터
class SelectableTableTheme {
  /// 헤더 테마
  final SelectableHeaderTheme headerTheme;

  /// 행 테마
  final SelectableRowTheme rowTheme;

  /// 테두리 테마
  final SelectableBorderTheme borderTheme;

  /// 스크롤바 테마
  final SelectableScrollbarTheme scrollbarTheme;

  const SelectableTableTheme({
    required this.headerTheme,
    required this.rowTheme,
    required this.borderTheme,
    required this.scrollbarTheme,
  });

  /// 기본 테마 생성
  factory SelectableTableTheme.defaultTheme() {
    return SelectableTableTheme(
      headerTheme: SelectableHeaderTheme.defaultTheme(),
      rowTheme: SelectableRowTheme.defaultTheme(),
      borderTheme: SelectableBorderTheme.defaultTheme(),
      scrollbarTheme: SelectableScrollbarTheme.defaultTheme(),
    );
  }

  /// 부분적 변경을 위한 copyWith
  SelectableTableTheme copyWith({
    SelectableHeaderTheme? headerTheme,
    SelectableRowTheme? rowTheme,
    SelectableBorderTheme? borderTheme,
    SelectableScrollbarTheme? scrollbarTheme,
  }) {
    return SelectableTableTheme(
      headerTheme: headerTheme ?? this.headerTheme,
      rowTheme: rowTheme ?? this.rowTheme,
      borderTheme: borderTheme ?? this.borderTheme,
      scrollbarTheme: scrollbarTheme ?? this.scrollbarTheme,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SelectableTableTheme &&
        other.headerTheme == headerTheme &&
        other.rowTheme == rowTheme &&
        other.borderTheme == borderTheme &&
        other.scrollbarTheme == scrollbarTheme;
  }

  @override
  int get hashCode {
    return Object.hash(
      headerTheme,
      rowTheme,
      borderTheme,
      scrollbarTheme,
    );
  }
}

/// SelectableTable 스크롤바의 테마
class SelectableScrollbarTheme {
  /// 가로 스크롤바 표시 여부
  final bool showHorizontal;

  /// 세로 스크롤바 표시 여부
  final bool showVertical;

  /// 호버 시에만 표시 여부
  final bool hoverOnly;

  /// 투명도
  final double opacity;

  /// 애니메이션 지속 시간
  final Duration animationDuration;

  /// 스크롤바 너비
  final double width;

  /// 스크롤바 색상
  final Color? color;

  /// 트랙 색상
  final Color? trackColor;

  const SelectableScrollbarTheme({
    required this.showHorizontal,
    required this.showVertical,
    required this.hoverOnly,
    required this.opacity,
    required this.animationDuration,
    required this.width,
    this.color,
    this.trackColor,
  });

  /// 기본 테마
  factory SelectableScrollbarTheme.defaultTheme() {
    return SelectableScrollbarTheme(
      showHorizontal: true,
      showVertical: true,
      hoverOnly: true,
      opacity: 0.8,
      animationDuration: const Duration(milliseconds: 200),
      width: 16.0,
      color: Colors.black.withOpacity(0.5),
      trackColor: Colors.black.withOpacity(0.1),
    );
  }

  SelectableScrollbarTheme copyWith({
    bool? showHorizontal,
    bool? showVertical,
    bool? hoverOnly,
    double? opacity,
    Duration? animationDuration,
    double? width,
    Color? color,
    Color? trackColor,
  }) {
    return SelectableScrollbarTheme(
      showHorizontal: showHorizontal ?? this.showHorizontal,
      showVertical: showVertical ?? this.showVertical,
      hoverOnly: hoverOnly ?? this.hoverOnly,
      opacity: opacity ?? this.opacity,
      animationDuration: animationDuration ?? this.animationDuration,
      width: width ?? this.width,
      color: color ?? this.color,
      trackColor: trackColor ?? this.trackColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SelectableScrollbarTheme &&
        other.showHorizontal == showHorizontal &&
        other.showVertical == showVertical &&
        other.hoverOnly == hoverOnly &&
        other.opacity == opacity &&
        other.animationDuration == animationDuration &&
        other.width == width &&
        other.color == color &&
        other.trackColor == trackColor;
  }

  @override
  int get hashCode {
    return Object.hash(
      showHorizontal,
      showVertical,
      hoverOnly,
      opacity,
      animationDuration,
      width,
      color,
      trackColor,
    );
  }
}
