// lib/src/flutter_basic_table.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

import 'widgets/flutter_basic_table_header_widget.dart';
import 'widgets/flutter_basic_talbe_data_widget.dart';
import 'widgets/synced_scroll_controll_widget.dart';

/// A highly customizable and feature-rich table widget for Flutter.
///
/// `BasicTable` provides synchronized scrolling, responsive column widths,
/// and a flexible API for managing columns, rows, and their interactions.
/// It supports sorting, column reordering, row selection, and extensive theming.
///
/// All data (columns and rows) must be defined externally and passed to the widget.
///
/// Example Usage:
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:flutter_basic_table/flutter_basic_table.dart';
///
/// enum MyStatus { active, inactive, pending }
///
/// class MyTableScreen extends StatefulWidget {
///   const MyTableScreen({super.key});
///
///   @override
///   State<MyTableScreen> createState() => _MyTableScreenState();
/// }
///
/// class _MyTableScreenState extends State<MyTableScreen> {
///   // Define columns using a Map for better management and reordering.
///   final Map<String, BasicTableColumn> _columns = {
///     'id': BasicTableColumn(id: 'id', name: 'ID', order: 0, minWidth: 50),
///     'name': BasicTableColumn(id: 'name', name: 'Name', order: 1, minWidth: 150),
///     'age': BasicTableColumn(id: 'age', name: 'Age', order: 2, minWidth: 80),
///     'status': BasicTableColumn(
///       id: 'status',
///       name: 'Status',
///       order: 3,
///       minWidth: 120,
///       // Custom tooltip for status column
///       tooltipFormatter: (value) => 'Current status: \$value',
///     ),
///     'action': BasicTableColumn(id: 'action', name: 'Action', order: 4, minWidth: 100),
///   };
///
///   // Sample data for rows.
///   List<BasicTableRow> _rows = [];
///
///   // Keep track of selected rows.
///   Set<int> _selectedRows = {};
///
///   // Manage sorting state.
///   final ColumnSortManager _sortManager = ColumnSortManager();
///
///   @override
///   void initState() {
///     super.initState();
///     _generateSampleData();
///   }
///
///   void _generateSampleData() {
///     _rows = List.generate(20, (rowIndex) {
///       final status = MyStatus.values[rowIndex % MyStatus.values.length];
///       final statusConfig = {
///         MyStatus.active: StatusConfig.badge(color: Colors.green, text: 'Active'),
///         MyStatus.inactive: StatusConfig.badge(color: Colors.red, text: 'Inactive'),
///         MyStatus.pending: StatusConfig.badge(color: Colors.orange, text: 'Pending'),
///       }[status]!;
///
///       return BasicTableRow(
///         index: rowIndex,
///         cells: {
///           'id': BasicTableCell.text((rowIndex + 1).toString()),
///           'name': BasicTableCell.text('User ${rowIndex + 1}'),
///           'age': BasicTableCell.text((20 + rowIndex).toString()),
///           'status': BasicTableCell.status(status, statusConfig),
///           'action': BasicTableCell.widget(
///             ElevatedButton(
///               onPressed: () {
///                 ScaffoldMessenger.of(context).showSnackBar(
///                   SnackBar(content: Text('Action for row \$rowIndex')),
///                 );
///               },
///               child: const Text('Do Something'),
///             ),
///           ),
///         },
///         height: rowIndex % 2 == 0 ? 50.0 : 60.0, // Example of custom row height
///       );
///     });
///     _applySorting(); // Apply initial sorting if any
///   }
///
///   void _applySorting() {
///     if (_sortManager.hasSortedColumn) {
///       final sortedColumnId = _sortManager.currentSortedColumnId!;
///       final sortState = _sortManager.getSortState(sortedColumnId);
///
///       _rows.sort((a, b) {
///         final aValue = a.getComparableValue(sortedColumnId);
///         final bValue = b.getComparableValue(sortedColumnId);
///
///         int compareResult = aValue.compareTo(bValue);
///         if (sortState == ColumnSortState.descending) {
///           compareResult = -compareResult;
///         }
///         return compareResult;
///       });
///     }
///     setState(() {});
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: const Text('Basic Table Example')),
///       body: Padding(
///         padding: const EdgeInsets.all(16.0),
///         child: BasicTable(
///           columns: _columns,
///           rows: _rows,
///           theme: BasicTableThemeData(
///             headerTheme: BasicTableHeaderCellTheme(
///               enableSorting: true, // Enable sorting on headers
///               enableReorder: true, // Enable column reordering
///             ),
///             checkboxTheme: BasicTableCheckboxCellTheme(
///               enabled: true, // Enable row selection checkboxes
///             ),
///             dataRowTheme: BasicTableDataRowTheme(
///               backgroundColor: Colors.blue.withOpacity(0.02),
///               textStyle: const TextStyle(color: Colors.deepPurple),
///             ),
///           ),
///           selectedRows: _selectedRows,
///           onRowSelectionChanged: (index, selected) {
///             setState(() {
///               if (selected) {
///                 _selectedRows.add(index);
///               } else {
///                 _selectedRows.remove(index);
///               }
///             });
///           },
///           onSelectAllChanged: (selectAll) {
///             setState(() {
///               if (selectAll) {
///                 _selectedRows = Set<int>.from(
///                     _rows.map((row) => row.index));
///               } else {
///                 _selectedRows.clear();
///               }
///             });
///           },
///           onRowTap: (index) {
///             ScaffoldMessenger.of(context).showSnackBar(
///               SnackBar(content: Text('Row \$index tapped!')),
///             );
///           },
///           onRowDoubleTap: (index) {
///             ScaffoldMessenger.of(context).showSnackBar(
///               SnackBar(content: Text('Row \$index double tapped!')),
///             );
///           },
///           onColumnReorder: (columnId, newOrder) {
///             setState(() {
///               _columns = BasicTableColumn.reorderColumn(_columns, columnId, newOrder);
///             });
///           },
///           onColumnSortById: (columnId, sortState) {
///             _sortManager.setSortState(columnId, sortState);
///             _applySorting();
///           },
///           sortManager: _sortManager, // Pass the sort manager
///         ),
///       ),
///     );
///   }
/// }
/// ```
class BasicTable extends StatefulWidget {
  /// 컬럼 정의 Map (컬럼 ID → 컬럼 정보)
  final Map<String, BasicTableColumn> columns;

