import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

/// 컬럼 visibility 제어를 위한 카드 위젯 (Map 기반)
class VisibilityControlCardWidget extends StatelessWidget {
  /// 모든 컬럼 Map
  final Map<String, BasicTableColumn> allColumns;

  final Set<String> hiddenColumnIds;
  final void Function(String columnId) onToggleVisibility;
  final VoidCallback onShowAllColumns;
  final VoidCallback onShowVisibilityInfo;

  /// 새로운 기능: Order 정규화
  final VoidCallback onNormalizeOrders;

  const VisibilityControlCardWidget({
    super.key,
    required this.allColumns,
    required this.hiddenColumnIds,
    required this.onToggleVisibility,
    required this.onShowAllColumns,
    required this.onShowVisibilityInfo,
    required this.onNormalizeOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 행
            _buildHeader(),
            const SizedBox(height: 12),

            // 컬럼 토글 칩들 (order 순서로 정렬)
            _buildColumnChips(),

            const SizedBox(height: 8),

            // 추가 정보 표시
            _buildInfoText(),
          ],
        ),
      ),
    );
  }

  /// 헤더 빌드 (제목과 액션 버튼들)
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '👁️ 컬럼 표시 설정',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Text(
              'Map 기반 (${allColumns.length}개 컬럼)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Order 정규화 버튼 (새로운 기능)
            ElevatedButton(
              onPressed: _needsNormalization() ? onNormalizeOrders : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _needsNormalization() ? Colors.orange : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: const Text('🔧 정규화', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(width: 8),

            // 모두 보이기 버튼
            ElevatedButton(
              onPressed: hiddenColumnIds.isNotEmpty ? onShowAllColumns : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('모두 보이기'),
            ),
            const SizedBox(width: 8),

            // Visibility 정보 버튼
            ElevatedButton(
              onPressed: onShowVisibilityInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Visibility 정보'),
            ),
          ],
        ),
      ],
    );
  }

  /// 컬럼 토글 칩들 빌드 (order 순서로 정렬)
  Widget _buildColumnChips() {
    // order 기준으로 정렬된 컬럼 리스트
    final sortedColumns = BasicTableColumn.mapToSortedList(allColumns);

    debugPrint(
        '🎯 Visibility chips: ${sortedColumns.map((c) => '${c.name}(${c.order})').join(', ')}');

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: sortedColumns.map((column) {
        final isVisible = !hiddenColumnIds.contains(column.id);

        return FilterChip(
          label: Text('${column.name} (${column.order})'), // order 정보 표시
          selected: isVisible,
          onSelected: (_) => onToggleVisibility(column.id), // ID 기반 토글
          selectedColor: Colors.green.withOpacity(0.2),
          checkmarkColor: Colors.green,
          avatar: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            size: 18,
            color: isVisible ? Colors.green : Colors.grey,
          ),
          // 선택되지 않았을 때의 스타일
          backgroundColor: isVisible ? null : Colors.red.withOpacity(0.1),
          side: isVisible
              ? null
              : BorderSide(color: Colors.red.withOpacity(0.3), width: 1),
          // Tooltip으로 상세 정보 제공
          tooltip: _buildColumnTooltip(column, isVisible),
        );
      }).toList(),
    );
  }

  /// 추가 정보 텍스트
  Widget _buildInfoText() {
    final visibleCount = allColumns.length - hiddenColumnIds.length;
    final needsNorm = _needsNormalization();

    return Row(
      children: [
        Text(
          '📊 보이는 컬럼: $visibleCount/${allColumns.length}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        if (needsNorm) ...[
          const SizedBox(width: 16),
          Text(
            '⚠️ Order 정규화 필요',
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        if (hiddenColumnIds.isNotEmpty) ...[
          const SizedBox(width: 16),
          Text(
            '🙈 숨겨진: ${hiddenColumnIds.length}개',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red[600],
            ),
          ),
        ],
      ],
    );
  }

  /// 컬럼별 상세 tooltip 생성
  String _buildColumnTooltip(BasicTableColumn column, bool isVisible) {
    return '''컬럼 상세 정보:
ID: ${column.id}
이름: ${column.name}
Order: ${column.order}
최소 너비: ${column.minWidth}px
${column.maxWidth != null ? '최대 너비: ${column.maxWidth}px' : '최대 너비: 제한없음'}
크기 조절: ${column.isResizable ? '가능' : '불가능'}
강제 Tooltip: ${column.forceTooltip ? 'ON' : 'OFF'}
현재 상태: ${isVisible ? '👁️ 보임' : '🙈 숨김'}''';
  }

  /// Order 정규화가 필요한지 확인
  bool _needsNormalization() {
    final sortedColumns = BasicTableColumn.mapToSortedList(allColumns);

    for (int i = 0; i < sortedColumns.length; i++) {
      if (sortedColumns[i].order != i) {
        return true;
      }
    }

    return false;
  }
}
