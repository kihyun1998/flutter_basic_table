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

  const BasicTable({
    super.key,
    required this.columns,
    required this.data,
    this.config = const BasicTableConfig(),
  })  : assert(columns.length > 0, 'columns cannot be empty'),
        assert(data.length > 0, 'data cannot be empty');

  @override
  State<BasicTable> createState() => _BasicTableState();
}

class _BasicTableState extends State<BasicTable> {
  late List<BasicTableRow> _rows;

  // 호버 상태 관리
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _initializeTableData();
  }

  void _initializeTableData() {
    // 행 데이터 초기화 - 외부에서 전달받은 데이터만 사용
    _rows = widget.data.asMap().entries.map((entry) {
      return BasicTableRow(
        index: entry.key,
        cells: entry.value,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableHeight = constraints.maxHeight;
        final double availableWidth = constraints.maxWidth;

        // 테이블의 최소 너비 계산
        final double minTableWidth =
            widget.columns.fold(0.0, (sum, col) => sum + col.minWidth);

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
                              columns: widget.columns,
                              totalWidth: contentWidth,
                              availableWidth: availableWidth,
                              config: widget.config,
                            ),

                            // 테이블 데이터
                            Expanded(
                              child: BasicTableData(
                                rows: _rows,
                                columns: widget.columns,
                                availableWidth: availableWidth,
                                config: widget.config,
                                verticalController: verticalScrollController,
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
      _initializeTableData();
    }
  }
}
