import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';
import 'package:flutter_basic_table/src/widgets/custom_tooltip.dart';

/// OverflowableText - 텍스트 overflow 감지 후 조건부 tooltip 적용
class TooltipAbleText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final BasicTableTooltipTheme? tooltipTheme;
  final TooltipPosition? tooltipPosition;

  final String Function(String value)? tooltipFormatter;
  final bool forceTooltip;

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
