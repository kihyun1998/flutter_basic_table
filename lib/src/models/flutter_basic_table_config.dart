/// @Deprecated('This class is deprecated. Use BasicTableThemeData for table configuration and styling instead.')
/// A model for managing general table settings.
///
/// This class is deprecated. All configuration options have been moved to
/// [BasicTableThemeData] and its sub-themes for a more unified and flexible
/// theming approach. Please use [BasicTableThemeData] to configure your table.
class BasicTableConfig {
  final double headerHeight;
  final double rowHeight;
  final bool showHorizontalScrollbar;
  final bool showVerticalScrollbar;
  final bool enableHeaderSorting;
  final bool enableHeaderReorder;
  final bool showDragHandles;

  // Scrollbar related options
  final bool scrollbarHoverOnly;
  final double scrollbarOpacity;
  final Duration scrollbarAnimationDuration;
  final double scrollbarWidth;

  // Checkbox related options
  final bool showCheckboxColumn;
  final double checkboxColumnWidth;

  /// @Deprecated('This constructor is deprecated. Use BasicTableThemeData for table configuration and styling instead.')
  const BasicTableConfig({
    this.headerHeight = 48.0,
    this.rowHeight = 40.0,
    this.showHorizontalScrollbar = true,
    this.showVerticalScrollbar = true,
    this.enableHeaderSorting = false,
    this.enableHeaderReorder = false,
    this.showDragHandles = true,
    this.scrollbarHoverOnly = true,
    this.scrollbarOpacity = 0.8,
    this.scrollbarAnimationDuration = const Duration(milliseconds: 200),
    this.scrollbarWidth = 16.0,
    this.showCheckboxColumn = false,
    this.checkboxColumnWidth = 60.0,
  });

  /// @Deprecated('This method is deprecated. Use BasicTableThemeData for table configuration and styling instead.')
  BasicTableConfig copyWith({
    double? headerHeight,
    double? rowHeight,
    bool? showHorizontalScrollbar,
    bool? showVerticalScrollbar,
    bool? enableHeaderSorting,
    bool? enableHeaderReorder,
    bool? showDragHandles,
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
      showDragHandles: showDragHandles ?? this.showDragHandles,
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
