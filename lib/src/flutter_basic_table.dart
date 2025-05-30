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
  final List<List<String>> data;
  final BasicTableConfig config;

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

  const BasicTable({
    super.key,
    required this.columns,
    required this.data,
    this.config = const BasicTableConfig(),
    this.selectedRows,
    this.onRowSelectionChanged,
    this.onSelectAllChanged,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowSecondaryTap,
    this.doubleClickTime = const Duration(milliseconds: 300),
    this.onColumnReorder,
  })  : assert(columns.length > 0, 'columns cannot be empty'),
        assert(data.length > 0, 'data cannot be empty');

  @override
  State<BasicTable> createState() => _BasicTableState();
}

class _BasicTableState extends State<BasicTable> {
  late List<BasicTableRow> _rows;
  late List<BasicTableColumn> _reorderedColumns; // reorder된 컬럼 순서 관리

  // 호버 상태 관리
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _reorderedColumns = List.from(widget.columns); // 초기 컬럼 순서
    _initializeTableData();
  }

  void _initializeTableData() {
    // 행 데이터 초기화 - 외부에서 전달받은 데이터와 현재 컬럼 순서에 맞춰 재정렬
    _rows = widget.data.asMap().entries.map((entry) {
      return BasicTableRow(
        index: entry.key,
        cells: List.from(entry.value), // 원본 데이터 복사
      );
    }).toList();
  }

  /// 컬럼 순서가 바뀔 때 호출되는 함수
  void _handleColumnReorder(int oldIndex, int newIndex) {
    setState(() {
      // newIndex 보정 (Flutter ReorderableListView 특성)
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      // 컬럼 순서 변경
      final BasicTableColumn movedColumn = _reorderedColumns.removeAt(oldIndex);
      _reorderedColumns.insert(newIndex, movedColumn);

      // 모든 행의 데이터도 같은 순서로 재정렬
      for (final row in _rows) {
        if (oldIndex < row.cells.length && newIndex < row.cells.length) {
          final String movedCell = row.cells.removeAt(oldIndex);
          row.cells.insert(newIndex, movedCell);
        }
      }
    });

    // 외부 콜백 호출
    widget.onColumnReorder?.call(oldIndex, newIndex);

    debugPrint('Column reordered: $oldIndex -> $newIndex');
  }

  /// 헤더 체크박스의 상태를 계산합니다
  bool? _getHeaderCheckboxState() {
    if (!widget.config.showCheckboxColumn || widget.selectedRows == null) {
      return false;
    }

    final selectedCount = widget.selectedRows!.length;
    final totalCount = _rows.length;

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableHeight = constraints.maxHeight;
        final double availableWidth = constraints.maxWidth;

        // 체크박스 컬럼 너비 계산
        final double checkboxWidth = widget.config.showCheckboxColumn
            ? widget.config.checkboxColumnWidth
            : 0.0;

        // 테이블의 최소 너비 계산 (체크박스 컬럼 포함)
        final double minTableWidth = checkboxWidth +
            _reorderedColumns.fold(0.0, (sum, col) => sum + col.minWidth);

        // 실제 콘텐츠 너비: 최소 너비와 사용 가능한 너비 중 큰 값
        final double contentWidth = max(minTableWidth, availableWidth);

        // 테이블 데이터 높이 계산
        final double tableDataHeight = widget.config.rowHeight * _rows.length;

        // 스크롤바를 위한 전체 콘텐츠 높이
        final double totalContentHeight =
            widget.config.headerHeight + tableDataHeight;

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
                              columns: _reorderedColumns, // reordered 컬럼 사용
                              totalWidth: contentWidth,
                              availableWidth: availableWidth,
                              config: widget.config,
                              checkboxWidth: checkboxWidth,
                              headerCheckboxState: _getHeaderCheckboxState(),
                              onHeaderCheckboxChanged:
                                  _handleHeaderCheckboxChanged,
                              onColumnReorder: _handleColumnReorder,
                            ),

                            // 테이블 데이터
                            Expanded(
                              child: BasicTableData(
                                rows: _rows,
                                columns: _reorderedColumns, // reordered 컬럼 사용
                                availableWidth: availableWidth,
                                config: widget.config,
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
                    if (widget.config.showVerticalScrollbar &&
                        needsVerticalScroll)
                      Positioned(
                        top: widget.config.headerHeight, // 헤더 높이만큼 아래서 시작
                        right: 0,
                        bottom: (widget.config.showHorizontalScrollbar &&
                                needsHorizontalScroll)
                            ? widget.config.scrollbarWidth
                            : 0,
                        child: AnimatedOpacity(
                          opacity: widget.config.scrollbarHoverOnly
                              ? (_isHovered
                                  ? widget.config.scrollbarOpacity
                                  : 0.0)
                              : widget.config.scrollbarOpacity,
                          duration: widget.config.scrollbarAnimationDuration,
                          child: Container(
                            width: widget.config.scrollbarWidth,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                  widget.config.scrollbarWidth / 2),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                scrollbarTheme: ScrollbarThemeData(
                                  thumbColor: WidgetStateProperty.all(
                                    Colors.black.withOpacity(0.5),
                                  ),
                                  trackColor: WidgetStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  radius: Radius.circular(
                                      widget.config.scrollbarWidth / 2),
                                  thickness: WidgetStateProperty.all(
                                      widget.config.scrollbarWidth - 4),
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
                                    height: tableDataHeight, // 헤더 제외한 데이터 높이만
                                    width: widget.config.scrollbarWidth,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    // 가로 스크롤바 (하단 오버레이) - 전체 너비 사용
                    if (widget.config.showHorizontalScrollbar &&
                        needsHorizontalScroll)
                      Positioned(
                        left: 0,
                        right: 0, // 전체 너비 사용 (세로 스크롤바까지 덮음)
                        bottom: 0,
                        child: AnimatedOpacity(
                          opacity: widget.config.scrollbarHoverOnly
                              ? (_isHovered
                                  ? widget.config.scrollbarOpacity
                                  : 0.0)
                              : widget.config.scrollbarOpacity,
                          duration: widget.config.scrollbarAnimationDuration,
                          child: Container(
                            height: widget.config.scrollbarWidth,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                  widget.config.scrollbarWidth / 2),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                scrollbarTheme: ScrollbarThemeData(
                                  thumbColor: WidgetStateProperty.all(
                                    Colors.black.withOpacity(0.5),
                                  ),
                                  trackColor: WidgetStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  radius: Radius.circular(
                                      widget.config.scrollbarWidth / 2),
                                  thickness: WidgetStateProperty.all(
                                      widget.config.scrollbarWidth - 4),
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
                                    height: widget.config.scrollbarWidth,
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

  @override
  void didUpdateWidget(BasicTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.columns != widget.columns ||
        oldWidget.data != widget.data ||
        oldWidget.config != widget.config) {
      _reorderedColumns = List.from(widget.columns); // 컬럼이 변경되면 순서 리셋
      _initializeTableData();
    }
  }
}
