import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';
import 'package:flutter_basic_table/src/enum/tooltip_position.dart';
import 'package:flutter_basic_table/src/widgets/custom_tooltip.dart';

/// OverflowableText - 텍스트 overflow 감지 후 조건부 tooltip 적용
class OverflowableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final BasicTableTooltipTheme? tooltipTheme;
  final TooltipPosition? tooltipPosition;

  const OverflowableText({
    super.key,
    required this.text,
    this.style,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign,
    this.tooltipTheme,
    this.tooltipPosition,
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

        // overflow시에만 CustomTooltip으로 감싸기
        if (isOverflow) {
          return CustomTooltip(
            message: text, // 전체 텍스트를 tooltip으로 표시
            theme: tooltipTheme,
            position: tooltipPosition,
            child: textWidget,
          );
        } else {
          // overflow 없으면 그냥 Text만 반환
          return textWidget;
        }
      },
    );
  }
}
