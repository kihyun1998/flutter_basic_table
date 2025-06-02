import 'package:flutter_basic_table/flutter_basic_table.dart';

/// 컬럼 정렬 상태를 ID 기반으로 관리하는 클래스
/// 컬럼 순서가 바뀌어도 정렬 상태가 올바른 컬럼을 따라가도록 보장
class ColumnSortManager {
  /// ID 기반 정렬 상태 저장소
  final Map<String, ColumnSortState> _sortStates = {};

  /// 현재 정렬 중인 컬럼 ID (한 번에 하나만 정렬 가능)
  String? _currentSortedColumnId;

  /// 기본 생성자
  ColumnSortManager();

  /// 기존 인덱스 기반 Map에서 생성 (하위 호환성)
  ColumnSortManager.fromIndexMap(
    Map<int, ColumnSortState> indexMap,
    List<BasicTableColumn> columns,
  ) {
    for (final entry in indexMap.entries) {
      final int index = entry.key;
      final ColumnSortState state = entry.value;

      if (index >= 0 && index < columns.length) {
        final String columnId = columns[index].effectiveId;
        _sortStates[columnId] = state;

        if (state != ColumnSortState.none) {
          _currentSortedColumnId = columnId;
        }
      }
    }
  }

  /// 특정 컬럼의 정렬 상태 가져오기
  ColumnSortState getSortState(String columnId) {
    return _sortStates[columnId] ?? ColumnSortState.none;
  }

  /// 특정 인덱스의 컬럼 정렬 상태 가져오기 (하위 호환성)
  ColumnSortState getSortStateByIndex(
      int index, List<BasicTableColumn> columns) {
    if (index < 0 || index >= columns.length) return ColumnSortState.none;
    return getSortState(columns[index].effectiveId);
  }

  /// 컬럼의 정렬 상태 설정
  void setSortState(String columnId, ColumnSortState state) {
    // 다른 컬럼의 정렬 해제 (한 번에 하나만 정렬)
    if (state != ColumnSortState.none) {
      _clearAllSortStates();
      _currentSortedColumnId = columnId;
    } else {
      _currentSortedColumnId = null;
    }

    _sortStates[columnId] = state;
  }

  /// 인덱스로 정렬 상태 설정 (하위 호환성)
  void setSortStateByIndex(
      int index, ColumnSortState state, List<BasicTableColumn> columns) {
    if (index < 0 || index >= columns.length) return;
    setSortState(columns[index].effectiveId, state);
  }

  /// 모든 정렬 상태 초기화
  void clearAll() {
    _sortStates.clear();
    _currentSortedColumnId = null;
  }

  /// 내부적으로 모든 정렬 상태를 none으로 설정
  void _clearAllSortStates() {
    for (final key in _sortStates.keys) {
      _sortStates[key] = ColumnSortState.none;
    }
  }

  /// 현재 정렬 중인 컬럼 ID
  String? get currentSortedColumnId => _currentSortedColumnId;

  /// 현재 정렬 중인 컬럼의 인덱스 (하위 호환성)
  int? getCurrentSortedColumnIndex(List<BasicTableColumn> columns) {
    if (_currentSortedColumnId == null) return null;

    for (int i = 0; i < columns.length; i++) {
      if (columns[i].effectiveId == _currentSortedColumnId) {
        return i;
      }
    }
    return null;
  }

  /// 정렬 상태가 있는지 확인
  bool get hasSortedColumn => _currentSortedColumnId != null;

  /// 인덱스 기반 Map으로 변환 (하위 호환성)
  Map<int, ColumnSortState> toIndexMap(List<BasicTableColumn> columns) {
    final Map<int, ColumnSortState> indexMap = {};

    for (int i = 0; i < columns.length; i++) {
      final String columnId = columns[i].effectiveId;
      final ColumnSortState state = getSortState(columnId);

      if (state != ColumnSortState.none) {
        indexMap[i] = state;
      }
    }

    return indexMap;
  }

  /// 디버그용 정보 출력
  void printDebugInfo(List<BasicTableColumn> columns) {
    print('🔍 ColumnSortManager Debug Info:');
    print('   Current sorted column: $_currentSortedColumnId');
    print('   Sort states:');
    for (int i = 0; i < columns.length; i++) {
      final column = columns[i];
      final state = getSortState(column.effectiveId);
      print('     [$i] ${column.name} (${column.effectiveId}): $state');
    }
  }

  /// 복사본 생성
  ColumnSortManager copy() {
    final manager = ColumnSortManager();
    manager._sortStates.addAll(_sortStates);
    manager._currentSortedColumnId = _currentSortedColumnId;
    return manager;
  }

  @override
  String toString() {
    return 'ColumnSortManager(currentSorted: $_currentSortedColumnId, states: $_sortStates)';
  }
}
