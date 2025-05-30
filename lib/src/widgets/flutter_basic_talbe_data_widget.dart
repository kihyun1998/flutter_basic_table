import 'package:flutter/material.dart';

import '../../flutter_basic_table.dart';

/// 테이블 데이터를 렌더링하는 위젯
class BasicTableData extends StatelessWidget {
  final List<BasicTableRow> rows;
  final List<BasicTableColumn> columns;
  final double availableWidth;
  final BasicTableConfig config;
  final ScrollController verticalController;
  final double checkboxWidth;
  final Set<int> selectedRows;
  final void Function(int index, bool selected)? onRowSelectionChanged;

  const BasicTableData({
    super.key,
    required this.rows,
    required this.columns,
    required this.availableWidth,
    required this.config,
    required this.verticalController,
    required this.checkboxWidth,
    required this.selectedRows,
    this.onRowSelectionChanged,
  });

  /// 각 컬럼의 실제 렌더링 너비를 계산합니다.
  /// 헤더와 동일한 로직을 사용합니다.
  List<double> _calculateColumnWidths() {
    // 체크박스를 제외한 사용 가능한 너비
    final double availableForColumns = availableWidth - checkboxWidth;
    final double totalMinWidth =
        columns.fold(0.0, (sum, col) => sum + col.minWidth);

    if (totalMinWidth >= availableForColumns) {
      return columns.map((col) => col.minWidth).toList();
    } else {
      final double expansionRatio = availableForColumns / totalMinWidth;
      return columns.map((col) => col.minWidth * expansionRatio).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<double> columnWidths = _calculateColumnWidths();

    return ListView.builder(
      controller: verticalController,
      itemCount: rows.length,
      itemBuilder: (context, index) {
        final row = rows[index];
        final isSelected = selectedRows.contains(row.index);

        return _DataRow(
          row: row,
          columnWidths: columnWidths,
          config: config,
          checkboxWidth: checkboxWidth,
          isSelected: isSelected,
          onSelectionChanged: onRowSelectionChanged,
        );
      },
    );
  }
}

/// 개별 데이터 행 위젯
class _DataRow extends StatelessWidget {
  final BasicTableRow row;
  final List<double> columnWidths;
  final BasicTableConfig config;
  final double checkboxWidth;
  final bool isSelected;
  final void Function(int index, bool selected)? onSelectionChanged;

  const _DataRow({
    required this.row,
    required this.columnWidths,
    required this.config,
    required this.checkboxWidth,
    required this.isSelected,
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    // 선택 상태에 따른 배경색 변경
    final Color backgroundColor = isSelected
        ? Colors.blue.withOpacity(0.1) // 선택된 행은 연한 파란색
        : Colors.white;

    return Container(
      height: config.rowHeight,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: const Border(
          top: BorderSide(color: Colors.grey, width: 0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // 행 전체가 클릭 가능!
          onTap: config.showCheckboxColumn && onSelectionChanged != null
              ? () => onSelectionChanged!(row.index, !isSelected)
              : null,
          child: Row(
            children: [
              // 체크박스 셀
              if (config.showCheckboxColumn)
                _CheckboxCell(
                  width: checkboxWidth,
                  config: config,
                  isSelected: isSelected,
                  onChanged: (selected) {
                    onSelectionChanged?.call(row.index, selected);
                  },
                ),

              // 데이터 셀들
              ...List.generate(row.cells.length, (cellIndex) {
                final cellData =
                    cellIndex < row.cells.length ? row.cells[cellIndex] : '';
                final cellWidth = cellIndex < columnWidths.length
                    ? columnWidths[cellIndex]
                    : 100.0;

                return _DataCell(
                  data: cellData,
                  width: cellWidth,
                  config: config,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/// 체크박스 셀 위젯
class _CheckboxCell extends StatelessWidget {
  final double width;
  final BasicTableConfig config;
  final bool isSelected;
  final void Function(bool selected)? onChanged;

  const _CheckboxCell({
    required this.width,
    required this.config,
    required this.isSelected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: config.rowHeight,
      child: Center(
        child: Checkbox(
          value: isSelected,
          onChanged: null, // 체크박스 직접 클릭 비활성화 - 행 클릭으로만 동작
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

/// 개별 데이터 셀 위젯
class _DataCell extends StatelessWidget {
  final String data;
  final double width;
  final BasicTableConfig config;

  const _DataCell({
    required this.data,
    required this.width,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: config.rowHeight,
      // 세로 구분선 제거 - decoration 완전히 제거
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            data,
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
