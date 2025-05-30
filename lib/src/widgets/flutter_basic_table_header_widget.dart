import 'package:flutter/material.dart';

import '../../flutter_basic_table.dart';

/// 테이블 헤더를 렌더링하는 위젯
class BasicTableHeader extends StatelessWidget {
  final List<BasicTableColumn> columns;
  final double totalWidth;
  final double availableWidth;
  final BasicTableConfig config;
  final double checkboxWidth;
  final bool? headerCheckboxState;
  final VoidCallback? onHeaderCheckboxChanged;

  const BasicTableHeader({
    super.key,
    required this.columns,
    required this.totalWidth,
    required this.availableWidth,
    required this.config,
    required this.checkboxWidth,
    this.headerCheckboxState,
    this.onHeaderCheckboxChanged,
  });

  /// 각 컬럼의 실제 렌더링 너비를 계산합니다.
  /// minWidth의 합이 availableWidth보다 작으면 비례적으로 확장합니다.
  List<double> _calculateColumnWidths() {
    // 체크박스를 제외한 사용 가능한 너비
    final double availableForColumns = availableWidth - checkboxWidth;
    final double totalMinWidth =
        columns.fold(0.0, (sum, col) => sum + col.minWidth);

    if (totalMinWidth >= availableForColumns) {
      // 최소 너비의 합이 화면보다 크거나 같으면 minWidth 그대로 사용
      return columns.map((col) => col.minWidth).toList();
    } else {
      // 화면보다 작으면 비례적으로 확장
      final double expansionRatio = availableForColumns / totalMinWidth;
      return columns.map((col) => col.minWidth * expansionRatio).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<double> columnWidths = _calculateColumnWidths();

    return Container(
      width: totalWidth,
      height: config.headerHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Colors.black, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // 체크박스 컬럼
          if (config.showCheckboxColumn)
            _CheckboxHeaderCell(
              width: checkboxWidth,
              config: config,
              checkboxState: headerCheckboxState,
              onChanged: onHeaderCheckboxChanged,
            ),

          // 일반 컬럼들
          ...List.generate(columns.length, (index) {
            final column = columns[index];
            final width = columnWidths[index];

            return _HeaderCell(
              column: column,
              width: width,
              config: config,
            );
          }),
        ],
      ),
    );
  }
}

/// 체크박스 헤더 셀 위젯
class _CheckboxHeaderCell extends StatelessWidget {
  final double width;
  final BasicTableConfig config;
  final bool? checkboxState;
  final VoidCallback? onChanged;

  const _CheckboxHeaderCell({
    required this.width,
    required this.config,
    this.checkboxState,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: config.headerHeight,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onChanged,
          child: Center(
            child: Checkbox(
              value: checkboxState,
              tristate: true,
              onChanged: onChanged != null ? (_) => onChanged!() : null,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
      ),
    );
  }
}

/// 개별 헤더 셀 위젯
class _HeaderCell extends StatelessWidget {
  final BasicTableColumn column;
  final double width;
  final BasicTableConfig config;

  const _HeaderCell({
    required this.column,
    required this.width,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: config.headerHeight,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 2), // 각 헤더 셀 상단에 굵은 구분선
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              config.enableHeaderSorting ? () => _onHeaderTap(context) : null,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    column.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (config.enableHeaderSorting)
                  const Icon(
                    Icons.sort,
                    size: 16,
                    color: Colors.grey,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onHeaderTap(BuildContext context) {
    // TODO: 정렬 기능 구현
    debugPrint('Header tapped: ${column.name}');
  }
}
