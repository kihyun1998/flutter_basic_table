import 'package:flutter/material.dart';
import 'package:flutter_basic_table/src/enum/tooltip_position.dart';

/// Defines the theme for custom tooltips displayed within the [BasicTable].
class BasicTableTooltipTheme {
  /// The background color of the tooltip.
  /// Defaults to `Colors.black87`.
  final Color? backgroundColor;

  /// The color of the text within the tooltip.
  /// Defaults to `Colors.white`.
  final Color? textColor;

  /// The font size of the text within the tooltip.
  /// Defaults to 12.0.
  final double? fontSize;

  /// The font weight of the text within the tooltip.
  /// Defaults to `FontWeight.normal`.
  final FontWeight? fontWeight;

  /// The padding around the content inside the tooltip.
  /// Defaults to `EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0)`.
  final EdgeInsets? padding;

  /// The empty space that surrounds the tooltip.
  /// Defaults to `EdgeInsets.all(0)`.
  final EdgeInsets? margin;

  /// The border radius for the tooltip's background.
  /// Defaults to `BorderRadius.circular(4.0)`.
  final BorderRadius? borderRadius;

  /// A list of shadows to be cast behind the tooltip.
  /// Defaults to a subtle black shadow.
  final List<BoxShadow>? boxShadow;

  /// The vertical distance between the tooltip and the widget it's attached to.
  /// Defaults to 24.0.
  final double? verticalOffset;

  /// The duration of the delay before the tooltip is shown.
  /// Defaults to `Duration(milliseconds: 500)`.
  final Duration? waitDuration;

  /// The duration for which the tooltip remains visible after it is shown.
  /// Defaults to `Duration(milliseconds: 1500)`.
  final Duration? showDuration;

  /// The preferred position of the tooltip relative to its child.
  /// Defaults to [TooltipPosition.auto], which lets Flutter decide the best position.
  final TooltipPosition preferredPosition;

  /// Creates a [BasicTableTooltipTheme] instance.
  ///
  /// All parameters have default values.
  const BasicTableTooltipTheme({
    this.backgroundColor = Colors.black87,
    this.textColor = Colors.white,
    this.fontSize = 12.0,
    this.fontWeight = FontWeight.normal,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
    this.margin = const EdgeInsets.all(0),
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.boxShadow = const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 4.0,
        offset: Offset(0, 2),
      ),
    ],
    this.verticalOffset = 24.0,
    this.waitDuration = const Duration(milliseconds: 500),
    this.showDuration = const Duration(milliseconds: 1500),
    this.preferredPosition = TooltipPosition.auto,
  });

  /// Creates a copy of this [BasicTableTooltipTheme] with the given fields replaced
  /// with new values.
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
  int get hashCode() {
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
