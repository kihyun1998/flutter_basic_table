/// 테이블 컬럼 정보를 나타내는 모델
class BasicTableColumn {
  final String name;
  final double minWidth;
  final double? maxWidth;
  final bool isResizable;

  const BasicTableColumn({
    required this.name,
    this.minWidth = 100.0,
    this.maxWidth,
    this.isResizable = true,
  });

  BasicTableColumn copyWith({
    String? name,
    double? minWidth,
    double? maxWidth,
    bool? isResizable,
  }) {
    return BasicTableColumn(
      name: name ?? this.name,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      isResizable: isResizable ?? this.isResizable,
    );
  }
}
