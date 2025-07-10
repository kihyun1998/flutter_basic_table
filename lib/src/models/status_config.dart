import 'package:flutter/material.dart';

/// Defines the configuration for a status indicator.
///
/// This class allows users to implement their own custom status systems
/// by providing visual properties like color, text, icon, and shape.
class StatusConfig {
  /// The primary color associated with the status.
  final Color color;

  /// The text to display for the status. If `null` or empty, no text will be shown.
  final String? text;

  /// The size of the circular indicator. If `0`, the circle will not be drawn.
  /// This is ignored if an `icon` is provided.
  /// Must be non-negative.
  final double circleSize;

  /// The text style for the status [text].
  final TextStyle? textStyle;

  /// An optional icon to display instead of a circle. If provided, [circleSize]
  /// will be ignored.
  final IconData? icon;

  /// The size of the [icon]. Defaults to 16.0 if an icon is present.
  final double? iconSize;

  /// The spacing between the circle/icon and the text.
  /// Defaults to 6.0.
  final double spacing;

  /// An optional tooltip text for the status indicator.
  /// If `null`, no tooltip will be shown unless handled by a parent widget.
  final String? tooltip;

  /// An optional shape to draw behind the status indicator content (e.g., a rounded rectangle for a badge).
  /// If provided, the `color` will be used as the background color for this shape.
  final ShapeBorder? shape;

  /// Optional padding around the content within the [shape].
  final EdgeInsets? padding;

  /// Creates a [StatusConfig] instance with the specified properties.
  const StatusConfig({
    required this.color,
    this.text,
    this.circleSize = 8.0,
    this.textStyle,
    this.icon,
    this.iconSize,
    this.spacing = 6.0,
    this.tooltip,
    this.shape,
    this.padding,
  }) : assert(circleSize >= 0, 'circleSize must be non-negative');

  /// Creates a simple [StatusConfig] with a circular indicator and text.
  factory StatusConfig.simple({
    required Color color,
    required String text,
    double circleSize = 8.0,
    TextStyle? textStyle,
    double spacing = 6.0,
    String? tooltip,
  }) {
    return StatusConfig(
      color: color,
      text: text,
      circleSize: circleSize,
      textStyle: textStyle,
      spacing: spacing,
      tooltip: tooltip,
    );
  }

  /// Creates a [StatusConfig] with only a circular indicator (no text).
  factory StatusConfig.circleOnly({
    required Color color,
    double circleSize = 8.0,
    String? tooltip,
    ShapeBorder? shape,
    EdgeInsets? padding,
  }) {
    return StatusConfig(
      color: color,
      text: null,
      circleSize: circleSize,
      tooltip: tooltip,
      shape: shape,
      padding: padding,
    );
  }

  /// Creates a [StatusConfig] with an icon and optional text.
  factory StatusConfig.withIcon({
    required Color color,
    required IconData icon,
    String? text,
    double iconSize = 16.0,
    TextStyle? textStyle,
    double spacing = 6.0,
    String? tooltip,
    EdgeInsets? padding,
  }) {
    return StatusConfig(
      color: color,
      text: text,
      icon: icon,
      iconSize: iconSize,
      textStyle: textStyle,
      spacing: spacing,
      tooltip: tooltip,
      padding: padding,
      circleSize: 0, // Hide circle when using an icon
    );
  }

  /// Creates a [StatusConfig] with only text (no circle or icon).
  factory StatusConfig.textOnly({
    required String text,
    required Color color,
    TextStyle? textStyle,
    String? tooltip,
    EdgeInsets? padding,
  }) {
    return StatusConfig(
      color: color,
      text: text,
      textStyle: textStyle,
      tooltip: tooltip,
      padding: padding,
      circleSize: 0, // Hide circle
      spacing: 0, // No spacing needed
    );
  }

  /// Creates a [StatusConfig] styled as a badge, with a rounded rectangle background.
  factory StatusConfig.badge({
    required Color color,
    required String text,
    Color? textColor,
    double fontSize = 12.0,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    double borderRadius = 12.0,
    String? tooltip,
  }) {
    return StatusConfig(
      color: Colors.transparent, // Transparent circle
      text: text,
      textStyle: TextStyle(
        color: textColor ?? Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
      ),
      tooltip: tooltip,
      circleSize: 0, // Hide circle
      spacing: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
    );
  }

  /// Returns the effective color to be used for the status indicator.
  /// This is typically the [color] property itself.
  Color get effectiveColor => color;

  /// Returns `true` if the status has text to display, `false` otherwise.
  bool get hasText => text != null && text!.isNotEmpty;

  /// Returns `true` if a circular indicator should be displayed, `false` otherwise.
  /// A circle is displayed only if `circleSize` is greater than 0 and no `icon` is provided.
  bool get hasCircle => circleSize > 0 && icon == null;

  /// Returns `true` if an icon should be displayed, `false` otherwise.
  bool get hasIcon => icon != null;

  /// Returns `true` if a custom [shape] is defined for the background, `false` otherwise.
  bool get hasShape => shape != null;

  /// Returns `true` if custom [padding] is defined, `false` otherwise.
  bool get hasPadding => padding != null;

  /// Creates a copy of this [StatusConfig] with the given fields replaced
  /// with new values.
  StatusConfig copyWith({
    Color? color,
    String? text,
    double? circleSize,
    TextStyle? textStyle,
    IconData? icon,
    double? iconSize,
    double? spacing,
    String? tooltip,
    ShapeBorder? shape,
    EdgeInsets? padding,
  }) {
    return StatusConfig(
      color: color ?? this.color,
      text: text ?? this.text,
      circleSize: circleSize ?? this.circleSize,
      textStyle: textStyle ?? this.textStyle,
      icon: icon ?? this.icon,
      iconSize: iconSize ?? this.iconSize,
      spacing: spacing ?? this.spacing,
      tooltip: tooltip ?? this.tooltip,
      shape: shape ?? this.shape,
      padding: padding ?? this.padding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StatusConfig &&
        other.color == color &&
        other.text == text &&
        other.circleSize == circleSize &&
        other.textStyle == textStyle &&
        other.icon == icon &&
        other.iconSize == iconSize &&
        other.spacing == spacing &&
        other.tooltip == tooltip &&
        other.shape == shape &&
        other.padding == padding;
  }

  @override
  int get hashCode {
    return Object.hash(
      color,
      text,
      circleSize,
      textStyle,
      icon,
      iconSize,
      spacing,
      tooltip,
      shape,
      padding,
    );
  }

  @override
  String toString() {
    return 'StatusConfig('
        'color: $color, '
        'text: $text, '
        'circleSize: $circleSize, '
        'hasIcon: $hasIcon, '
        'hasShape: $hasShape'
        ')';
  }
}
