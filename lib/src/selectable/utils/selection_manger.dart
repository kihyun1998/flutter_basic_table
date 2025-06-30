// lib/src/selectable/utils/selection_manager.dart

/// SelectableTable의 행 선택 상태를 관리하는 클래스
class SelectionManager {
  /// 선택된 행들의 인덱스 Set
  final Set<int> _selectedRows = <int>{};

  /// 다중 선택 활성화 여부
  bool _multiSelectionEnabled;

  /// 전체 행 개수 (전체 선택/해제에 사용)
  int _totalRowCount;

  SelectionManager({
    bool multiSelectionEnabled = true,
    int totalRowCount = 0,
  })  : _multiSelectionEnabled = multiSelectionEnabled,
        _totalRowCount = totalRowCount;

  /// 현재 선택된 행들 (읽기 전용)
  Set<int> get selectedRows => Set.unmodifiable(_selectedRows);

  /// 선택된 행 개수
  int get selectedCount => _selectedRows.length;

  /// 전체 행 개수
  int get totalRowCount => _totalRowCount;

  /// 다중 선택 활성화 여부
  bool get isMultiSelectionEnabled => _multiSelectionEnabled;

  /// 모든 행이 선택되었는지 확인
  bool get isAllSelected =>
      _selectedRows.length == _totalRowCount && _totalRowCount > 0;

  /// 일부 행이 선택되었는지 확인
  bool get isSomeSelected => _selectedRows.isNotEmpty && !isAllSelected;

  /// 선택된 행이 없는지 확인
  bool get isNoneSelected => _selectedRows.isEmpty;

  /// 특정 행이 선택되었는지 확인
  bool isRowSelected(int rowIndex) {
    return _selectedRows.contains(rowIndex);
  }

  /// 전체 행 개수 업데이트
  void updateTotalRowCount(int newCount) {
    _totalRowCount = newCount;

    // 존재하지 않는 행 인덱스 제거
    _selectedRows.removeWhere((index) => index >= newCount);
  }

  /// 다중 선택 활성화/비활성화
  void setMultiSelectionEnabled(bool enabled) {
    _multiSelectionEnabled = enabled;

    // 다중 선택이 비활성화되면 첫 번째 선택만 유지
    if (!enabled && _selectedRows.length > 1) {
      final firstSelected = _selectedRows.first;
      _selectedRows.clear();
      _selectedRows.add(firstSelected);
    }
  }

  /// 단일 행 선택/해제
  void toggleRowSelection(int rowIndex) {
    if (rowIndex < 0 || rowIndex >= _totalRowCount) return;

    if (_selectedRows.contains(rowIndex)) {
      // 이미 선택된 행이면 해제
      _selectedRows.remove(rowIndex);
    } else {
      // 선택되지 않은 행이면 선택
      if (_multiSelectionEnabled) {
        _selectedRows.add(rowIndex);
      } else {
        // 단일 선택 모드면 기존 선택 해제 후 새로 선택
        _selectedRows.clear();
        _selectedRows.add(rowIndex);
      }
    }
  }

  /// 특정 행을 강제로 선택
  void selectRow(int rowIndex) {
    if (rowIndex < 0 || rowIndex >= _totalRowCount) return;

    if (_multiSelectionEnabled) {
      _selectedRows.add(rowIndex);
    } else {
      _selectedRows.clear();
      _selectedRows.add(rowIndex);
    }
  }

  /// 특정 행을 강제로 해제
  void deselectRow(int rowIndex) {
    _selectedRows.remove(rowIndex);
  }

  /// 여러 행을 한번에 선택
  void selectRows(List<int> rowIndexes) {
    if (!_multiSelectionEnabled) {
      // 단일 선택 모드면 마지막 행만 선택
      if (rowIndexes.isNotEmpty) {
        final lastIndex = rowIndexes.last;
        if (lastIndex >= 0 && lastIndex < _totalRowCount) {
          _selectedRows.clear();
          _selectedRows.add(lastIndex);
        }
      }
      return;
    }

    // 다중 선택 모드
    for (final index in rowIndexes) {
      if (index >= 0 && index < _totalRowCount) {
        _selectedRows.add(index);
      }
    }
  }

