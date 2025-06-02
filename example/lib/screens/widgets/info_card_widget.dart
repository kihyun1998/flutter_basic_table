import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

/// 테이블 상태 정보를 표시하는 카드 위젯
class InfoCardWidget extends StatelessWidget {
  final int selectedRowCount;
  final List<BasicTableColumn> visibleColumns;
  final List<BasicTableColumn> allColumns;
  final ColumnSortManager sortManager;
  final Set<String> hiddenColumnIds;
  final bool useVariableHeight;
  final VoidCallback onShowSelectedItems;
  final VoidCallback onShowSortInfo;
  final VoidCallback onToggleHeightMode;

  const InfoCardWidget({
    super.key,
    required this.selectedRowCount,
    required this.visibleColumns,
    required this.allColumns,
    required this.sortManager,
    required this.hiddenColumnIds,
    required this.useVariableHeight,
    required this.onShowSelectedItems,
    required this.onShowSortInfo,
    required this.onToggleHeightMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 행: 선택된 행 개수와 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '선택된 행: $selectedRowCount개',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                _buildActionButtons(),
              ],
            ),
            const SizedBox(height: 8),

            // 보이는 컬럼 정보
            Text(
              '보이는 컬럼: ${visibleColumns.map((col) => col.name).join(' → ')}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),

            // 상태 아이콘들과 정보
            _buildStatusIcons(),
          ],
        ),
      ),
    );
  }

  /// 액션 버튼들 빌드
  Widget _buildActionButtons() {
    return Row(
      children: [
        // 선택 항목 보기 버튼
        if (selectedRowCount > 0)
          ElevatedButton(
            onPressed: onShowSelectedItems,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
            ),
            child: const Text('선택 항목 보기'),
          ),

        if (selectedRowCount > 0) const SizedBox(width: 8),

        // 정렬 정보 버튼
        ElevatedButton(
          onPressed: onShowSortInfo,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                sortManager.hasSortedColumn ? Colors.green : Colors.grey,
            foregroundColor: Colors.white,
          ),
          child: const Text('정렬 정보'),
        ),
        const SizedBox(width: 8),

        // 높이 모드 전환 버튼
        ElevatedButton(
          onPressed: onToggleHeightMode,
          style: ElevatedButton.styleFrom(
            backgroundColor: useVariableHeight ? Colors.orange : Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: Text(useVariableHeight ? '기본 높이 모드' : '가변 높이 모드'),
        ),
      ],
    );
  }

  /// 상태 아이콘들과 정보 빌드
  Widget _buildStatusIcons() {
    return Row(
      children: [
        // 정렬 상태 아이콘
        Icon(
          sortManager.hasSortedColumn ? Icons.sort : Icons.sort_outlined,
          size: 16,
          color: sortManager.hasSortedColumn ? Colors.green : Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          sortManager.hasSortedColumn
              ? '정렬됨: ${sortManager.currentSortedColumnId}'
              : '정렬 없음',
          style: TextStyle(
            fontSize: 12,
            color:
                sortManager.hasSortedColumn ? Colors.green : Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(width: 16),

        // Visibility 상태 아이콘
        Icon(
          hiddenColumnIds.isNotEmpty ? Icons.visibility_off : Icons.visibility,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          '${visibleColumns.length}/${allColumns.length} 컬럼 표시',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(width: 16),

        // 높이 모드 아이콘
        Icon(
          useVariableHeight ? Icons.height : Icons.horizontal_rule,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          useVariableHeight ? '가변 높이 모드' : '기본 높이 모드',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
