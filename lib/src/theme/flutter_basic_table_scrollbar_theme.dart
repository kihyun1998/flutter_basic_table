import 'package:flutter/material.dart';

/// Defines the theme for the scrollbars within the [BasicTable].
class BasicTableScrollbarTheme {
  /// Whether the horizontal scrollbar should be shown.
  /// Defaults to `true`.
  final bool showHorizontal;

  /// Whether the vertical scrollbar should be shown.
  /// Defaults to `true`.
  final bool showVertical;

  /// Whether the scrollbars should only appear when the mouse hovers over the table.
  /// If `false`, scrollbars are always visible.
  /// Defaults to `true`.
  final bool hoverOnly;

  /// The opacity of the scrollbars when visible.
  /// Defaults to 0.8.
  final double opacity;

  /// The duration of the animation when scrollbar visibility changes (e.g., on hover).
  /// Defaults to `Duration(milliseconds: 200)`.
  final Duration animationDuration;

  /// The width (thickness) of the scrollbars.
  /// Defaults to 16.0.
  final double width;

  /// The color of the scrollbar thumb.
  /// Defaults to `Colors.black.withOpacity(0.5)`.
  final Color? color;

  /// The color of the scrollbar track.
  /// Defaults to `Colors.black.withOpacity(0.1)`.
  final Color? trackColor;

  /// Creates a [BasicTableScrollbarTheme] instance.
  ///
  /// All parameters have default values.
  const BasicTableScrollbarTheme({
    this.showHorizontal = true,
    this.showVertical = true,
    this.hoverOnly = true,
    this.opacity = 0.8,
    this.animationDuration = const Duration(milliseconds: 200),
    this.width = 16.0,
    this.color,
    this.trackColor,
  });

  /// Creates a copy of this [BasicTableScrollbarTheme] with the given fields replaced
  /// with new values.
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
}