  /// 여러 행을 한번에 해제
  void deselectRows(List<int> rowIndexes) {
    for (final index in rowIndexes) {
      _selectedRows.remove(index);
    }
  }

  /// 범위 선택 (fromIndex부터 toIndex까지)
  void selectRange(int fromIndex, int toIndex) {
    if (!_multiSelectionEnabled) return;

    final start = fromIndex < toIndex ? fromIndex : toIndex;
    final end = fromIndex < toIndex ? toIndex : fromIndex;

    for (int i = start; i <= end; i++) {
      if (i >= 0 && i < _totalRowCount) {
        _selectedRows.add(i);
      }
    }
  }

  /// 전체 선택
  void selectAll() {
    if (!_multiSelectionEnabled) return;

    _selectedRows.clear();
    for (int i = 0; i < _totalRowCount; i++) {
      _selectedRows.add(i);
    }
  }

  /// 전체 해제
  void clearSelection() {
    _selectedRows.clear();
  }

  /// 선택 상태 반전
  void invertSelection() {
    if (!_multiSelectionEnabled) return;

    final Set<int> newSelection = <int>{};
    for (int i = 0; i < _totalRowCount; i++) {
      if (!_selectedRows.contains(i)) {
        newSelection.add(i);
      }
    }

    _selectedRows.clear();
    _selectedRows.addAll(newSelection);
  }

  /// 선택된 행들을 정렬된 리스트로 반환
  List<int> getSelectedRowsAsList() {
    final list = _selectedRows.toList();
    list.sort();
    return list;
  }

  /// 선택 상태를 외부 Set으로 설정 (동기화용)
  void setSelection(Set<int> newSelection) {
    _selectedRows.clear();

    if (_multiSelectionEnabled) {
      // 다중 선택 모드: 유효한 인덱스만 추가
      for (final index in newSelection) {
        if (index >= 0 && index < _totalRowCount) {
          _selectedRows.add(index);
        }
      }
    } else {
      // 단일 선택 모드: 첫 번째 유효한 인덱스만 추가
      for (final index in newSelection) {
        if (index >= 0 && index < _totalRowCount) {
          _selectedRows.add(index);
          break;
        }
      }
    }
  }

  /// 헤더 체크박스 상태 계산
  /// Returns: true (전체 선택), false (전체 해제), null (일부 선택)
  bool? getHeaderCheckboxState() {
    if (isAllSelected) return true;
    if (isNoneSelected) return false;
    return null; // indeterminate
  }

  /// 헤더 체크박스 클릭 처리
  void handleHeaderCheckboxToggle() {
    if (isAllSelected || isSomeSelected) {
      clearSelection();
    } else {
      selectAll();
    }
  }

  /// 디버그 정보 출력
  void printDebugInfo() {
    print('🔍 SelectionManager Debug Info:');
    print('   Total rows: $_totalRowCount');
    print('   Selected count: ${_selectedRows.length}');
    print('   Multi-selection: $_multiSelectionEnabled');
    print('   Selected rows: ${getSelectedRowsAsList().join(', ')}');
    print('   Header checkbox state: ${getHeaderCheckboxState()}');
  }

  /// 선택 상태 요약
  String getSelectionSummary() {
    if (isNoneSelected) return 'No rows selected';
    if (isAllSelected) return 'All $_totalRowCount rows selected';
    return '${_selectedRows.length} of $_totalRowCount rows selected';
  }

  /// 복사본 생성
  SelectionManager copy() {
    final manager = SelectionManager(
      multiSelectionEnabled: _multiSelectionEnabled,
      totalRowCount: _totalRowCount,
    );
    manager._selectedRows.addAll(_selectedRows);
    return manager;
  }

  @override
  String toString() {
    return 'SelectionManager(selected: ${_selectedRows.length}/$_totalRowCount, multi: $_multiSelectionEnabled)';
  }
}
