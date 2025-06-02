/// 테이블 컬럼 정보를 나타내는 모델
class BasicTableColumn {
  /// 컬럼의 고유 식별자 (정렬 상태 추적용)
  /// null이면 name을 ID로 사용
  final String? id;

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
    this.id,
    required this.name,
    this.minWidth = 100.0,
    this.maxWidth,
    this.isResizable = true,
    this.tooltipFormatter,
    this.forceTooltip = false,
  });

  /// 실제 사용할 고유 ID 반환 (id가 null이면 name 사용)
  String get effectiveId => id ?? name;

  BasicTableColumn copyWith({
    String? id,
    String? name,
    double? minWidth,
    double? maxWidth,
    bool? isResizable,
    String Function(String value)? tooltipFormatter,
    bool? forceTooltip,
  }) {
    return BasicTableColumn(
      id: id ?? this.id,
      name: name ?? this.name,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      isResizable: isResizable ?? this.isResizable,
      tooltipFormatter: tooltipFormatter ?? this.tooltipFormatter,
      forceTooltip: forceTooltip ?? this.forceTooltip,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableColumn &&
        other.id == id &&
        other.name == name &&
        other.minWidth == minWidth &&
        other.maxWidth == maxWidth &&
        other.isResizable == isResizable &&
        other.forceTooltip == forceTooltip;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      minWidth,
      maxWidth,
      isResizable,
      forceTooltip,
    );
  }

  @override
  String toString() {
    return 'BasicTableColumn(id: $effectiveId, name: $name, minWidth: $minWidth)';
  }
}
