/// 테이블 설정을 관리하는 모델
class BasicTableConfig {
  final double headerHeight;
  final double rowHeight;
  final bool showHorizontalScrollbar;
  final bool showVerticalScrollbar;
  final bool enableHeaderSorting;
  final bool enableHeaderReorder;

  // 스크롤바 관련 옵션들
  final bool scrollbarHoverOnly;
  final double scrollbarOpacity;
  final Duration scrollbarAnimationDuration;
  final double scrollbarWidth;

  // 체크박스 관련 옵션들
  final bool showCheckboxColumn;
  final double checkboxColumnWidth;

  const BasicTableConfig({
    this.headerHeight = 48.0,
    this.rowHeight = 40.0,
    this.showHorizontalScrollbar = true,
    this.showVerticalScrollbar = true,
    this.enableHeaderSorting = false,
    this.enableHeaderReorder = false, // 기본값 false
    this.scrollbarHoverOnly = true,
    this.scrollbarOpacity = 0.8,
    this.scrollbarAnimationDuration = const Duration(milliseconds: 200),
    this.scrollbarWidth = 16.0,
    this.showCheckboxColumn = false,
    this.checkboxColumnWidth = 60.0,
  });

  BasicTableConfig copyWith({
    double? headerHeight,
    double? rowHeight,
    bool? showHorizontalScrollbar,
    bool? showVerticalScrollbar,
    bool? enableHeaderSorting,
    bool? enableHeaderReorder,
    bool? scrollbarHoverOnly,
    double? scrollbarOpacity,
    Duration? scrollbarAnimationDuration,
    double? scrollbarWidth,
    bool? showCheckboxColumn,
    double? checkboxColumnWidth,
  }) {
    return BasicTableConfig(
      headerHeight: headerHeight ?? this.headerHeight,
      rowHeight: rowHeight ?? this.rowHeight,
      showHorizontalScrollbar:
          showHorizontalScrollbar ?? this.showHorizontalScrollbar,
      showVerticalScrollbar:
          showVerticalScrollbar ?? this.showVerticalScrollbar,
      enableHeaderSorting: enableHeaderSorting ?? this.enableHeaderSorting,
      enableHeaderReorder: enableHeaderReorder ?? this.enableHeaderReorder,
      scrollbarHoverOnly: scrollbarHoverOnly ?? this.scrollbarHoverOnly,
      scrollbarOpacity: scrollbarOpacity ?? this.scrollbarOpacity,
      scrollbarAnimationDuration:
          scrollbarAnimationDuration ?? this.scrollbarAnimationDuration,
      scrollbarWidth: scrollbarWidth ?? this.scrollbarWidth,
      showCheckboxColumn: showCheckboxColumn ?? this.showCheckboxColumn,
      checkboxColumnWidth: checkboxColumnWidth ?? this.checkboxColumnWidth,
    );
  }
}
