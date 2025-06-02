// lib/src/widgets/flutter_basic_table_header_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/src/widgets/tooltip_able_text_widget.dart';

import '../../flutter_basic_table.dart';

/// 테이블 헤더를 렌더링하는 위젯
class BasicTableHeader extends StatelessWidget {
  final List<BasicTableColumn> columns;
  final double totalWidth;
  final double availableWidth;
  final BasicTableThemeData theme;
  final double checkboxWidth;
  final bool? headerCheckboxState;
  final VoidCallback? onHeaderCheckboxChanged;
  final void Function(int oldIndex, int newIndex)? onColumnReorder;
  final void Function(int columnIndex, ColumnSortState sortState)? onColumnSort;
  final Map<int, ColumnSortState>? columnSortStates;

  const BasicTableHeader({
    super.key,
    required this.columns,
    required this.totalWidth,
    required this.availableWidth,
    required this.theme,
    required this.checkboxWidth,
    this.headerCheckboxState,
    this.onHeaderCheckboxChanged,
    this.onColumnReorder,
    this.onColumnSort,
    this.columnSortStates,
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
      height: theme.headerTheme.height,
      decoration: BoxDecoration(
        color: theme.headerTheme.backgroundColor,
        border: Border(
          top: theme.headerTheme.border ?? BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          // 체크박스 컬럼 (reorder 대상에서 제외)
          if (theme.checkboxTheme.enabled)
            _CheckboxHeaderCell(
              width: checkboxWidth,
              theme: theme,
              checkboxState: headerCheckboxState,
              onChanged: onHeaderCheckboxChanged,
            ),

          // Reorderable 헤더 컬럼들
          Expanded(
            child: theme.headerTheme.enableReorder && onColumnReorder != null
                ? _ReorderableHeaderRow(
                    columns: columns,
                    columnWidths: columnWidths,
                    theme: theme,
                    onReorder: onColumnReorder!,
                    onColumnSort: onColumnSort,
                    columnSortStates: columnSortStates,
                  )
                : _StaticHeaderRow(
                    columns: columns,
                    columnWidths: columnWidths,
                    theme: theme,
                    onColumnSort: onColumnSort,
                    columnSortStates: columnSortStates,
                  ),
          ),
        ],
      ),
    );
  }
}

/// Reorderable 헤더 행 위젯
class _ReorderableHeaderRow extends StatelessWidget {
  final List<BasicTableColumn> columns;
  final List<double> columnWidths;
  final BasicTableThemeData theme;
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(int columnIndex, ColumnSortState sortState)? onColumnSort;
  final Map<int, ColumnSortState>? columnSortStates;

  const _ReorderableHeaderRow({
    required this.columns,
    required this.columnWidths,
    required this.theme,
    required this.onReorder,
    this.onColumnSort,
    this.columnSortStates,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      scrollDirection: Axis.horizontal,
      buildDefaultDragHandles: false, // 기본 드래그 핸들 비활성화
      onReorder: onReorder,
      children: List.generate(columns.length, (index) {
        final column = columns[index];
        final width = columnWidths[index];
        final sortState = columnSortStates?[index] ?? ColumnSortState.none;

        return ReorderableDragStartListener(
          key: ValueKey('header_$index'), // 각 아이템에 고유 key 필요
          index: index,
          child: _HeaderCell(
            column: column,
            width: width,
            theme: theme,
            columnIndex: index,
            sortState: sortState,
            onSort: onColumnSort,
            showDragHandle: theme.headerTheme.showDragHandles,
          ),
        );
      }),
    );
  }
}

/// 정적 헤더 행 위젯 (reorder 비활성화)
class _StaticHeaderRow extends StatelessWidget {
  final List<BasicTableColumn> columns;
  final List<double> columnWidths;
  final BasicTableThemeData theme;
  final void Function(int columnIndex, ColumnSortState sortState)? onColumnSort;
  final Map<int, ColumnSortState>? columnSortStates;

