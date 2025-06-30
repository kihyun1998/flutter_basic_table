// lib/src/selectable/widgets/selectable_table.dart
import 'package:flutter/material.dart';

import '../../shared/enums/column_sort_state.dart';
import '../../shared/utils/width_calculator.dart';
import '../../shared/widgets/custom_inkwell.dart';
import '../models/selectable_cell.dart';
import '../models/selectable_column.dart';
import '../models/selectable_row.dart';
import '../theme/selectable_border_theme.dart';
import '../theme/selectable_header_theme.dart';
import '../theme/selectable_row_theme.dart';
import '../theme/selectable_table_theme.dart';
import '../utils/selection_manger.dart';
import '../utils/sort_manger.dart';

/// 선택 기능이 있는 테이블 위젯
///
/// 데이터 조회 및 행 선택에 특화된 테이블입니다.
class SelectableTable extends StatefulWidget {
  /// 컬럼 정의 리스트
  final List<SelectableColumn> columns;

  /// 행 데이터 리스트
  final List<SelectableRow> rows;

  /// 선택된 행들 (행 인덱스 기준)
  final Set<int>? selectedRows;

  /// 행 선택 변경 콜백
  final void Function(int index, bool selected)? onRowSelectionChanged;

  /// 전체 선택/해제 콜백
  final void Function(bool selectAll)? onSelectAllChanged;

  /// 행 클릭 콜백
  final void Function(int index)? onRowTap;

  /// 행 더블클릭 콜백
  final void Function(int index)? onRowDoubleTap;

  /// 행 우클릭 콜백
  final void Function(int index)? onRowSecondaryTap;

  /// 컬럼 정렬 콜백
  final void Function(String columnId, ColumnSortState sortState)? onColumnSort;

  /// 컬럼 순서 변경 콜백
  final void Function(String columnId, int newOrder)? onColumnReorder;

  /// 테마
  final SelectableTableTheme? theme;

  /// 체크박스 컬럼 표시 여부
  final bool showCheckboxColumn;

  /// 다중 선택 활성화 여부
  final bool enableMultiSelection;

  /// 컬럼 정렬 활성화 여부
  final bool enableColumnSort;

  /// 컬럼 리오더링 활성화 여부
  final bool enableColumnReorder;

  /// 더블클릭 인식 시간
  final Duration doubleClickTime;

  const SelectableTable({
    super.key,
    required this.columns,
    required this.rows,
    this.selectedRows,
    this.onRowSelectionChanged,
    this.onSelectAllChanged,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowSecondaryTap,
    this.onColumnSort,
    this.onColumnReorder,
    this.theme,
    this.showCheckboxColumn = true,
    this.enableMultiSelection = true,
    this.enableColumnSort = true,
    this.enableColumnReorder = true,
    this.doubleClickTime = const Duration(milliseconds: 300),
  });

  @override
  State<SelectableTable> createState() => _SelectableTableState();
}

class _SelectableTableState extends State<SelectableTable> {
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  /// 선택 관리자
  late SelectionManager _selectionManager;

  /// 정렬 관리자
  late SelectableSortManager _sortManager;

  /// 현재 테마
  SelectableTableTheme get _currentTheme =>
      widget.theme ?? SelectableTableTheme.defaultTheme();

  /// 체크박스 컬럼 너비
  double get _checkboxWidth => widget.showCheckboxColumn
      ? _currentTheme.rowTheme.checkboxTheme.columnWidth
      : 0.0;

  @override
  void initState() {
    super.initState();
    _initializeManagers();
  }

