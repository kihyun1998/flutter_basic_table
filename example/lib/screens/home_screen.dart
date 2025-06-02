// example/lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

import '../data/sample_data.dart';
import '../themes/table_theme.dart';

/// 메인 테이블 화면
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 상태 관리
  Set<int> selectedRows = {};
  Map<int, ColumnSortState> columnSortStates = {};

  // 테이블 데이터
  late List<BasicTableColumn> tableColumns;
  late List<BasicTableRow> tableRows;

  // 백업 데이터 (정렬 해제시 복원용)
  late List<BasicTableColumn> originalTableColumns;
  late List<BasicTableRow> originalTableRows;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// 데이터 초기화 및 백업 생성
  void _initializeData() {
    // 샘플 데이터 가져오기
    tableColumns = SampleData.columns;
    tableRows = SampleData.generateRows();

    // 백업 데이터 생성
    originalTableColumns = SampleData.deepCopyColumns(tableColumns);
    originalTableRows = SampleData.deepCopyRows(tableRows);
  }

  /// 행 선택/해제 콜백
  void onRowSelectionChanged(int index, bool selected) {
    setState(() {
      if (selected) {
        selectedRows.add(index);
      } else {
        selectedRows.remove(index);
      }
    });

    debugPrint(
        'Row $index ${selected ? 'selected' : 'deselected'}. Total selected: ${selectedRows.length}');
  }

  /// 전체 선택/해제 콜백
  void onSelectAllChanged(bool selectAll) {
    setState(() {
      if (selectAll) {
        selectedRows =
            Set.from(List.generate(tableRows.length, (index) => index));
      } else {
        selectedRows.clear();
      }
    });

    debugPrint(
        '${selectAll ? 'Select all' : 'Deselect all'}. Total selected: ${selectedRows.length}');
  }

  /// 행 클릭 콜백
  void onRowTap(int index) {
    debugPrint('Row $index tapped');
  }

  /// 행 더블클릭 콜백
  void onRowDoubleTap(int index) {
    debugPrint('Row $index double-tapped');
    _showDialog('더블클릭!', '$index번 행을 더블클릭했습니다.');
  }

  /// 행 우클릭 콜백
  void onRowSecondaryTap(int index) {
    debugPrint('Row $index right-clicked');
    _showDialog('우클릭!', '$index번 행을 우클릭했습니다.');
  }

  /// 컬럼 정렬 콜백
  void onColumnSort(int columnIndex, ColumnSortState sortState) {
    setState(() {
      // 다른 컬럼의 정렬 상태 초기화 (한 번에 하나의 컬럼만 정렬)
      columnSortStates.clear();

      if (sortState != ColumnSortState.none) {
        columnSortStates[columnIndex] = sortState;
        _sortTableData(columnIndex, sortState);
      } else {
        // 원래 상태로 완전히 복원 (데이터 + 컬럼 순서 모두)
        tableRows = SampleData.deepCopyRows(originalTableRows);
        tableColumns = SampleData.deepCopyColumns(originalTableColumns);
      }
    });

    debugPrint('Column sort: column $columnIndex -> $sortState');
  }

  /// 컬럼 순서 변경 콜백
  void onColumnReorder(int oldIndex, int newIndex) {
    setState(() {
      // newIndex 보정
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      // 컬럼 순서 변경
      final BasicTableColumn movedColumn = tableColumns.removeAt(oldIndex);
      tableColumns.insert(newIndex, movedColumn);

      // 모든 행의 데이터도 재정렬
      tableRows =
          tableRows.map((row) => row.reorderCells(oldIndex, newIndex)).toList();

      // 원본 데이터도 함께 업데이트 (정렬 해제시 현재 컬럼 순서 유지)
      final BasicTableColumn movedOriginalColumn =
          originalTableColumns.removeAt(oldIndex);
      originalTableColumns.insert(newIndex, movedOriginalColumn);

      originalTableRows = originalTableRows
          .map((row) => row.reorderCells(oldIndex, newIndex))
          .toList();
    });

    debugPrint('Column order changed: $oldIndex -> $newIndex');

    // 현재 컬럼 순서 출력
    final columnNames = tableColumns.map((col) => col.name).join(', ');
    debugPrint('New column order: $columnNames');
  }

  /// 테이블 데이터 정렬
  void _sortTableData(int columnIndex, ColumnSortState sortState) {
    if (columnIndex >= tableColumns.length) return;

    tableRows.sort((a, b) {
      final String valueA = a.getComparableValue(columnIndex);
      final String valueB = b.getComparableValue(columnIndex);

      // 숫자인지 확인해서 숫자면 숫자로 정렬, 아니면 문자열로 정렬
      final numA = a.getNumericValue(columnIndex);
      final numB = b.getNumericValue(columnIndex);

      int comparison;
      if (numA != null && numB != null) {
        // 둘 다 숫자면 숫자로 비교
        comparison = numA.compareTo(numB);
      } else {
        // 문자열로 비교
        comparison = valueA.compareTo(valueB);
      }

      // 내림차순이면 결과 반전
      return sortState == ColumnSortState.descending ? -comparison : comparison;
    });
  }

  /// 다이얼로그 표시 헬퍼
  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  /// 선택된 항목 보기
  void _showSelectedItems() {
    _showDialog('선택된 항목', '선택된 행들의 인덱스:\n${selectedRows.toList()..sort()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Table Demo - 상태 정렬 테스트'),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black87,
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // 선택 상태 + 컬럼 순서 표시 카드
          _buildInfoCard(),

          // 테이블 카드
          _buildTableCard(),
        ],
      ),
    );
  }

  /// 정보 표시 카드 위젯
  Widget _buildInfoCard() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '선택된 행: ${selectedRows.length}개',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                ),
                if (selectedRows.isNotEmpty)
                  ElevatedButton(
                    onPressed: _showSelectedItems,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('선택 항목 보기'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '컬럼 순서: ${tableColumns.map((col) => col.name).join(' → ')}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 테이블 카드 위젯
  Widget _buildTableCard() {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(8.0),
        color: Colors.white,
        elevation: 1,
        child: BasicTable(
          columns: tableColumns,
          rows: tableRows,
          theme: AppTableTheme.monochrome, // 테마 적용
          selectedRows: selectedRows,
          onRowSelectionChanged: onRowSelectionChanged,
          onSelectAllChanged: onSelectAllChanged,
          onRowTap: onRowTap,
          onRowDoubleTap: onRowDoubleTap,
          onRowSecondaryTap: onRowSecondaryTap,
          doubleClickTime: const Duration(milliseconds: 250),
          onColumnReorder: onColumnReorder,
          onColumnSort: onColumnSort,
          columnSortStates: columnSortStates,
        ),
      ),
    );
  }
}
