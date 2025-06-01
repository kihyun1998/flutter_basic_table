import 'package:flutter/material.dart';

/// 스크롤바의 테마
class BasicTableScrollbarTheme {
  final bool showHorizontal;
  final bool showVertical;
  final bool hoverOnly;
  final double opacity;
  final Duration animationDuration;
  final double width;
  final Color? color;
  final Color? trackColor;

  const BasicTableScrollbarTheme({
    required this.showHorizontal,
    required this.showVertical,
    required this.hoverOnly,
    required this.opacity,
    required this.animationDuration,
    required this.width,
    this.color,
    this.trackColor,
  });

  factory BasicTableScrollbarTheme.defaultTheme() {
    return BasicTableScrollbarTheme(
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

  BasicTableScrollbarTheme copyWith({
    bool? showHorizontal,
    bool? showVertical,
    bool? hoverOnly,
    double? opacity,
    Duration? animationDuration,
    double? width,
    Color? color,
    Color? trackColor,
  }) {
    return BasicTableScrollbarTheme(
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
    return other is BasicTableScrollbarTheme &&
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