  /// 테이블 행 데이터 List
  final List<BasicTableRow> rows;

  final BasicTableThemeData? theme;

  // 체크박스 관련 외부 정의 필드들
  final Set<int>? selectedRows;
  final void Function(int index, bool selected)? onRowSelectionChanged;
  final void Function(bool selectAll)? onSelectAllChanged;

  // 행 클릭 관련 외부 정의 필드들
  final void Function(int index)? onRowTap;
  final void Function(int index)? onRowDoubleTap;
  final void Function(int index)? onRowSecondaryTap;
  final Duration doubleClickTime;

  // 헤더 reorder 콜백 (이제 컬럼 ID 기반)
  final void Function(String columnId, int newOrder)? onColumnReorder;

  // 헤더 정렬 콜백
  final void Function(int visibleColumnIndex, ColumnSortState sortState)?
      onColumnSort;

  // 현재 정렬 상태 (외부에서 관리) - 하위 호환성 유지
  final Map<int, ColumnSortState>? columnSortStates;

  /// 새로운 ID 기반 정렬 콜백 (권장)
  final void Function(String columnId, ColumnSortState sortState)?
      onColumnSortById;

  /// ID 기반 정렬 상태 관리자 (권장)
  final ColumnSortManager? sortManager;

  /// Creates a [BasicTable] widget.
  ///
  /// [columns] is a required [Map] where keys are unique column IDs (String)
  /// and values are [BasicTableColumn] objects defining each column's properties
  /// like name, order, minWidth, etc. This Map-based approach allows for
  /// flexible column management and reordering.
  ///
  /// [rows] is a required [List] of [BasicTableRow] objects, where each
  /// [BasicTableRow] represents a row of data in the table. Each [BasicTableRow]
  /// contains a Map of [BasicTableCell] objects, keyed by column ID.
  ///
  /// [theme] is an optional [BasicTableThemeData] object to customize the
  /// appearance of the table, including header, data rows, checkboxes,
  /// scrollbars, borders, and tooltips. If not provided, a default theme is used.
  ///
  /// [selectedRows] is an optional [Set] of row indices (int) that are currently
  /// selected. This is used for managing row selection state externally.
  ///
  /// [onRowSelectionChanged] is an optional callback function that is invoked
  /// when the selection state of a single row changes (e.g., when a row's
  /// checkbox is toggled). It provides the row's index and its new selection state.
  ///
  /// [onSelectAllChanged] is an optional callback function that is invoked
  /// when the header checkbox (select all/deselect all) is toggled. It provides
  /// a boolean indicating whether all rows should be selected (`true`) or deselected (`false`).
  ///
  /// [onRowTap] is an optional callback function that is invoked when a table
  /// row is tapped. It provides the index of the tapped row.
  ///
  /// [onRowDoubleTap] is an optional callback function that is invoked when a
  /// table row is double-tapped. It provides the index of the double-tapped row.
  ///
  /// [onRowSecondaryTap] is an optional callback function that is invoked when a
  /// table row receives a secondary tap (e.g., right-click on desktop). It provides
  /// the index of the secondary-tapped row.
  ///
  /// [doubleClickTime] defines the maximum duration between two taps for them
  /// to be considered a double-tap. Defaults to 300 milliseconds.
  ///
  /// [onColumnReorder] is an optional callback function that is invoked when
  /// a column is reordered by dragging its header. It provides the `columnId`
  /// of the reordered column and its `newOrder` (visible index).
  ///
  /// [onColumnSort] is a deprecated callback for column sorting, providing
  /// the `visibleColumnIndex` and `sortState`. Use [onColumnSortById] instead.
  ///
  /// [columnSortStates] is a deprecated parameter for managing sorting state
  /// based on visible column index. Use [sortManager] instead.
  ///
  /// [onColumnSortById] is the recommended callback for column sorting,
  /// providing the `columnId` and `sortState`. This is preferred over
  /// [onColumnSort] as it is ID-based and more robust to column reordering.
  ///
  /// [sortManager] is an optional [ColumnSortManager] instance to externally
  /// manage and synchronize the sorting state of columns. If provided, it will
  /// be used as the source of truth for sorting.
  const BasicTable({
    super.key,
    required this.columns,
    required this.rows,
    this.theme,
    this.selectedRows,
    this.onRowSelectionChanged,
    this.onSelectAllChanged,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowSecondaryTap,
    this.doubleClickTime = const Duration(milliseconds: 300),
    this.onColumnReorder,
    this.onColumnSort,
    this.columnSortStates,
    this.onColumnSortById,
    this.sortManager,
  })  : assert(columns.length > 0, 'columns cannot be empty'),
        assert(rows.length > 0, 'rows cannot be empty');

