import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

import '../../themes/table_theme.dart';

/// 테이블을 담는 카드 위젯 (Map 기반)
class TableCardWidget extends StatelessWidget {
  /// 보이는 컬럼 Map
  final Map<String, BasicTableColumn> visibleColumns;

  final List<BasicTableRow> visibleRows;
  final Set<int> selectedRows;
  final ColumnSortManager sortManager;
  final Map<int, ColumnSortState> columnSortStates;

  // 콜백들
  final void Function(int index, bool selected) onRowSelectionChanged;
  final void Function(bool selectAll) onSelectAllChanged;
  final void Function(int index) onRowTap;
  final void Function(int index) onRowDoubleTap;
  final void Function(int index) onRowSecondaryTap;

  /// 새로운 시그니처: columnId와 newOrder 기반
  final void Function(String columnId, int newOrder) onColumnReorder;

  final void Function(int columnIndex, ColumnSortState sortState) onColumnSort;
  final void Function(String columnId, ColumnSortState sortState)
      onColumnSortById;

  const TableCardWidget({
    super.key,
    required this.visibleColumns,
    required this.visibleRows,
    required this.selectedRows,
    required this.sortManager,
    required this.columnSortStates,
    required this.onRowSelectionChanged,
    required this.onSelectAllChanged,
    required this.onRowTap,
    required this.onRowDoubleTap,
    required this.onRowSecondaryTap,
    required this.onColumnReorder,
    required this.onColumnSort,
    required this.onColumnSortById,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(8.0),
        color: Colors.white,
        elevation: 1,
        child: _buildTable(),
      ),
    );
  }

  /// 테이블 빌드
  Widget _buildTable() {
    // 빈 데이터 체크
    if (visibleColumns.isEmpty) {
      return _buildEmptyState('표시할 컬럼이 없습니다.\n컬럼을 선택해주세요.');
    }

    if (visibleRows.isEmpty) {
      return _buildEmptyState('표시할 데이터가 없습니다.');
    }

    // 디버그 정보 출력
    final sortedColumns = BasicTableColumn.mapToSortedList(visibleColumns);
    debugPrint(
        '🎨 TableCard rendering: ${sortedColumns.length} columns, ${visibleRows.length} rows');
    debugPrint(
        '📋 Column order: ${sortedColumns.map((c) => '${c.name}(${c.order})').join(' → ')}');

    return BasicTable(
      columns: visibleColumns, // Map 직접 전달
      rows: visibleRows,
      theme: AppTableTheme.monochrome,
      selectedRows: selectedRows,
      onRowSelectionChanged: onRowSelectionChanged,
      onSelectAllChanged: onSelectAllChanged,
      onRowTap: onRowTap,
      onRowDoubleTap: onRowDoubleTap,
      onRowSecondaryTap: onRowSecondaryTap,
      doubleClickTime: const Duration(milliseconds: 250),
      onColumnReorder: onColumnReorder, // 새로운 시그니처 (columnId, newOrder)
      onColumnSort: onColumnSort,
      onColumnSortById: onColumnSortById,
      sortManager: sortManager,
    );
  }

  /// 빈 상태 표시 위젯
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.table_chart_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          // 디버그 정보 표시
          Text(
            'Map 기반 테이블 (${visibleColumns.length} 컬럼)',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
