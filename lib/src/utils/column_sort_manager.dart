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
    List<BasicTableColumn> sortedColumns,
  ) {
    for (final entry in indexMap.entries) {
      final int index = entry.key;
      final ColumnSortState state = entry.value;

      if (index >= 0 && index < sortedColumns.length) {
        final String columnId = sortedColumns[index].id;
        _sortStates[columnId] = state;

        if (state != ColumnSortState.none) {
          _currentSortedColumnId = columnId;
        }
      }
    }
  }

  /// Map<String, BasicTableColumn>에서 생성
  ColumnSortManager.fromColumnMap(
    Map<String, BasicTableColumn> columns,
    Map<String, ColumnSortState> sortStates,
  ) {
    for (final entry in sortStates.entries) {
      final columnId = entry.key;
      final state = entry.value;

      if (columns.containsKey(columnId)) {
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
      int index, List<BasicTableColumn> sortedColumns) {
    if (index < 0 || index >= sortedColumns.length) return ColumnSortState.none;
    return getSortState(sortedColumns[index].id);
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
      int index, ColumnSortState state, List<BasicTableColumn> sortedColumns) {
    if (index < 0 || index >= sortedColumns.length) return;
    setSortState(sortedColumns[index].id, state);
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

  /// 현재 정렬 중인 컬럼의 visible 인덱스 (하위 호환성)
  int? getCurrentSortedColumnIndex(List<BasicTableColumn> sortedColumns) {
    if (_currentSortedColumnId == null) return null;

    for (int i = 0; i < sortedColumns.length; i++) {
      if (sortedColumns[i].id == _currentSortedColumnId) {
        return i;
      }
    }
    return null;
  }

  /// Map에서 현재 정렬 중인 컬럼 찾기
  BasicTableColumn? getCurrentSortedColumn(
      Map<String, BasicTableColumn> columns) {
    if (_currentSortedColumnId == null) return null;
    return columns[_currentSortedColumnId];
  }

  /// 정렬 상태가 있는지 확인
  bool get hasSortedColumn => _currentSortedColumnId != null;

  /// 모든 정렬 상태를 ID 기반 Map으로 반환
  Map<String, ColumnSortState> get allSortStates {
    return Map<String, ColumnSortState>.from(_sortStates);
  }

  /// 활성 정렬 상태만 반환 (none이 아닌 것들)
  Map<String, ColumnSortState> get activeSortStates {
    final Map<String, ColumnSortState> result = {};

    for (final entry in _sortStates.entries) {
      if (entry.value != ColumnSortState.none) {
        result[entry.key] = entry.value;
      }
    }

    return result;
  }

  /// 인덱스 기반 Map으로 변환 (하위 호환성)
  Map<int, ColumnSortState> toIndexMap(List<BasicTableColumn> sortedColumns) {
    final Map<int, ColumnSortState> indexMap = {};

    for (int i = 0; i < sortedColumns.length; i++) {
      final String columnId = sortedColumns[i].id;
      final ColumnSortState state = getSortState(columnId);

      if (state != ColumnSortState.none) {
        indexMap[i] = state;
      }
    }

    return indexMap;
  }

  /// Map 기반 컬럼에서 인덱스 Map으로 변환
  Map<int, ColumnSortState> toIndexMapFromColumnMap(
      Map<String, BasicTableColumn> columns) {
    final sortedColumns = BasicTableColumn.mapToSortedList(columns);
    return toIndexMap(sortedColumns);
  }

  /// 특정 컬럼들만 필터링된 정렬 상태 반환
  Map<String, ColumnSortState> getFilteredSortStates(Set<String> columnIds) {
    final Map<String, ColumnSortState> result = {};

    for (final columnId in columnIds) {
      if (_sortStates.containsKey(columnId)) {
        result[columnId] = _sortStates[columnId]!;
      }
    }

    return result;
  }

  /// 컬럼 visibility에 따른 정렬 상태 정리
  void cleanupHiddenColumns(Set<String> visibleColumnIds) {
    final keysToRemove = <String>[];

    for (final columnId in _sortStates.keys) {
      if (!visibleColumnIds.contains(columnId)) {
        keysToRemove.add(columnId);
      }
    }

    for (final key in keysToRemove) {
      _sortStates.remove(key);

      // 현재 정렬 중인 컬럼이 숨겨진 경우 초기화
      if (_currentSortedColumnId == key) {
        _currentSortedColumnId = null;
      }
    }
  }

  /// 정렬 상태 유효성 검사
  bool isValid(Map<String, BasicTableColumn> columns) {
    // 모든 정렬 상태의 컬럼 ID가 실제 컬럼에 존재하는지 확인
    for (final columnId in _sortStates.keys) {
      if (!columns.containsKey(columnId)) {
        return false;
      }
    }

    // 현재 정렬 중인 컬럼이 실제 존재하는지 확인
    if (_currentSortedColumnId != null &&
        !columns.containsKey(_currentSortedColumnId)) {
      return false;
    }

    return true;
  }

  /// 무효한 정렬 상태 정리
  void cleanup(Map<String, BasicTableColumn> columns) {
    final keysToRemove = <String>[];

    for (final columnId in _sortStates.keys) {
      if (!columns.containsKey(columnId)) {
        keysToRemove.add(columnId);
      }
    }

    for (final key in keysToRemove) {
      _sortStates.remove(key);
    }

    // 현재 정렬 중인 컬럼이 무효한 경우 초기화
    if (_currentSortedColumnId != null &&
        !columns.containsKey(_currentSortedColumnId)) {
      _currentSortedColumnId = null;
    }
  }

  /// 디버그용 정보 출력 (List 기반)
  void printDebugInfo(List<BasicTableColumn> sortedColumns) {
    print('🔍 ColumnSortManager Debug Info:');
    print('   Current sorted column: $_currentSortedColumnId');
    print('   Sort states:');
    for (int i = 0; i < sortedColumns.length; i++) {
      final column = sortedColumns[i];
      final state = getSortState(column.id);
      print('     [$i] ${column.name} (${column.id}): $state');
    }
  }

  /// 디버그용 정보 출력 (Map 기반)
  void printDebugInfoFromMap(Map<String, BasicTableColumn> columns) {
    final sortedColumns = BasicTableColumn.mapToSortedList(columns);
    printDebugInfo(sortedColumns);
  }

  /// 현재 상태를 간단한 요약으로 출력
  void printSummary() {
    print(
        '🔍 Sort Summary: ${_currentSortedColumnId ?? 'None'} (${_sortStates.length} states)');
  }

  /// 복사본 생성
  ColumnSortManager copy() {
    final manager = ColumnSortManager();
    manager._sortStates.addAll(_sortStates);
    manager._currentSortedColumnId = _currentSortedColumnId;
    return manager;
  }

  /// 다른 ColumnSortManager와 병합
  void mergeWith(ColumnSortManager other) {
    // 기존 상태 초기화
    clearAll();

    // other의 상태 복사
    _sortStates.addAll(other._sortStates);
    _currentSortedColumnId = other._currentSortedColumnId;
  }

  @override
  String toString() {
    return 'ColumnSortManager(currentSorted: $_currentSortedColumnId, states: $_sortStates)';
  }

  /// JSON과 유사한 형태로 직렬화 (Map 반환)
  Map<String, dynamic> toJson() {
    return {
      'currentSortedColumnId': _currentSortedColumnId,
      'sortStates': _sortStates.map((key, value) => MapEntry(key, value.name)),
    };
  }

  /// JSON에서 복원
  factory ColumnSortManager.fromJson(Map<String, dynamic> json) {
    final manager = ColumnSortManager();

    manager._currentSortedColumnId = json['currentSortedColumnId'];

    final sortStatesMap = json['sortStates'] as Map<String, dynamic>? ?? {};
    for (final entry in sortStatesMap.entries) {
      final state = ColumnSortState.values.firstWhere(
        (s) => s.name == entry.value,
        orElse: () => ColumnSortState.none,
      );
      manager._sortStates[entry.key] = state;
    }

    return manager;
  }
}