  /// 하위 호환성을 위한 생성자 (기존 List<BasicTableColumn> 지원)
  @Deprecated(
      'Use the default constructor with a Map<String, BasicTableColumn> instead. This will be removed in a future version.')
  factory BasicTable.fromColumnList({
    required List<BasicTableColumn> columns,
    required List<BasicTableRow> rows,
    BasicTableThemeData? theme,
    Set<int>? selectedRows,
    void Function(int index, bool selected)? onRowSelectionChanged,
    void Function(bool selectAll)? onSelectAllChanged,
    void Function(int index)? onRowTap,
    void Function(int index)? onRowDoubleTap,
    void Function(int index)? onRowSecondaryTap,
    Duration doubleClickTime = const Duration(milliseconds: 300),
    void Function(String columnId, int newOrder)? onColumnReorder,
    void Function(int visibleColumnIndex, ColumnSortState sortState)?
        onColumnSort,
    Map<int, ColumnSortState>? columnSortStates,
    void Function(String columnId, ColumnSortState sortState)? onColumnSortById,
    ColumnSortManager? sortManager,
  }) {
    // order 필드가 없는 경우 인덱스를 order로 사용
    final columnsWithOrder = <BasicTableColumn>[];
    for (int i = 0; i < columns.length; i++) {
      final column = columns[i];
      columnsWithOrder.add(column.copyWith(order: column.order));
    }

    return BasicTable(
      columns: BasicTableColumn.listToMap(columnsWithOrder),
      rows: rows,
      theme: theme,
      selectedRows: selectedRows,
      onRowSelectionChanged: onRowSelectionChanged,
      onSelectAllChanged: onSelectAllChanged,
      onRowTap: onRowTap,
      onRowDoubleTap: onRowDoubleTap,
      onRowSecondaryTap: onRowSecondaryTap,
      doubleClickTime: doubleClickTime,
      onColumnReorder: onColumnReorder,
      onColumnSort: onColumnSort,
      columnSortStates: columnSortStates,
      onColumnSortById: onColumnSortById,
      sortManager: sortManager,
    );
  }

