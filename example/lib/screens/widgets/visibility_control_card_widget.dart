import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

/// 컬럼 visibility 제어를 위한 카드 위젯
class VisibilityControlCardWidget extends StatelessWidget {
  final List<BasicTableColumn> allColumns;
  final Set<String> hiddenColumnIds;
  final void Function(String columnId) onToggleVisibility;
  final VoidCallback onShowAllColumns;
  final VoidCallback onShowVisibilityInfo;

  const VisibilityControlCardWidget({
    super.key,
    required this.allColumns,
    required this.hiddenColumnIds,
    required this.onToggleVisibility,
    required this.onShowAllColumns,
    required this.onShowVisibilityInfo,
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

            // 컬럼 토글 칩들
            _buildColumnChips(),
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
        const Text(
          '👁️ 컬럼 표시 설정',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Row(
          children: [
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

  /// 컬럼 토글 칩들 빌드
  Widget _buildColumnChips() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: allColumns.map((column) {
        final isVisible = !hiddenColumnIds.contains(column.effectiveId);

        return FilterChip(
          label: Text(column.name),
          selected: isVisible,
          onSelected: (_) => onToggleVisibility(column.effectiveId),
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
        );
      }).toList(),
    );
  }
}
