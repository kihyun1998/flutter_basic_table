import 'package:flutter/material.dart';

/// 컬럼 정렬 상태를 나타내는 enum
///
/// SelectableTable과 EditableTable 모두에서 사용 가능한
/// 공통 정렬 상태를 정의합니다.
enum ColumnSortState {
  /// 정렬되지 않은 상태 (기본값)
  none,

  /// 오름차순 정렬
  ascending,

  /// 내림차순 정렬
  descending,
}

/// ColumnSortState의 유틸리티 확장
extension ColumnSortStateExtension on ColumnSortState {
  /// 다음 정렬 상태를 반환합니다.
  /// 순서: none → ascending → descending → none
  ColumnSortState get next {
    switch (this) {
      case ColumnSortState.none:
        return ColumnSortState.ascending;
      case ColumnSortState.ascending:
        return ColumnSortState.descending;
      case ColumnSortState.descending:
        return ColumnSortState.none;
    }
  }

  /// 이전 정렬 상태를 반환합니다.
  /// 순서: none ← ascending ← descending ← none
  ColumnSortState get previous {
    switch (this) {
      case ColumnSortState.none:
        return ColumnSortState.descending;
      case ColumnSortState.ascending:
        return ColumnSortState.none;
      case ColumnSortState.descending:
        return ColumnSortState.ascending;
    }
  }

  /// 정렬 상태가 활성화되어 있는지 확인합니다.
  bool get isActive => this != ColumnSortState.none;

  /// 정렬 상태가 비활성화되어 있는지 확인합니다.
  bool get isInactive => this == ColumnSortState.none;

  /// 오름차순 정렬인지 확인합니다.
  bool get isAscending => this == ColumnSortState.ascending;

  /// 내림차순 정렬인지 확인합니다.
  bool get isDescending => this == ColumnSortState.descending;

  /// 정렬 방향을 나타내는 문자열을 반환합니다.
  String get directionText {
    switch (this) {
      case ColumnSortState.none:
        return 'None';
      case ColumnSortState.ascending:
        return 'Ascending';
      case ColumnSortState.descending:
        return 'Descending';
    }
  }

  /// 정렬 방향을 나타내는 화살표 문자를 반환합니다.
  String get arrowText {
    switch (this) {
      case ColumnSortState.none:
        return '';
      case ColumnSortState.ascending:
        return '↑';
      case ColumnSortState.descending:
        return '↓';
    }
  }

  /// 정렬 방향을 나타내는 기본 아이콘을 반환합니다.
  IconData? get defaultIcon {
    switch (this) {
      case ColumnSortState.none:
        return null;
      case ColumnSortState.ascending:
        return Icons.keyboard_arrow_up;
      case ColumnSortState.descending:
        return Icons.keyboard_arrow_down;
    }
  }

  /// 정렬 방향을 나타내는 Material 아이콘을 반환합니다.
  IconData? get materialIcon {
    switch (this) {
      case ColumnSortState.none:
        return null;
      case ColumnSortState.ascending:
        return Icons.arrow_upward;
      case ColumnSortState.descending:
        return Icons.arrow_downward;
    }
  }

  /// 정렬 우선순위를 반환합니다. (정렬 알고리즘에서 사용)
  /// none: 0, ascending: 1, descending: -1
  int get sortMultiplier {
    switch (this) {
      case ColumnSortState.none:
        return 0;
      case ColumnSortState.ascending:
        return 1;
      case ColumnSortState.descending:
        return -1;
    }
  }

  /// 정렬 상태의 색상을 반환합니다. (기본 색상)
  Color? get defaultColor {
    switch (this) {
      case ColumnSortState.none:
        return Colors.grey[600];
      case ColumnSortState.ascending:
        return Colors.blue[700];
      case ColumnSortState.descending:
        return Colors.blue[700];
    }
  }

  /// 정렬 상태를 반전시킵니다.
  /// ascending ↔ descending, none은 그대로
  ColumnSortState get reversed {
    switch (this) {
      case ColumnSortState.none:
        return ColumnSortState.none;
      case ColumnSortState.ascending:
        return ColumnSortState.descending;
      case ColumnSortState.descending:
        return ColumnSortState.ascending;
    }
  }
}

/// 정렬 정보를 담는 모델 클래스
class ColumnSortInfo {
  /// 정렬된 컬럼의 인덱스
  final int columnIndex;

  /// 정렬된 컬럼의 ID (Map 기반에서 사용)
  final String? columnId;

  /// 정렬 상태
  final ColumnSortState state;

  /// 정렬 우선순위 (다중 정렬에서 사용)
  final int priority;

  /// 정렬 생성 시간
  final DateTime timestamp;