  /// 기존 String 데이터 지원 (완전히 새로운 API)
  @Deprecated(
      'Use the default constructor. Convert your data to a List<BasicTableRow> using `BasicTableRow.fromStrings` before passing it to the widget. This will be removed in a future version.')
  factory BasicTable.fromStringData({
    required Map<String, BasicTableColumn> columns,
    required List<Map<String, String>> data,
    BasicTableThemeData? theme,
    Set<int>? selectedRows,
    void Function(int index, bool selected)? onRowSelectionChanged,
    void Function(bool selectAll)? onSelectAllChanged,
    void Function(int index)? onRowTap,
    void Function(int index)? onRowDoubleTap,
    void Function(int index)? onRowSecondaryTap,
    Duration doubleClickTime = const Duration(milliseconds: 300),
    void Function(String columnId, int newOrder)? onColumnReorder,
    void Function(int visibleColumnIndex, ColumnSortState sortState)?
        onColumnSort,
    Map<int, ColumnSortState>? columnSortStates,
    void Function(String columnId, ColumnSortState sortState)? onColumnSortById,
    ColumnSortManager? sortManager,
  }) {
    final rows = data.asMap().entries.map((entry) {
      return BasicTableRow.fromStrings(
        cellTexts: entry.value,
        index: entry.key,
      );
    }).toList();

    return BasicTable(
      columns: columns,
      rows: rows,
      theme: theme,
      selectedRows: selectedRows,
      onRowSelectionChanged: onRowSelectionChanged,
      onSelectAllChanged: onSelectAllChanged,
      onRowTap: onRowTap,
      onRowDoubleTap: onRowDoubleTap,
      onRowSecondaryTap: onRowSecondaryTap,
      doubleClickTime: doubleClickTime,
      onColumnReorder: onColumnReorder,
      onColumnSort: onColumnSort,
      columnSortStates: columnSortStates,
      onColumnSortById: onColumnSortById,
      sortManager: sortManager,
    );
  }

  @override
  State<BasicTable> createState() => _BasicTableState();
}

class _BasicTableState extends State<BasicTable> {
  // 호버 상태 관리
  bool _isHovered = false;

  // 내부 정렬 관리자
  late ColumnSortManager _internalSortManager;

  // 정렬된 컬럼 리스트 캐싱
  List<BasicTableColumn>? _cachedSortedColumns;

  /// 현재 사용할 테마 (제공된 테마 또는 기본 테마)
  BasicTableThemeData get _currentTheme =>
      widget.theme ?? BasicTableThemeData();

  /// order 기준으로 정렬된 컬럼 리스트 (캐싱됨)
  List<BasicTableColumn> get _sortedColumns {
    _cachedSortedColumns ??= BasicTableColumn.mapToSortedList(widget.columns);
    return _cachedSortedColumns!;
  }

  @override
  void initState() {
    super.initState();
    _initializeSortManager();
  }

  @override
  void didUpdateWidget(BasicTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 컬럼이나 정렬 상태가 변경되면 캐시 무효화 및 정렬 관리자 재초기화
    if (widget.columns != oldWidget.columns ||
        widget.columnSortStates != oldWidget.columnSortStates ||
        widget.sortManager != oldWidget.sortManager) {
      _cachedSortedColumns = null; // 캐시 무효화
      _initializeSortManager();
    }
  }

  /// 정렬 관리자 초기화
  void _initializeSortManager() {
    if (widget.sortManager != null) {
      // 외부에서 제공된 정렬 관리자 사용
      _internalSortManager = widget.sortManager!.copy();
    } else if (widget.columnSortStates != null) {
      // 기존 인덱스 기반 Map에서 생성 (하위 호환성)
      _internalSortManager = ColumnSortManager.fromIndexMap(
        widget.columnSortStates!,
        _sortedColumns,
      );
    } else {
      // 새로운 빈 정렬 관리자 생성
      _internalSortManager = ColumnSortManager();
    }
  }

  /// 현재 행 데이터 반환 (Map 기반으로 처리)
  List<BasicTableRow> get _currentRows {
    // 모든 행이 필요한 컬럼을 가지도록 보장
    return widget.rows.map((row) {
      return row.fillMissingColumns(widget.columns.keys.toSet());
    }).toList();
  }

  /// 전체 테이블 데이터의 높이를 계산 (개별 행 높이 고려)
  double _calculateTotalDataHeight() {
    return _currentRows.fold(0.0, (total, row) {
      return total + row.getEffectiveHeight(_currentTheme.dataRowTheme.height);
    });
  }

