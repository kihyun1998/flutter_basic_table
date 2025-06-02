/// 테이블 컬럼 정보를 나타내는 모델
class BasicTableColumn {
  final String name;
  final double minWidth;
  final double? maxWidth;
  final bool isResizable;

  /// 커스텀 tooltip 메시지를 생성하는 함수
  /// null이면 기본 동작 (원본 텍스트 표시)
  final String Function(String value)? tooltipFormatter;

  /// overflow 없어도 강제로 tooltip 표시 여부
  /// true면 항상 tooltip 표시, false면 overflow 시에만 표시
  final bool forceTooltip;

  const BasicTableColumn({
    required this.name,
    this.minWidth = 100.0,
    this.maxWidth,
    this.isResizable = true,
    this.tooltipFormatter,
    this.forceTooltip = false,
  });

  BasicTableColumn copyWith({
    String? name,
    double? minWidth,
    double? maxWidth,
    bool? isResizable,
    String Function(String value)? tooltipFormatter,
    bool? forceTooltip,
  }) {
    return BasicTableColumn(
      name: name ?? this.name,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      isResizable: isResizable ?? this.isResizable,
      tooltipFormatter: tooltipFormatter ?? this.tooltipFormatter,
      forceTooltip: forceTooltip ?? this.forceTooltip,
    );
  }
}