  ColumnSortInfo({
    required this.columnIndex,
    this.columnId,
    required this.state,
    this.priority = 0,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// 컬럼 ID 기반 생성자
  ColumnSortInfo.byId({
    required String columnId,
    required this.state,
    this.columnIndex = -1,
    this.priority = 0,
    DateTime? timestamp,
  })  : columnId = columnId,
        timestamp = timestamp ?? DateTime.now();

  /// 활성 정렬인지 확인
  bool get isActive => state.isActive;

  /// 정렬 방향 변경
  ColumnSortInfo withState(ColumnSortState newState) {
    return ColumnSortInfo(
      columnIndex: columnIndex,
      columnId: columnId,
      state: newState,
      priority: priority,
      timestamp: DateTime.now(),
    );
  }

  /// 다음 정렬 상태로 변경
  ColumnSortInfo toNext() {
    return withState(state.next);
  }

  /// 이전 정렬 상태로 변경
  ColumnSortInfo toPrevious() {
    return withState(state.previous);
  }

  /// 정렬 반전
  ColumnSortInfo toReversed() {
    return withState(state.reversed);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ColumnSortInfo &&
        other.columnIndex == columnIndex &&
        other.columnId == columnId &&
        other.state == state &&
        other.priority == priority;
  }

  @override
  int get hashCode {
    return Object.hash(columnIndex, columnId, state, priority);
  }

  @override
  String toString() {
    final idInfo = columnId != null ? ' ($columnId)' : '';
    return 'ColumnSortInfo(column: $columnIndex$idInfo, state: $state, priority: $priority)';
  }
}

/// 정렬 비교 결과를 나타내는 enum
enum SortCompareResult {
  /// 첫 번째 값이 더 작음
  less,

  /// 두 값이 같음
  equal,

  /// 첫 번째 값이 더 큼
  greater,
}

/// SortCompareResult의 유틸리티 확장
extension SortCompareResultExtension on SortCompareResult {
  /// 정수 값으로 변환 (-1, 0, 1)
  int get value {
    switch (this) {
      case SortCompareResult.less:
        return -1;
      case SortCompareResult.equal:
        return 0;
      case SortCompareResult.greater:
        return 1;
    }
  }

  /// 결과를 반전시킵니다.
  SortCompareResult get reversed {
    switch (this) {
      case SortCompareResult.less:
        return SortCompareResult.greater;
      case SortCompareResult.equal:
        return SortCompareResult.equal;
      case SortCompareResult.greater:
        return SortCompareResult.less;
    }
  }
}

/// 정렬 관련 유틸리티 함수들
class SortUtils {
  SortUtils._(); // private 생성자 (유틸리티 클래스)

  /// 두 값을 비교하여 SortCompareResult를 반환합니다.
  static SortCompareResult compare<T extends Comparable<T>>(T a, T b) {
    final result = a.compareTo(b);
    if (result < 0) return SortCompareResult.less;
    if (result > 0) return SortCompareResult.greater;
    return SortCompareResult.equal;
  }

  /// 문자열을 숫자로 파싱 시도 후 비교합니다.
  static SortCompareResult compareStringsAsNumbers(String a, String b) {
    final numA = num.tryParse(a);
    final numB = num.tryParse(b);

    if (numA != null && numB != null) {
      // 둘 다 숫자인 경우 숫자로 비교
      return compare(numA, numB);
    } else {
      // 하나라도 숫자가 아니면 문자열로 비교
      return compare(a, b);
    }
  }

  /// 대소문자를 무시하고 문자열을 비교합니다.
  static SortCompareResult compareStringsIgnoreCase(String a, String b) {
    return compare(a.toLowerCase(), b.toLowerCase());
  }

  /// 정렬 상태에 따라 비교 결과를 조정합니다.
  static SortCompareResult applySortState(
    SortCompareResult result,
    ColumnSortState sortState,
  ) {
    switch (sortState) {
      case ColumnSortState.none:
        return SortCompareResult.equal; // 정렬 없음 = 모두 같음
      case ColumnSortState.ascending:
        return result;
      case ColumnSortState.descending:
        return result.reversed;
    }
  }

  /// 리스트를 정렬 상태에 따라 정렬합니다.
  static List<T> sortList<T>(
    List<T> list,
    int Function(T a, T b) compareFn,
    ColumnSortState sortState,
  ) {
    if (sortState == ColumnSortState.none) {
      return List.from(list); // 원본 순서 유지
    }

    final sortedList = List<T>.from(list);
    sortedList.sort((a, b) {
      final result = compareFn(a, b);
      return sortState == ColumnSortState.descending ? -result : result;
    });

    return sortedList;
  }

  /// 안전한 문자열 비교 (null 처리 포함)
  static SortCompareResult safeCompareStrings(String? a, String? b) {
    if (a == null && b == null) return SortCompareResult.equal;
    if (a == null) return SortCompareResult.less;
    if (b == null) return SortCompareResult.greater;
    return compare(a, b);
  }

  /// 디버그용: 정렬 상태 정보를 문자열로 반환
  static String debugSortInfo(List<ColumnSortInfo> sortInfos) {
    if (sortInfos.isEmpty) {
      return '🔍 Sort Debug: No active sorts';
    }

    final buffer = StringBuffer();
    buffer.writeln('🔍 Sort Debug Info:');

    for (int i = 0; i < sortInfos.length; i++) {
      final info = sortInfos[i];
      final idInfo = info.columnId != null ? ' (${info.columnId})' : '';
      buffer.writeln(
          '  [${i + 1}] Column ${info.columnIndex}$idInfo: ${info.state.directionText} ${info.state.arrowText}');
    }

    return buffer.toString();
  }
}