  /// 컬럼 순서가 바뀔 때 호출되는 함수
  void _handleColumnReorder(String columnId, int newOrder) {
    // 외부 콜백 호출 (외부에서 데이터 관리)
    widget.onColumnReorder?.call(columnId, newOrder);

    debugPrint('Column reorder requested: $columnId -> order $newOrder');

    // 캐시 무효화 (다음 빌드에서 새로 계산됨)
    _cachedSortedColumns = null;
  }

  /// 컬럼 정렬이 변경될 때 호출되는 함수
  void _handleColumnSort(int visibleColumnIndex, ColumnSortState sortState) {
    if (visibleColumnIndex < 0 || visibleColumnIndex >= _sortedColumns.length)
      return;

    final String columnId = _sortedColumns[visibleColumnIndex].id;

    // 내부 정렬 관리자 업데이트
    _internalSortManager.setSortState(columnId, sortState);

    // 외부 콜백 호출 (기존 방식 - 하위 호환성)
    widget.onColumnSort?.call(visibleColumnIndex, sortState);

    // 새로운 ID 기반 콜백 호출 (권장)
    widget.onColumnSortById?.call(columnId, sortState);

    debugPrint(
        'Column sort requested: column $visibleColumnIndex ($columnId) -> $sortState');
  }

  /// 헤더 체크박스의 상태를 계산합니다
  bool? _getHeaderCheckboxState() {
    if (!_currentTheme.checkboxTheme.enabled || widget.selectedRows == null) {
      return false;
    }

    final selectedCount = widget.selectedRows!.length;
    final totalCount = _currentRows.length;

    if (selectedCount == 0) {
      return false; // 아무것도 선택안됨
    } else if (selectedCount == totalCount) {
      return true; // 모든 행이 선택됨
    } else {
      return null; // 일부 행이 선택됨 (indeterminate)
    }
  }

  /// 헤더 체크박스 클릭 처리
  void _handleHeaderCheckboxChanged() {
    if (widget.onSelectAllChanged == null) return;

    final selectedCount = widget.selectedRows?.length ?? 0;

    // 뭔가 선택되어 있으면 전체 해제, 아니면 전체 선택
    final shouldSelectAll = selectedCount == 0;
    widget.onSelectAllChanged!(shouldSelectAll);
  }

  /// 현재 정렬 상태를 visible 인덱스 기반 Map으로 변환 (하위 호환성)
  Map<int, ColumnSortState> _getCurrentSortStates() {
    return _internalSortManager.toIndexMap(_sortedColumns);
  }

