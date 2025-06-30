// lib/src/selectable/utils/sort_manager.dart
import '../../shared/enums/column_sort_state.dart';

/// SelectableTable의 컬럼 정렬 상태를 관리하는 클래스
class SelectableSortManager {
  /// 컬럼 ID 기반 정렬 상태 저장소
  final Map<String, ColumnSortState> _sortStates = {};

  /// 현재 정렬 중인 컬럼 ID (한 번에 하나만 정렬 가능)
  String? _currentSortedColumnId;

  /// 기본 생성자
  SelectableSortManager();

  /// 특정 컬럼의 정렬 상태 가져오기
  ColumnSortState getSortState(String columnId) {
    return _sortStates[columnId] ?? ColumnSortState.none;
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

  /// 컬럼 정렬 토글 (none → ascending → descending → none)
  ColumnSortState toggleColumnSort(String columnId) {
    final currentState = getSortState(columnId);
    final nextState = _getNextSortState(currentState);
    setSortState(columnId, nextState);
    return nextState;
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

  /// 다음 정렬 상태 계산
  ColumnSortState _getNextSortState(ColumnSortState current) {
    switch (current) {
      case ColumnSortState.none:
        return ColumnSortState.ascending;
      case ColumnSortState.ascending:
        return ColumnSortState.descending;
      case ColumnSortState.descending:
        return ColumnSortState.none;
    }
  }

  /// 현재 정렬 중인 컬럼 ID
  String? get currentSortedColumnId => _currentSortedColumnId;

  /// 정렬 상태가 있는지 확인
  bool get hasSortedColumn => _currentSortedColumnId != null;

  /// 현재 정렬 중인 컬럼의 정렬 상태
  ColumnSortState? get currentSortState {
    if (_currentSortedColumnId == null) return null;
    return getSortState(_currentSortedColumnId!);
  }

  /// 모든 정렬 상태를 컬럼 ID 기반 Map으로 반환
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
  bool isValid(Set<String> validColumnIds) {
    // 모든 정렬 상태의 컬럼 ID가 실제 컬럼에 존재하는지 확인
    for (final columnId in _sortStates.keys) {
      if (!validColumnIds.contains(columnId)) {
        return false;
      }
    }

    // 현재 정렬 중인 컬럼이 실제 존재하는지 확인
    if (_currentSortedColumnId != null &&
        !validColumnIds.contains(_currentSortedColumnId)) {
      return false;
    }

    return true;
  }

  /// 무효한 정렬 상태 정리
  void cleanup(Set<String> validColumnIds) {
    final keysToRemove = <String>[];

    for (final columnId in _sortStates.keys) {
      if (!validColumnIds.contains(columnId)) {
        keysToRemove.add(columnId);
      }
    }

    for (final key in keysToRemove) {
      _sortStates.remove(key);
    }

    // 현재 정렬 중인 컬럼이 무효한 경우 초기화
    if (_currentSortedColumnId != null &&
        !validColumnIds.contains(_currentSortedColumnId)) {
      _currentSortedColumnId = null;
    }
  }

  /// 정렬된 데이터 생성을 위한 비교 함수 반환
  int Function(T, T)? getComparator<T>(
    String Function(T item) valueExtractor,
  ) {
    if (_currentSortedColumnId == null) return null;

    final sortState = currentSortState;
    if (sortState == null || sortState == ColumnSortState.none) return null;

    return (T a, T b) {
      final valueA = valueExtractor(a);
      final valueB = valueExtractor(b);

      // 숫자 파싱 시도
      final numA = num.tryParse(valueA);
      final numB = num.tryParse(valueB);

      int comparison;
      if (numA != null && numB != null) {
        // 둘 다 숫자인 경우 숫자로 비교
        comparison = numA.compareTo(numB);
      } else {
        // 하나라도 숫자가 아니면 문자열로 비교
        comparison = valueA.compareTo(valueB);
      }

      return sortState == ColumnSortState.descending ? -comparison : comparison;
    };
  }

  /// 리스트를 현재 정렬 설정에 따라 정렬
  List<T> sortList<T>(
    List<T> items,
    String Function(T item, String columnId) valueExtractor,
  ) {
    if (_currentSortedColumnId == null) return List.from(items);

    final comparator = getComparator<T>(
      (item) => valueExtractor(item, _currentSortedColumnId!),
    );

    if (comparator == null) return List.from(items);

    final sortedList = List<T>.from(items);
    sortedList.sort(comparator);
    return sortedList;
  }

  /// 디버그용 정보 출력
  void printDebugInfo() {
    print('🔍 SelectableSortManager Debug Info:');
    print('   Current sorted column: $_currentSortedColumnId');
    print('   Current sort state: $currentSortState');
    print('   All sort states:');

    if (_sortStates.isEmpty) {
      print('     (none)');
    } else {
      for (final entry in _sortStates.entries) {
        print('     ${entry.key}: ${entry.value}');
      }
    }

    final activeSorts = activeSortStates;
    print('   Active sorts: ${activeSorts.length}');
  }

  /// 현재 상태를 간단한 요약으로 출력
  void printSummary() {
    print(
        '🔍 Sort Summary: ${_currentSortedColumnId ?? 'None'} (${_sortStates.length} states)');
  }

  /// 복사본 생성
  SelectableSortManager copy() {
    final manager = SelectableSortManager();
    manager._sortStates.addAll(_sortStates);
    manager._currentSortedColumnId = _currentSortedColumnId;
    return manager;
  }

  /// 다른 SortManager와 병합
  void mergeWith(SelectableSortManager other) {
    // 기존 상태 초기화
    clearAll();

    // other의 상태 복사
    _sortStates.addAll(other._sortStates);
    _currentSortedColumnId = other._currentSortedColumnId;
  }

  @override
  String toString() {
    return 'SelectableSortManager(currentSorted: $_currentSortedColumnId, states: $_sortStates)';
  }
}
