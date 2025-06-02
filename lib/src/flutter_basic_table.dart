// lib/src/flutter_basic_table.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

import 'widgets/flutter_basic_table_header_widget.dart';
import 'widgets/flutter_basic_talbe_data_widget.dart';
import 'widgets/synced_scroll_controll_widget.dart';

/// 커스텀 테이블 위젯
/// 동기화된 스크롤과 반응형 컬럼 너비를 지원합니다.
/// 스크롤바는 테이블 위에 오버레이로 표시됩니다.
/// 모든 데이터는 외부에서 정의되어야 합니다.
class BasicTable extends StatefulWidget {
  final List<BasicTableColumn> columns;
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

  // 헤더 reorder 콜백
  final void Function(int oldIndex, int newIndex)? onColumnReorder;

  // 헤더 정렬 콜백
  final void Function(int columnIndex, ColumnSortState sortState)? onColumnSort;

  // 현재 정렬 상태 (외부에서 관리) - 하위 호환성 유지
  final Map<int, ColumnSortState>? columnSortStates;

  /// 새로운 ID 기반 정렬 콜백 (선택사항)
  final void Function(String columnId, ColumnSortState sortState)?
      onColumnSortById;

  /// ID 기반 정렬 상태 관리자 (선택사항)
  final ColumnSortManager? sortManager;

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

  /// 하위 호환성을 위한 생성자 (기존 List<List<String>> 지원)
  factory BasicTable.fromStringData({
    required List<BasicTableColumn> columns,
    required List<List<String>> data,
    BasicTableThemeData? theme,
    Set<int>? selectedRows,
    void Function(int index, bool selected)? onRowSelectionChanged,
    void Function(bool selectAll)? onSelectAllChanged,
    void Function(int index)? onRowTap,
    void Function(int index)? onRowDoubleTap,
    void Function(int index)? onRowSecondaryTap,
    Duration doubleClickTime = const Duration(milliseconds: 300),
    void Function(int oldIndex, int newIndex)? onColumnReorder,
    void Function(int columnIndex, ColumnSortState sortState)? onColumnSort,
    Map<int, ColumnSortState>? columnSortStates,
    void Function(String columnId, ColumnSortState sortState)? onColumnSortById,
    ColumnSortManager? sortManager,
  }) {
    final rows = data.asMap().entries.map((entry) {
      return BasicTableRow.fromStrings(
        cells: entry.value,
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

  /// 현재 사용할 테마 (제공된 테마 또는 기본 테마)
  BasicTableThemeData get _currentTheme =>
      widget.theme ?? BasicTableThemeData.defaultTheme();

  @override
  void initState() {
    super.initState();
    _initializeSortManager();
  }

  @override
  void didUpdateWidget(BasicTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 컬럼이나 정렬 상태가 변경되면 정렬 관리자 재초기화
    if (widget.columns != oldWidget.columns ||
        widget.columnSortStates != oldWidget.columnSortStates ||
        widget.sortManager != oldWidget.sortManager) {
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
        widget.columns,
      );
    } else {
      // 새로운 빈 정렬 관리자 생성
      _internalSortManager = ColumnSortManager();
    }
  }

  /// 현재 행 데이터 반환 (더 이상 변환 불필요)
  List<BasicTableRow> get _currentRows => widget.rows;

  /// 전체 테이블 데이터의 높이를 계산 (개별 행 높이 고려)
  double _calculateTotalDataHeight() {
    return _currentRows.fold(0.0, (total, row) {
      return total + row.getEffectiveHeight(_currentTheme.dataRowTheme.height);
    });
  }

  /// 컬럼 순서가 바뀔 때 호출되는 함수 - 외부 콜백만 호출
  /// 정렬 상태는 ID 기반이므로 자동으로 올바른 컬럼을 따라감
  void _handleColumnReorder(int oldIndex, int newIndex) {
    // 외부 콜백 호출 (외부에서 데이터 관리)
    widget.onColumnReorder?.call(oldIndex, newIndex);

    debugPrint('Column reorder requested: $oldIndex -> $newIndex');

    // 디버그: 정렬 상태 확인
    debugPrint('Sort states after reorder:');
    _internalSortManager.printDebugInfo(widget.columns);
  }

  /// 컬럼 정렬이 변경될 때 호출되는 함수
  void _handleColumnSort(int columnIndex, ColumnSortState sortState) {
    if (columnIndex < 0 || columnIndex >= widget.columns.length) return;

    final String columnId = widget.columns[columnIndex].effectiveId;

    // 내부 정렬 관리자 업데이트
    _internalSortManager.setSortState(columnId, sortState);

    // 외부 콜백 호출 (기존 방식 - 하위 호환성)
    widget.onColumnSort?.call(columnIndex, sortState);

    // 새로운 ID 기반 콜백 호출
    widget.onColumnSortById?.call(columnId, sortState);

    debugPrint(
        'Column sort requested: column $columnIndex ($columnId) -> $sortState');
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

  /// 현재 정렬 상태를 인덱스 기반 Map으로 변환 (하위 호환성)
  Map<int, ColumnSortState> _getCurrentSortStates() {
    return _internalSortManager.toIndexMap(widget.columns);
  }

  @override
  Widget build(BuildContext context) {
    final currentRows = _currentRows;
    final theme = _currentTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableHeight = constraints.maxHeight;
        final double availableWidth = constraints.maxWidth;

        // 체크박스 컬럼 너비 계산
        final double checkboxWidth =
            theme.checkboxTheme.enabled ? theme.checkboxTheme.columnWidth : 0.0;

        // 테이블의 최소 너비 계산 (체크박스 컬럼 포함)
        final double minTableWidth = checkboxWidth +
            widget.columns.fold(0.0, (sum, col) => sum + col.minWidth);

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
                              columns: widget.columns,
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
                                columns: widget.columns,
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