  @override
  Widget build(BuildContext context) {
    final currentRows = _currentRows;
    final theme = _currentTheme;
    final sortedColumns = _sortedColumns;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableHeight = constraints.maxHeight;
        final double availableWidth = constraints.maxWidth;

        // 체크박스 컬럼 너비 계산
        final double checkboxWidth =
            theme.checkboxTheme.enabled ? theme.checkboxTheme.columnWidth : 0.0;

        // 테이블의 최소 너비 계산 (체크박스 컬럼 포함)
        final double minTableWidth = checkboxWidth +
            sortedColumns.fold(0.0, (sum, col) => sum + col.minWidth);

        // 실제 콘텐츠 너비: 최소 너비와 사용 가능한 너비 중 큰 값
        final double contentWidth = max(minTableWidth, availableWidth);

        // 테이블 데이터 높이 계산 (개별 행 높이 고려)
        final double tableDataHeight = _calculateTotalDataHeight();

        // 스크롤바를 위한 전체 콘텐츠 높이
        final double totalContentHeight =
            theme.headerTheme.height + tableDataHeight;

        return SyncedScrollControllers(
          builder: (
            context,
            verticalScrollController,
            verticalScrollbarController,
            horizontalScrollController,
            horizontalScrollbarController,
          ) {
            // 스크롤 필요 여부 계산
            final bool needsVerticalScroll =
                totalContentHeight > availableHeight;
            final bool needsHorizontalScroll = contentWidth > availableWidth;

            return MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: ScrollConfiguration(
                // Flutter 기본 스크롤바 숨기기
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                ),
                child: Stack(
                  children: [
                    // 메인 테이블 영역 (헤더 + 데이터 통합)
                    SingleChildScrollView(
                      controller: horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: SizedBox(
                        width: contentWidth,
                        child: Column(
                          children: [
                            // 테이블 헤더
                            BasicTableHeader(
                              columns: sortedColumns, // Map이 아닌 정렬된 List 전달
                              totalWidth: contentWidth,
                              availableWidth: availableWidth,
                              theme: theme,
                              checkboxWidth: checkboxWidth,
                              headerCheckboxState: _getHeaderCheckboxState(),
                              onHeaderCheckboxChanged:
                                  _handleHeaderCheckboxChanged,
                              onColumnReorder: _handleColumnReorder,
                              onColumnSort: _handleColumnSort,
                              columnSortStates:
                                  _getCurrentSortStates(), // 실시간 변환
                            ),

                            // 테이블 데이터
                            Expanded(
                              child: BasicTableData(
                                rows: currentRows,
                                sortedColumns:
                                    sortedColumns, // Map이 아닌 정렬된 List 전달
                                availableWidth: availableWidth,
                                theme: theme,
                                verticalController: verticalScrollController,
                                checkboxWidth: checkboxWidth,
                                selectedRows: widget.selectedRows ?? {},
                                onRowSelectionChanged:
                                    widget.onRowSelectionChanged,
                                onRowTap: widget.onRowTap,
                                onRowDoubleTap: widget.onRowDoubleTap,
                                onRowSecondaryTap: widget.onRowSecondaryTap,
                                doubleClickTime: widget.doubleClickTime,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 세로 스크롤바 (우측 오버레이) - 헤더 밑에서 시작
                    if (theme.scrollbarTheme.showVertical &&
                        needsVerticalScroll)
                      Positioned(
                        top: theme.headerTheme.height,
                        right: 0,
                        bottom: (theme.scrollbarTheme.showHorizontal &&
                                needsHorizontalScroll)
                            ? theme.scrollbarTheme.width
                            : 0,
                        child: AnimatedOpacity(
                          opacity: theme.scrollbarTheme.hoverOnly
                              ? (_isHovered
                                  ? theme.scrollbarTheme.opacity
                                  : 0.0)
                              : theme.scrollbarTheme.opacity,
                          duration: theme.scrollbarTheme.animationDuration,
                          child: Container(
                            width: theme.scrollbarTheme.width,
                            decoration: BoxDecoration(
                              color: theme.scrollbarTheme.trackColor,
                              borderRadius: BorderRadius.circular(
                                  theme.scrollbarTheme.width / 2),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                scrollbarTheme: ScrollbarThemeData(
                                  thumbColor: WidgetStateProperty.all(
                                    theme.scrollbarTheme.color,
                                  ),
                                  trackColor: WidgetStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  radius: Radius.circular(
                                      theme.scrollbarTheme.width / 2),
                                  thickness: WidgetStateProperty.all(
                                      theme.scrollbarTheme.width - 4),
                                ),
                              ),
                              child: Scrollbar(
                                controller: verticalScrollbarController,
                                thumbVisibility: true,
                                trackVisibility: false,
                                child: SingleChildScrollView(
                                  controller: verticalScrollbarController,
                                  scrollDirection: Axis.vertical,
                                  child: SizedBox(
                                    height: tableDataHeight,
                                    width: theme.scrollbarTheme.width,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    // 가로 스크롤바 (하단 오버레이) - 전체 너비 사용
                    if (theme.scrollbarTheme.showHorizontal &&
                        needsHorizontalScroll)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: AnimatedOpacity(
                          opacity: theme.scrollbarTheme.hoverOnly
                              ? (_isHovered
                                  ? theme.scrollbarTheme.opacity
                                  : 0.0)
                              : theme.scrollbarTheme.opacity,
                          duration: theme.scrollbarTheme.animationDuration,
                          child: Container(
                            height: theme.scrollbarTheme.width,
                            decoration: BoxDecoration(
                              color: theme.scrollbarTheme.trackColor,
                              borderRadius: BorderRadius.circular(
                                  theme.scrollbarTheme.width / 2),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                scrollbarTheme: ScrollbarThemeData(
                                  thumbColor: WidgetStateProperty.all(
                                    theme.scrollbarTheme.color,
                                  ),
                                  trackColor: WidgetStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  radius: Radius.circular(
                                      theme.scrollbarTheme.width / 2),
                                  thickness: WidgetStateProperty.all(
                                      theme.scrollbarTheme.width - 4),
                                ),
                              ),
                              child: Scrollbar(
                                controller: horizontalScrollbarController,
                                thumbVisibility: true,
                                trackVisibility: false,
                                child: SingleChildScrollView(
                                  controller: horizontalScrollbarController,
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: contentWidth,
                                    height: theme.scrollbarTheme.width,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
