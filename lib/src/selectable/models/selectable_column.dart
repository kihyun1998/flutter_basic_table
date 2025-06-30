/// SelectableTable에서 사용하는 컬럼 모델
///
/// 선택 기능이 있는 테이블의 컬럼 정보를 정의합니다.
class SelectableColumn {
  /// 컬럼의 고유 식별자
  final String id;

  /// 표시할 컬럼명
  final String name;

  /// 최소 너비
  final double minWidth;

  /// 최대 너비 (null이면 제한 없음)
  final double? maxWidth;

  /// 리사이징 가능 여부
  final bool isResizable;

  /// 정렬 가능 여부
  final bool isSortable;

  const SelectableColumn({
    required this.id,
    required this.name,
    this.minWidth = 100.0,
    this.maxWidth,
    this.isResizable = true,
    this.isSortable = true,
  });

  /// 간단한 컬럼 생성 팩토리
  factory SelectableColumn.simple(String name, {double width = 100.0}) {
    return SelectableColumn(
      id: name.toLowerCase().replaceAll(' ', '_'),
      name: name,
      minWidth: width,
    );
  }

  SelectableColumn copyWith({
    String? id,
    String? name,
    double? minWidth,
    double? maxWidth,
    bool? isResizable,
    bool? isSortable,
  }) {
    return SelectableColumn(
      id: id ?? this.id,
      name: name ?? this.name,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      isResizable: isResizable ?? this.isResizable,
      isSortable: isSortable ?? this.isSortable,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SelectableColumn &&
        other.id == id &&
        other.name == name &&
        other.minWidth == minWidth &&
        other.maxWidth == maxWidth &&
        other.isResizable == isResizable &&
        other.isSortable == isSortable;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      minWidth,
      maxWidth,
      isResizable,
      isSortable,
    );
  }

  @override
  String toString() {
    return 'SelectableColumn(id: $id, name: $name, minWidth: $minWidth)';
  }
}
