// lib/src/widgets/flutter_basic_talbe_data_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/src/enum/tooltip_position.dart';
import 'package:flutter_basic_table/src/widgets/tooltip_able_text_widget.dart';

import '../../flutter_basic_table.dart';

/// 테이블 데이터를 렌더링하는 위젯
class BasicTableData extends StatelessWidget {
  final List<BasicTableRow> rows;
  final List<BasicTableColumn> columns;
  final double availableWidth;
  final BasicTableThemeData theme;
  final ScrollController verticalController;
  final double checkboxWidth;
  final Set<int> selectedRows;
  final void Function(int index, bool selected)? onRowSelectionChanged;
  final void Function(int index)? onRowTap;
  final void Function(int index)? onRowDoubleTap;
  final void Function(int index)? onRowSecondaryTap;
  final Duration doubleClickTime;

  const BasicTableData({
    super.key,
    required this.rows,
    required this.columns,
    required this.availableWidth,
    required this.theme,
    required this.verticalController,
    required this.checkboxWidth,
    required this.selectedRows,
    this.onRowSelectionChanged,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowSecondaryTap,
    this.doubleClickTime = const Duration(milliseconds: 300),
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
          theme: theme,
          checkboxWidth: checkboxWidth,
          isSelected: isSelected,
          onSelectionChanged: onRowSelectionChanged,
          onRowTap: onRowTap,
          onRowDoubleTap: onRowDoubleTap,
          onRowSecondaryTap: onRowSecondaryTap,
          doubleClickTime: doubleClickTime,
        );
      },
    );
  }
}

/// 개별 데이터 행 위젯 - ✅ hover 효과 & dataRowTheme.border 적용!
class _DataRow extends StatefulWidget {
  final BasicTableRow row;
  final List<double> columnWidths;
  final BasicTableThemeData theme;
  final double checkboxWidth;
  final bool isSelected;
  final void Function(int index, bool selected)? onSelectionChanged;
  final void Function(int index)? onRowTap;
  final void Function(int index)? onRowDoubleTap;
  final void Function(int index)? onRowSecondaryTap;
  final Duration doubleClickTime;

  const _DataRow({
    required this.row,
    required this.columnWidths,
    required this.theme,
    required this.checkboxWidth,
    required this.isSelected,
    this.onSelectionChanged,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowSecondaryTap,
    this.doubleClickTime = const Duration(milliseconds: 300),
  });

  @override
  State<_DataRow> createState() => _DataRowState();
}

class _DataRowState extends State<_DataRow> {
  bool _isHovered = false; // ✅ hover 상태 추가!

  @override
  Widget build(BuildContext context) {
    // ✅ 우선순위: 선택됨 > hover > 기본
    Color backgroundColor;
    if (widget.isSelected) {
      backgroundColor = widget.theme.selectionTheme.selectedRowColor ??
          Colors.blue.withOpacity(0.1);
    } else if (_isHovered) {
      backgroundColor = widget.theme.selectionTheme.hoverRowColor ??
          Colors.grey.withOpacity(0.05); // ✅ hover 색상 적용!
    } else {
      backgroundColor =
          widget.theme.dataRowTheme.backgroundColor ?? Colors.white;
    }

    return MouseRegion(
      // ✅ hover 효과 구현!
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        height: widget.theme.dataRowTheme.height,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            top: widget.theme.dataRowTheme.border ??
                BorderSide.none, // ✅ dataRowTheme.border 사용!
          ),
        ),
        child: CustomInkWell(
          onTap: () {
            // 체크박스가 있으면 선택/해제, 없으면 일반 행 클릭
            if (widget.theme.checkboxTheme.enabled &&
                widget.onSelectionChanged != null) {
              widget.onSelectionChanged!(widget.row.index, !widget.isSelected);
            }
            widget.onRowTap?.call(widget.row.index);
          },
          onDoubleTap: widget.onRowDoubleTap != null
              ? () => widget.onRowDoubleTap!(widget.row.index)
              : null,
          onSecondaryTap: widget.onRowSecondaryTap != null
              ? () => widget.onRowSecondaryTap!(widget.row.index)
              : null,
          doubleClickTime: widget.doubleClickTime,
          // ✅ 클릭 효과 색상 커스터마이징!
          splashColor: widget.theme.dataRowTheme.splashColor,
          highlightColor: widget.theme.dataRowTheme.highlightColor,
          child: Row(
            children: [
              // 체크박스 셀
              if (widget.theme.checkboxTheme.enabled)
                _CheckboxCell(
                  width: widget.checkboxWidth,
                  theme: widget.theme,
                  isSelected: widget.isSelected,
                  onChanged: (selected) {
                    widget.onSelectionChanged?.call(widget.row.index, selected);
                  },
                ),

              // 데이터 셀들
              ...List.generate(widget.row.cells.length, (cellIndex) {
                final cellData = cellIndex < widget.row.cells.length
                    ? widget.row.cells[cellIndex]
                    : '';
                final cellWidth = cellIndex < widget.columnWidths.length
                    ? widget.columnWidths[cellIndex]
                    : 100.0;

                return _DataCell(
                  data: cellData,
                  width: cellWidth,
                  theme: widget.theme,
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
  final BasicTableThemeData theme;
  final bool isSelected;
  final void Function(bool selected)? onChanged;

  const _CheckboxCell({
    required this.width,
    required this.theme,
    required this.isSelected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 체크박스 영역에서 이벤트 전파 차단
      onTap: () {
        // 체크박스 클릭 시 부모의 CustomInkWell 이벤트 차단
        onChanged?.call(!isSelected);
      },
      child: Container(
        width: width,
        height: theme.dataRowTheme.height,
        color: Colors.transparent, // 클릭 영역 확보
        child: Padding(
          padding: theme.checkboxTheme.padding ?? EdgeInsets.zero,
          child: Center(
            child: Checkbox(
              value: isSelected,
              onChanged: onChanged != null
                  ? (value) => onChanged!(value ?? false)
                  : null,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: theme.checkboxTheme.activeColor,
              checkColor: theme.checkboxTheme.checkColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// 개별 데이터 셀 위젯 - ✅ cellBorder 구현 예정
class _DataCell extends StatelessWidget {
  final String data;
  final double width;
  final BasicTableThemeData theme;

  const _DataCell({
    required this.data,
    required this.width,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ SizedBox → Container로 변경 (cellBorder 준비)
      width: width,
      height: theme.dataRowTheme.height,
      // ✅ cellBorder 구현 준비
      decoration: BoxDecoration(
        border: Border(
          right: theme.borderTheme.cellBorder ??
              BorderSide.none, // ✅ cellBorder 적용!
        ),
      ),
      child: Padding(
        padding: theme.dataRowTheme.padding ?? EdgeInsets.zero,
        child: Align(
          alignment: Alignment.centerLeft,
          child: OverflowableText(
            text: data,
            style: theme.dataRowTheme.textStyle,
            tooltipTheme: theme.tooltipTheme,
            tooltipPosition: TooltipPosition.top, // 데이터는 위쪽에 tooltip
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
