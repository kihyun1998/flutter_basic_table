import 'package:flutter/material.dart';

import '../../flutter_basic_table.dart';

/// 테이블 데이터를 렌더링하는 위젯
class BasicTableData extends StatelessWidget {
  final List<BasicTableRow> rows;
  final List<BasicTableColumn> columns;
  final double availableWidth;
  final BasicTableConfig config;
  final ScrollController verticalController;

  const BasicTableData({
    super.key,
    required this.rows,
    required this.columns,
    required this.availableWidth,
    required this.config,
    required this.verticalController,
  });

  /// 각 컬럼의 실제 렌더링 너비를 계산합니다.
  /// 헤더와 동일한 로직을 사용합니다.
  List<double> _calculateColumnWidths() {
    final double totalMinWidth =
        columns.fold(0.0, (sum, col) => sum + col.minWidth);

    if (totalMinWidth >= availableWidth) {
      return columns.map((col) => col.minWidth).toList();
    } else {
      final double expansionRatio = availableWidth / totalMinWidth;
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
        return _DataRow(
          row: row,
          columnWidths: columnWidths,
          config: config,
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

  const _DataRow({
    required this.row,
    required this.columnWidths,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        row.index % 2 == 0 ? Colors.white : Colors.grey[50]!;

    return Container(
      height: config.rowHeight,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: const Border(
          bottom: BorderSide(color: Colors.grey, width: 0.3),
        ),
      ),
      child: Row(
        children: List.generate(row.cells.length, (cellIndex) {
          final cellData =
              cellIndex < row.cells.length ? row.cells[cellIndex] : '';
          final cellWidth =
              cellIndex < columnWidths.length ? columnWidths[cellIndex] : 100.0;

          return _DataCell(
            data: cellData,
            width: cellWidth,
            config: config,
          );
        }),
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
    return Container(
      width: width,
      height: config.rowHeight,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey, width: 0.3),
        ),
      ),
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
