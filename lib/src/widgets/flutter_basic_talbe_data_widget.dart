// lib/src/widgets/flutter_basic_talbe_data_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/src/widgets/custom_tooltip.dart';
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

  /// 전체 테이블 데이터의 높이를 계산합니다 (개별 행 높이 고려)
  double calculateTotalDataHeight() {
    return rows.fold(0.0, (total, row) {
      return total + row.getEffectiveHeight(theme.dataRowTheme.height);
    });
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
          columns: columns,
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

/// 개별 데이터 행 위젯
class _DataRow extends StatefulWidget {
  final BasicTableRow row;
  final List<double> columnWidths;
  final BasicTableThemeData theme;
  final double checkboxWidth;
  final bool isSelected;
  final List<BasicTableColumn> columns;
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
    required this.columns,
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
  bool _isHovered = false;

  /// 현재 행의 실제 높이를 계산합니다
  double get _effectiveRowHeight {
    return widget.row.getEffectiveHeight(widget.theme.dataRowTheme.height);
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (widget.isSelected) {
      backgroundColor = widget.theme.selectionTheme.selectedRowColor ??
          Colors.blue.withOpacity(0.1);
    } else if (_isHovered) {
      backgroundColor = widget.theme.selectionTheme.hoverRowColor ??
          Colors.grey.withOpacity(0.05);
    } else {
      backgroundColor =
          widget.theme.dataRowTheme.backgroundColor ?? Colors.white;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        height: _effectiveRowHeight, // 개별 행 높이 적용
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            top: widget.theme.dataRowTheme.border ?? BorderSide.none,
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
          splashColor: widget.theme.dataRowTheme.splashColor,
          highlightColor: widget.theme.dataRowTheme.highlightColor,
          child: Row(
            children: [
              // 체크박스 셀
              if (widget.theme.checkboxTheme.enabled)
                _CheckboxCell(
                  width: widget.checkboxWidth,
                  height: _effectiveRowHeight, // 행 높이 전달
                  theme: widget.theme,
                  isSelected: widget.isSelected,
                  onChanged: (selected) {
                    widget.onSelectionChanged?.call(widget.row.index, selected);
                  },
                ),

              // 데이터 셀들
              ...List.generate(widget.row.cells.length, (cellIndex) {
                final cell = cellIndex < widget.row.cells.length
                    ? widget.row.cells[cellIndex]
                    : BasicTableCell.text('');
                final cellWidth = cellIndex < widget.columnWidths.length
                    ? widget.columnWidths[cellIndex]
                    : 100.0;
                final column = cellIndex < widget.columns.length
                    ? widget.columns[cellIndex]
                    : null;

                return _DataCell(
                  cell: cell,
                  width: cellWidth,
                  height: _effectiveRowHeight, // 행 높이 전달
                  theme: widget.theme,
                  column: column,
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
  final double height; // 행 높이 추가
  final BasicTableThemeData theme;
  final bool isSelected;
  final void Function(bool selected)? onChanged;

  const _CheckboxCell({
    required this.width,
    required this.height,
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
        height: height, // 개별 행 높이 적용
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

/// 개별 데이터 셀 위젯
class _DataCell extends StatelessWidget {
  final BasicTableCell cell;
  final double width;
  final double height; // 행 높이 추가
  final BasicTableThemeData theme;
  final BasicTableColumn? column;

  const _DataCell({
    required this.cell,
    required this.width,
    required this.height,
    required this.theme,
    this.column,
  });

  /// 테마 스타일과 셀 개별 스타일을 병합 (셀 스타일이 우선)
  TextStyle _getEffectiveTextStyle() {
    final themeStyle = theme.dataRowTheme.textStyle;
    final cellStyle = cell.style;

    if (cellStyle == null) return themeStyle ?? const TextStyle();
    if (themeStyle == null) return cellStyle;

    // 테마 스타일을 기본으로 하고 셀 스타일로 오버라이드
    return themeStyle.merge(cellStyle);
  }

  /// 테마 배경색과 셀 개별 배경색을 병합 (셀 배경색이 우선)
  Color _getEffectiveBackgroundColor() {
    return cell.backgroundColor ?? Colors.transparent;
  }

  /// 테마 패딩과 셀 개별 패딩을 병합 (셀 패딩이 우선)
  EdgeInsets _getEffectivePadding() {
    return cell.padding ?? theme.dataRowTheme.padding ?? EdgeInsets.zero;
  }

  /// 셀 정렬 (기본값: centerLeft)
  Alignment _getEffectiveAlignment() {
    return cell.alignment ?? Alignment.centerLeft;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height, // 개별 행 높이 적용
      decoration: BoxDecoration(
        color: _getEffectiveBackgroundColor(),
        border: Border(
          right: theme.borderTheme.cellBorder ?? BorderSide.none,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: _buildCellContent(),
      ),
    );
  }

  /// 셀 콘텐츠를 빌드 (위젯 vs 텍스트 vs 클릭 가능)
  Widget _buildCellContent() {
    Widget content;

    if (cell.usesWidget) {
      // 커스텀 위젯 사용
      content = Padding(
        padding: _getEffectivePadding(),
        child: Align(
          alignment: _getEffectiveAlignment(),
          child: cell.widget!,
        ),
      );
    } else {
      // 텍스트 사용
      content = Padding(
        padding: _getEffectivePadding(),
        child: Align(
          alignment: _getEffectiveAlignment(),
          child: _buildTextContent(),
        ),
      );
    }

    // 셀 레벨 이벤트가 있으면 클릭 가능하게 래핑
    if (cell.enabled && _hasCellEvents()) {
      return CustomInkWell(
        onTap: cell.onTap,
        onDoubleTap: cell.onDoubleTap,
        onSecondaryTap: cell.onSecondaryTap,
        doubleClickTime: const Duration(milliseconds: 300),
        child: content,
      );
    }

    return content;
  }

  /// 텍스트 콘텐츠를 빌드 (tooltip 처리 포함)
  Widget _buildTextContent() {
    final displayText = cell.displayText ?? '';

    if (cell.tooltip != null) {
      // 강제 tooltip이 지정된 경우 (셀 레벨이 우선)
      return CustomTooltip(
        message: cell.tooltip!,
        theme: theme.tooltipTheme,
        position: TooltipPosition.top,
        child: Text(
          displayText,
          style: _getEffectiveTextStyle(),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      );
    } else {
      return TooltipAbleText(
        text: displayText,
        style: _getEffectiveTextStyle(),
        tooltipTheme: theme.tooltipTheme,
        tooltipPosition: TooltipPosition.top,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        tooltipFormatter: column?.tooltipFormatter,
        forceTooltip: column?.forceTooltip ?? false,
      );
    }
  }

  /// 셀 레벨 이벤트가 있는지 확인
  bool _hasCellEvents() {
    return cell.onTap != null ||
        cell.onDoubleTap != null ||
        cell.onSecondaryTap != null;
  }
}
