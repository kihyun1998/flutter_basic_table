/// 테이블 컬럼 정보를 나타내는 모델
class BasicTableColumn {
  /// 컬럼의 고유 식별자 (필수)
  final String id;

  /// 표시할 컬럼명
  final String name;

  /// 컬럼 표시 순서 (0부터 시작)
  final int order;

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
    required this.id,
    required this.name,
    required this.order,
    this.minWidth = 100.0,
    this.maxWidth,
    this.isResizable = true,
    this.tooltipFormatter,
    this.forceTooltip = false,
  });

  /// 편의 생성자 - name을 id로 사용하고 order만 지정
  factory BasicTableColumn.simple({
    required String name,
    required int order,
    double minWidth = 100.0,
    double? maxWidth,
    bool isResizable = true,
    String Function(String value)? tooltipFormatter,
    bool forceTooltip = false,
  }) {
    return BasicTableColumn(
      id: name.toLowerCase().replaceAll(' ', '_'), // 공백을 언더스코어로
      name: name,
      order: order,
      minWidth: minWidth,
      maxWidth: maxWidth,
      isResizable: isResizable,
      tooltipFormatter: tooltipFormatter,
      forceTooltip: forceTooltip,
    );
  }

  /// ID와 name이 다른 경우를 위한 편의 생성자
  factory BasicTableColumn.withCustomId({
    required String id,
    required String name,
    required int order,
    double minWidth = 100.0,
    double? maxWidth,
    bool isResizable = true,
    String Function(String value)? tooltipFormatter,
    bool forceTooltip = false,
  }) {
    return BasicTableColumn(
      id: id,
      name: name,
      order: order,
      minWidth: minWidth,
      maxWidth: maxWidth,
      isResizable: isResizable,
      tooltipFormatter: tooltipFormatter,
      forceTooltip: forceTooltip,
    );
  }

  /// 컬럼 리스트를 Map으로 변환하는 헬퍼 메서드
  static Map<String, BasicTableColumn> listToMap(
      List<BasicTableColumn> columns) {
    final Map<String, BasicTableColumn> result = {};

    for (final column in columns) {
      if (result.containsKey(column.id)) {
        throw ArgumentError('Duplicate column ID: ${column.id}');
      }
      result[column.id] = column;
    }

    return result;
  }

  /// Map을 order 기준으로 정렬된 리스트로 변환
  static List<BasicTableColumn> mapToSortedList(
      Map<String, BasicTableColumn> columns) {
    final list = columns.values.toList();
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  /// order 재정렬 헬퍼 - 특정 컬럼의 order를 변경하고 다른 컬럼들도 조정
  static Map<String, BasicTableColumn> reorderColumn(
    Map<String, BasicTableColumn> columns,
    String columnId,
    int newOrder,
  ) {
    if (!columns.containsKey(columnId)) {
      throw ArgumentError('Column not found: $columnId');
    }

    final targetColumn = columns[columnId]!;
    final oldOrder = targetColumn.order;

    if (oldOrder == newOrder) return columns;

    final result = Map<String, BasicTableColumn>.from(columns);

    // 다른 컬럼들의 order 조정
    for (final entry in result.entries) {
      final column = entry.value;

      if (column.id == columnId) {
        // 타겟 컬럼은 새로운 order로 설정
        result[entry.key] = column.copyWith(order: newOrder);
      } else {
        // 다른 컬럼들은 필요에 따라 order 조정
        int adjustedOrder = column.order;

        if (oldOrder < newOrder) {
          // 뒤로 이동: 사이에 있는 컬럼들을 앞으로 당김
          if (column.order > oldOrder && column.order <= newOrder) {
            adjustedOrder = column.order - 1;
          }
        } else {
          // 앞으로 이동: 사이에 있는 컬럼들을 뒤로 밀어냄
          if (column.order >= newOrder && column.order < oldOrder) {
            adjustedOrder = column.order + 1;
          }
        }

        if (adjustedOrder != column.order) {
          result[entry.key] = column.copyWith(order: adjustedOrder);
        }
      }
    }

    return result;
  }

  /// order 연속성 검증 및 수정
  static Map<String, BasicTableColumn> normalizeOrders(
      Map<String, BasicTableColumn> columns) {
    final sortedList = mapToSortedList(columns);
    final result = <String, BasicTableColumn>{};

    for (int i = 0; i < sortedList.length; i++) {
      final column = sortedList[i];
      result[column.id] = column.copyWith(order: i);
    }

    return result;
  }

  BasicTableColumn copyWith({
    String? id,
    String? name,
    int? order,
    double? minWidth,
    double? maxWidth,
    bool? isResizable,
    String Function(String value)? tooltipFormatter,
    bool? forceTooltip,
  }) {
    return BasicTableColumn(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
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
        other.order == order &&
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
      order,
      minWidth,
      maxWidth,
      isResizable,
      forceTooltip,
    );
  }

  @override
  String toString() {
    return 'BasicTableColumn(id: $id, name: $name, order: $order, minWidth: $minWidth)';
  }
}
