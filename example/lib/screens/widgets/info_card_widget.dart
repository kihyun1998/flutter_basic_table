import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

/// 테이블 상태 정보를 표시하는 카드 위젯 (Map 기반)
class InfoCardWidget extends StatelessWidget {
  final int selectedRowCount;

  /// 보이는 컬럼 Map
  final Map<String, BasicTableColumn> visibleColumns;

  /// 모든 컬럼 Map
  final Map<String, BasicTableColumn> allColumns;

  final ColumnSortManager sortManager;
  final Set<String> hiddenColumnIds;
  final bool useVariableHeight;
  final VoidCallback onShowSelectedItems;
  final VoidCallback onShowSortInfo;
  final VoidCallback onToggleHeightMode;

  /// 새로운 디버그 기능
  final VoidCallback onShowDebugInfo;

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
    required this.onShowDebugInfo,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '선택된 행: $selectedRowCount개',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Map 기반 테이블 시스템',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                _buildActionButtons(),
              ],
            ),
            const SizedBox(height: 8),

            // 보이는 컬럼 정보 (order 순서로)
            _buildColumnInfo(),
            const SizedBox(height: 4),

            // 상태 아이콘들과 정보
            _buildStatusIcons(),
          ],
        ),
      ),
    );
  }

  /// 컬럼 정보 표시 (order 순서)
  Widget _buildColumnInfo() {
    final sortedColumns = BasicTableColumn.mapToSortedList(visibleColumns);
    final columnNames =
        sortedColumns.map((col) => '${col.name}(${col.order})').join(' → ');

    return Text(
      '보이는 컬럼: $columnNames',
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
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

        // 디버그 정보 버튼 (새로운 기능)
        ElevatedButton(
          onPressed: onShowDebugInfo,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          child: const Text('🐛 디버그', style: TextStyle(fontSize: 12)),
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
    return Wrap(
      spacing: 16.0,
      runSpacing: 4.0,
      children: [
        // 정렬 상태 아이콘
        _buildStatusItem(
          icon: sortManager.hasSortedColumn ? Icons.sort : Icons.sort_outlined,
          color: sortManager.hasSortedColumn ? Colors.green : Colors.grey[600]!,
          text: sortManager.hasSortedColumn
              ? '정렬됨: ${sortManager.currentSortedColumnId}'
              : '정렬 없음',
        ),

        // Visibility 상태 아이콘
        _buildStatusItem(
          icon: hiddenColumnIds.isNotEmpty
              ? Icons.visibility_off
              : Icons.visibility,
          color: hiddenColumnIds.isNotEmpty ? Colors.orange : Colors.grey[600]!,
          text: '${visibleColumns.length}/${allColumns.length} 컬럼',
        ),

        // 높이 모드 아이콘
        _buildStatusItem(
          icon: useVariableHeight ? Icons.height : Icons.horizontal_rule,
          color: useVariableHeight ? Colors.orange : Colors.grey[600]!,
          text: useVariableHeight ? '가변 높이' : '기본 높이',
        ),

        // Map 기반 시스템 표시
        _buildStatusItem(
          icon: Icons.account_tree,
          color: Colors.blue,
          text: 'Map 기반',
        ),

        // 숨겨진 컬럼 표시 (있을 때만)
        if (hiddenColumnIds.isNotEmpty)
          _buildStatusItem(
            icon: Icons.hide_source,
            color: Colors.red,
            text: '숨김: ${hiddenColumnIds.length}개',
          ),
      ],
    );
  }

  /// 개별 상태 아이템 빌드
  Widget _buildStatusItem({
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