  @override
  void didUpdateWidget(SelectableTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 행 데이터가 변경되면 관리자들 업데이트
    if (widget.rows != oldWidget.rows) {
      _selectionManager.updateTotalRowCount(widget.rows.length);
    }

    // 다중 선택 설정 변경
    if (widget.enableMultiSelection != oldWidget.enableMultiSelection) {
      _selectionManager.setMultiSelectionEnabled(widget.enableMultiSelection);
    }

    // 외부에서 선택 상태가 변경되면 동기화
    if (widget.selectedRows != oldWidget.selectedRows) {
      _syncSelectionFromWidget();
    }
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  /// 관리자들 초기화
  void _initializeManagers() {
    _selectionManager = SelectionManager(
      multiSelectionEnabled: widget.enableMultiSelection,
      totalRowCount: widget.rows.length,
    );

    _sortManager = SelectableSortManager();

    // 외부 선택 상태와 동기화
    _syncSelectionFromWidget();
  }

  /// 외부 선택 상태와 동기화
  void _syncSelectionFromWidget() {
    if (widget.selectedRows != null) {
      _selectionManager.setSelection(widget.selectedRows!);
    }
  }

  /// 헤더 체크박스 상태 계산
  bool? get _headerCheckboxState => _selectionManager.getHeaderCheckboxState();

  /// 전체 선택/해제 처리
  void _handleSelectAll() {
    _selectionManager.handleHeaderCheckboxToggle();
    widget.onSelectAllChanged?.call(_selectionManager.isAllSelected);
  }

  /// 행 선택/해제 처리
  void _handleRowSelection(int index, bool selected) {
    _selectionManager.toggleRowSelection(index);
    widget.onRowSelectionChanged?.call(index, selected);
  }

  /// 행 클릭 처리
  void _handleRowTap(int index) {
    if (widget.showCheckboxColumn && widget.onRowSelectionChanged != null) {
      final isSelected = _selectionManager.isRowSelected(index);
      _handleRowSelection(index, !isSelected);
    }
    widget.onRowTap?.call(index);
  }

  /// 컬럼 정렬 처리
  void _handleColumnSort(String columnId) {
    if (!widget.enableColumnSort) return;

    final newState = _sortManager.toggleColumnSort(columnId);
    widget.onColumnSort?.call(columnId, newState);
  }

  /// 컬럼 순서 변경 처리
  void _handleColumnReorder(String columnId, int newOrder) {
    if (!widget.enableColumnReorder) return;

    widget.onColumnReorder?.call(columnId, newOrder);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        // 컬럼 너비 계산
        final minWidths = widget.columns.map((col) => col.minWidth).toList();
        final columnWidths = WidthCalculator.calculateColumnWidths(
          minWidths: minWidths,
          availableWidth: availableWidth,
          checkboxWidth: _checkboxWidth,
        );

        return Column(
          children: [
            // 헤더
            _buildHeader(columnWidths),

            // 데이터 행들
            Expanded(
              child: _buildDataRows(columnWidths),
            ),
          ],
        );
      },
    );
  }

  /// 헤더 빌드
  Widget _buildHeader(List<double> columnWidths) {
    final theme = _currentTheme.headerTheme;

    return Container(
      height: theme.height,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        border: Border(bottom: theme.border ?? BorderSide.none),
      ),
      child: SingleChildScrollView(
        controller: _horizontalController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // 체크박스 헤더
            if (widget.showCheckboxColumn) _buildHeaderCheckbox(theme),

            // 컬럼 헤더들
            ...List.generate(widget.columns.length, (index) {
              final column = widget.columns[index];
              return _buildHeaderCell(column, columnWidths[index], theme);
            }),
          ],
        ),
      ),
    );
  }

  /// 체크박스 헤더 빌드
  Widget _buildHeaderCheckbox(SelectableHeaderTheme theme) {
    return Container(
      width: _checkboxWidth,
      height: theme.height,
      decoration: BoxDecoration(
        border: Border(
            right: _currentTheme.borderTheme.cellBorder ?? BorderSide.none),
      ),
      child: Center(
        child: Checkbox(
          value: _headerCheckboxState,
          tristate: true,
          onChanged: widget.onSelectAllChanged != null
              ? (_) => _handleSelectAll()
              : null,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: _currentTheme.rowTheme.checkboxTheme.activeColor,
          checkColor: _currentTheme.rowTheme.checkboxTheme.checkColor,
        ),
      ),
    );
  }

  /// 헤더 셀 빌드
  Widget _buildHeaderCell(
      SelectableColumn column, double width, SelectableHeaderTheme theme) {
    final sortState = _sortManager.getSortState(column.id);
    final canSort =
        widget.enableColumnSort && theme.enableSorting && column.isSortable;

    return Container(
      width: width,
      height: theme.height,
      decoration: BoxDecoration(
        border: Border(
            right: _currentTheme.borderTheme.cellBorder ?? BorderSide.none),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canSort ? () => _handleColumnSort(column.id) : null,
          splashColor: theme.splashColor,
          highlightColor: theme.highlightColor,
          child: Padding(
            padding: theme.padding ?? EdgeInsets.zero,
            child: Row(
              children: [
                // 드래그 핸들
                if (widget.enableColumnReorder &&
                    theme.showDragHandles &&
                    theme.enableReordering)
                  Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.drag_handle,
                        size: 16, color: Colors.grey[600]),
                  ),

                // 컬럼 이름
                Expanded(
                  child: Text(
                    column.name,
                    style: theme.textStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // 정렬 아이콘
                if (canSort && sortState != ColumnSortState.none)
                  Icon(
                    sortState == ColumnSortState.ascending
                        ? (theme.ascendingIcon ?? Icons.keyboard_arrow_up)
                        : (theme.descendingIcon ?? Icons.keyboard_arrow_down),
                    size: theme.sortIconSize ?? 18.0,
                    color: theme.sortIconColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 데이터 행들 빌드
  Widget _buildDataRows(List<double> columnWidths) {
    return ListView.builder(
      controller: _verticalController,
      itemCount: widget.rows.length,
      itemBuilder: (context, index) {
        final row = widget.rows[index];
        final isSelected = _selectionManager.isRowSelected(row.index);

        return _buildDataRow(row, columnWidths, isSelected);
      },
    );
  }

  /// 개별 데이터 행 빌드
  Widget _buildDataRow(
      SelectableRow row, List<double> columnWidths, bool isSelected) {
    return _DataRowWidget(
      row: row,
      columns: widget.columns,
      columnWidths: columnWidths,
      theme: _currentTheme.rowTheme,
      borderTheme: _currentTheme.borderTheme,
      checkboxWidth: _checkboxWidth,
      isSelected: isSelected,
      showCheckbox: widget.showCheckboxColumn,
      onTap: () => _handleRowTap(row.index),
      onDoubleTap: widget.onRowDoubleTap != null
          ? () => widget.onRowDoubleTap!(row.index)
          : null,
      onSecondaryTap: widget.onRowSecondaryTap != null
          ? () => widget.onRowSecondaryTap!(row.index)
          : null,
      onCheckboxChanged: (selected) => _handleRowSelection(row.index, selected),
      doubleClickTime: widget.doubleClickTime,
    );
  }
}

/// 개별 데이터 행 위젯
class _DataRowWidget extends StatefulWidget {
  final SelectableRow row;
  final List<SelectableColumn> columns;
  final List<double> columnWidths;
  final SelectableRowTheme theme;
  final SelectableBorderTheme borderTheme;
  final double checkboxWidth;
  final bool isSelected;
  final bool showCheckbox;
  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onSecondaryTap;
  final void Function(bool selected) onCheckboxChanged;
  final Duration doubleClickTime;

  const _DataRowWidget({
    required this.row,
    required this.columns,
    required this.columnWidths,
    required this.theme,
    required this.borderTheme,
    required this.checkboxWidth,
    required this.isSelected,
    required this.showCheckbox,
    required this.onTap,
    this.onDoubleTap,
    this.onSecondaryTap,
    required this.onCheckboxChanged,
    required this.doubleClickTime,
  });

  @override
  State<_DataRowWidget> createState() => _DataRowWidgetState();
}

class _DataRowWidgetState extends State<_DataRowWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (widget.isSelected) {
      backgroundColor =
          widget.theme.selectedBackgroundColor ?? Colors.blue.withOpacity(0.1);
    } else if (_isHovered) {
      backgroundColor =
          widget.theme.hoverBackgroundColor ?? Colors.grey.withOpacity(0.05);
    } else {
      backgroundColor = widget.theme.backgroundColor ?? Colors.white;
    }

    final effectiveHeight = widget.row.height ?? widget.theme.height;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        height: effectiveHeight,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(top: widget.theme.border ?? BorderSide.none),
        ),
        child: CustomInkWell(
          onTap: widget.onTap,
          onDoubleTap: widget.onDoubleTap,
          onSecondaryTap: widget.onSecondaryTap,
          doubleClickTime: widget.doubleClickTime,
          splashColor: widget.theme.splashColor,
          highlightColor: widget.theme.highlightColor,
          child: Row(
            children: [
              // 체크박스 셀
              if (widget.showCheckbox) _buildDataCheckbox(effectiveHeight),

              // 데이터 셀들
              ...List.generate(widget.columns.length, (columnIndex) {
                final column = widget.columns[columnIndex];
                final cell = widget.row.getCell(columnIndex);
                final width = columnIndex < widget.columnWidths.length
                    ? widget.columnWidths[columnIndex]
                    : 100.0;

                return _buildDataCell(cell, column, width, effectiveHeight);
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// 데이터 행 체크박스 빌드
  Widget _buildDataCheckbox(double height) {
    return GestureDetector(
      onTap: () => widget.onCheckboxChanged(!widget.isSelected),
      child: Container(
        width: widget.checkboxWidth,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border:
              Border(right: widget.borderTheme.cellBorder ?? BorderSide.none),
        ),
        child: Checkbox(
          value: widget.isSelected,
          onChanged: (value) => widget.onCheckboxChanged(value ?? false),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: widget.theme.checkboxTheme.activeColor,
          checkColor: widget.theme.checkboxTheme.checkColor,
        ),
      ),
    );
  }

  /// 데이터 셀 빌드
  Widget _buildDataCell(SelectableCell? cell, SelectableColumn column,
      double width, double height) {
    if (cell == null) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border:
              Border(right: widget.borderTheme.cellBorder ?? BorderSide.none),
        ),
      );
    }

    Widget content;
    if (cell.usesWidget) {
      content = cell.widget!;
    } else {
      content = Text(
        cell.displayText ?? '',
        style: cell.style ??
            widget.theme.textStyle ??
            const TextStyle(fontSize: 13),
        overflow: TextOverflow.ellipsis,
      );
    }

    Widget result = Container(
      width: width,
      height: height,
      alignment: cell.alignment ?? Alignment.centerLeft,
      padding: cell.padding ?? widget.theme.padding ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: cell.backgroundColor,
        border: Border(right: widget.borderTheme.cellBorder ?? BorderSide.none),
      ),
      child: content,
    );

    // 셀 레벨 클릭 이벤트가 있으면 처리
    if (cell.onTap != null) {
      result = GestureDetector(
        onTap: cell.onTap,
        child: result,
      );
    }

    return result;
  }
}
