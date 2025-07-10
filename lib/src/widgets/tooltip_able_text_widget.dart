import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';
import 'package:flutter_basic_table/src/widgets/custom_tooltip.dart';

/// A widget that displays text and conditionally shows a tooltip if the text overflows
/// or if `forceTooltip` is enabled.
class TooltipAbleText extends StatelessWidget {
  /// The text string to display.
  final String text;

  /// The style to apply to the text.
  final TextStyle? style;

  /// The maximum number of lines for the text to span.
  /// Defaults to 1.
  final int? maxLines;

  /// How visual overflow should be handled.
  /// Defaults to [TextOverflow.ellipsis].
  final TextOverflow? overflow;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// The theme data for the tooltip. If `null`, default tooltip theme will be used.
  final BasicTableTooltipTheme? tooltipTheme;

  /// The preferred position of the tooltip relative to the text.
  final TooltipPosition? tooltipPosition;

  /// An optional function that formats the tooltip message.
  /// If `null`, the original [text] will be used as the tooltip message.
  final String Function(String value)? tooltipFormatter;

  /// If `true`, the tooltip will always be displayed, regardless of text overflow.
  /// If `false`, the tooltip will only appear if the text overflows its boundaries.
  /// Defaults to `false`.
  final bool forceTooltip;

  /// Creates a [TooltipAbleText] instance.
  const TooltipAbleText({
    super.key,
    required this.text,
    this.style,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign,
    this.tooltipTheme,
    this.tooltipPosition,
    this.tooltipFormatter,
    this.forceTooltip = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // TextPainter로 실제 텍스트 크기 계산
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout(maxWidth: constraints.maxWidth);

        // overflow 체크
        final bool isOverflow = textPainter.didExceedMaxLines ||
            textPainter.width > constraints.maxWidth;

        // Text 위젯 생성
        final textWidget = Text(
          text,
          style: style,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
        );

        // tooltip 표시 조건
        // 1. forceTooltip이 true면 무조건 tooltip 표시
        // 2. forceTooltip이 false면 overflow 시에만 tooltip 표시
        final bool shouldShowTooltip = forceTooltip || isOverflow;

        if (shouldShowTooltip) {
          final String tooltipMessage = tooltipFormatter != null
              ? tooltipFormatter!(text) // 커스텀 formatter 사용
              : text; // 기본값: 원본 텍스트

          return CustomTooltip(
            message: tooltipMessage,
            theme: tooltipTheme,
            position: tooltipPosition,
            child: textWidget,
          );
        } else {
          // tooltip 없으면 그냥 Text만 반환
          return textWidget;
        }
      },
    );
  }
}
