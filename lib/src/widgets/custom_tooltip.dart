import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

/// A wrapper around Flutter's [Tooltip] widget, providing convenient theming
/// and position control based on [BasicTableTooltipTheme] and [TooltipPosition].
class CustomTooltip extends StatelessWidget {
  /// The text message to display in the tooltip.
  final String message;

  /// The widget that triggers the tooltip when hovered or long-pressed.
  final Widget child;

  /// Optional theme data for the tooltip. If provided, its properties will be
  /// used as defaults. Individual properties on this widget can override theme values.
  final BasicTableTooltipTheme? theme;

  /// The preferred position of the tooltip relative to the [child] widget.
  /// If `null`, the position from the [theme] will be used.
  final TooltipPosition? position;

  // Individual properties that can override theme settings

  /// The background color of the tooltip. Overrides [theme.backgroundColor].
  final Color? backgroundColor;

  /// The color of the text within the tooltip. Overrides [theme.textColor].
  final Color? textColor;

  /// The font size of the text within the tooltip. Overrides [theme.fontSize].
  final double? fontSize;

  /// The padding around the content inside the tooltip. Overrides [theme.padding].
  final EdgeInsets? padding;

  /// The empty space that surrounds the tooltip. Overrides [theme.margin].
  final EdgeInsets? margin;

  /// The border radius for the tooltip's background. Overrides [theme.borderRadius].
  final BorderRadius? borderRadius;

  /// The vertical distance between the tooltip and the widget it's attached to.
  /// Overrides [theme.verticalOffset].
  final double? verticalOffset;

  /// Creates a [CustomTooltip] instance.
  const CustomTooltip({
    super.key,
    required this.message,
    required this.child,
    this.theme,
    this.position,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
    this.margin,
    this.borderRadius,
    this.verticalOffset,
  });

  @override
  Widget build(BuildContext context) {
    // 테마 기본값 가져오기
    final effectiveTheme = theme ?? BasicTableTooltipTheme();

    // 개별 속성이 있으면 우선 적용, 없으면 테마 사용
    final effectiveBackgroundColor =
        backgroundColor ?? effectiveTheme.backgroundColor!;
    final effectiveTextColor = textColor ?? effectiveTheme.textColor!;
    final effectiveFontSize = fontSize ?? effectiveTheme.fontSize!;
    final effectivePadding = padding ?? effectiveTheme.padding!;
    final effectiveMargin = margin ?? effectiveTheme.margin!;
    final effectiveBorderRadius = borderRadius ?? effectiveTheme.borderRadius!;
    final effectiveVerticalOffset =
        verticalOffset ?? effectiveTheme.verticalOffset!;
    final effectivePosition = position ?? effectiveTheme.preferredPosition;

    // position에 따른 preferBelow 결정
    bool preferBelow;
    switch (effectivePosition) {
      case TooltipPosition.top:
        preferBelow = false;
        break;
      case TooltipPosition.bottom:
        preferBelow = true;
        break;
      case TooltipPosition.auto:
        preferBelow = true; // 기본값, Flutter가 자동으로 조정
        break;
    }

    return Tooltip(
      message: message,
      preferBelow: preferBelow,
      verticalOffset: effectiveVerticalOffset,
      waitDuration: effectiveTheme.waitDuration!,
      showDuration: effectiveTheme.showDuration!,
      margin: effectiveMargin,
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        boxShadow: effectiveTheme.boxShadow,
      ),
      textStyle: TextStyle(
        color: effectiveTextColor,
        fontSize: effectiveFontSize,
        fontWeight: effectiveTheme.fontWeight,
      ),
      child: child,
    );
  }
}