  const _StaticHeaderRow({
    required this.columns,
    required this.columnWidths,
    required this.theme,
    this.onColumnSort,
    this.columnSortStates,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(columns.length, (index) {
        final column = columns[index];
        final width = columnWidths[index];
        final sortState = columnSortStates?[index] ?? ColumnSortState.none;

        return _HeaderCell(
          column: column,
          width: width,
          theme: theme,
          columnIndex: index,
          sortState: sortState,
          onSort: onColumnSort,
          showDragHandle: false,
        );
      }),
    );
  }
}

/// 체크박스 헤더 셀 위젯
class _CheckboxHeaderCell extends StatelessWidget {
  final double width;
  final BasicTableThemeData theme;
  final bool? checkboxState;
  final VoidCallback? onChanged;

  const _CheckboxHeaderCell({
    required this.width,
    required this.theme,
    this.checkboxState,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: theme.headerTheme.height,
      decoration: BoxDecoration(
        border: Border(
          right: theme.borderTheme.cellBorder ?? BorderSide.none,
        ),
      ),
      child: Padding(
        padding: theme.checkboxTheme.padding ?? EdgeInsets.zero,
        child: Center(
          child: Checkbox(
            value: checkboxState,
            tristate: true,
            onChanged: onChanged != null ? (_) => onChanged!() : null,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: theme.checkboxTheme.activeColor,
            checkColor: theme.checkboxTheme.checkColor,
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
  final BasicTableThemeData theme;
  final int columnIndex;
  final ColumnSortState sortState;
  final void Function(int columnIndex, ColumnSortState sortState)? onSort;
  final bool showDragHandle;

  const _HeaderCell({
    required this.column,
    required this.width,
    required this.theme,
    required this.columnIndex,
    this.sortState = ColumnSortState.none,
    this.onSort,
    this.showDragHandle = false,
  });

  /// 다음 정렬 상태를 계산합니다 (none → asc → desc → none)
  ColumnSortState _getNextSortState() {
    switch (sortState) {
      case ColumnSortState.none:
        return ColumnSortState.ascending;
      case ColumnSortState.ascending:
        return ColumnSortState.descending;
      case ColumnSortState.descending:
        return ColumnSortState.none;
    }
  }

  /// 정렬 상태에 따른 아이콘을 반환합니다
  Widget? _getSortIcon() {
    if (!theme.headerTheme.enableSorting) return null;

    switch (sortState) {
      case ColumnSortState.none:
        return null; // 아이콘 없음
      case ColumnSortState.ascending:
        return Icon(
          theme.headerTheme.ascendingIcon ?? Icons.keyboard_arrow_up,
          size: theme.headerTheme.sortIconSize ?? 18.0,
          color: theme.headerTheme.sortIconColor,
        );
      case ColumnSortState.descending:
        return Icon(
          theme.headerTheme.descendingIcon ?? Icons.keyboard_arrow_down,
          size: theme.headerTheme.sortIconSize ?? 18.0,
          color: theme.headerTheme.sortIconColor,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: theme.headerTheme.height,
      decoration: BoxDecoration(
        border: Border(
          right: theme.borderTheme.cellBorder ?? BorderSide.none,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onHeaderTap(),
          splashColor: theme.headerTheme.splashColor,
          highlightColor: theme.headerTheme.highlightColor,
          child: Padding(
            padding: theme.headerTheme.padding ?? EdgeInsets.zero,
            child: Row(
              children: [
                // 드래그 핸들 (reorder 활성화시에만 표시)
                if (showDragHandle && theme.headerTheme.enableReorder)
                  Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.drag_handle,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ),

                /// 컬럼 이름
                Expanded(
                  child: TooltipAbleText(
                    text: column.name,
                    style: theme.headerTheme.textStyle,
                    tooltipTheme: theme.tooltipTheme,
                    tooltipPosition: TooltipPosition.bottom,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // 정렬 아이콘 (정렬 활성화시에만 표시)
                if (_getSortIcon() != null) _getSortIcon()!,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onHeaderTap() {
    if (theme.headerTheme.enableSorting && onSort != null) {
      final nextState = _getNextSortState();
      onSort!(columnIndex, nextState);
      debugPrint(
          'Header tapped: ${column.name}, sort: $sortState -> $nextState');
    }
  }
}
