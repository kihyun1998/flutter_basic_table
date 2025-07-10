// lib/src/models/flutter_basic_table_cell.dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/src/widgets/generate_status_indicator.dart';

import 'status_config.dart';

/// Defines the data and styling for a single table cell.
///
/// A cell can display either textual [data] with optional [style] and formatting,
/// or a custom Flutter [widget]. If a [widget] is provided, [data] and [style]
/// properties are ignored for rendering purposes.
class BasicTableCell {
  /// The data to be displayed in the cell. Typically a [String], but can be any
  /// type that can be converted to a string using `toString()` for display or sorting.
  final dynamic data;

  /// A custom Flutter widget to be displayed in the cell.
  /// If provided, this widget will be rendered instead of [data] and [style].
  final Widget? widget;

  /// The text style for the cell's [data]. This style overrides any theme-defined
  /// text styles for this specific cell.
  final TextStyle? style;

  /// The background color for the cell. This color overrides any theme-defined
  /// background colors for this specific cell.
  final Color? backgroundColor;

  /// The alignment of the cell's content within its boundaries.
  final Alignment? alignment;

  /// The padding around the cell's content.
  final EdgeInsets? padding;

  /// A specific tooltip message for this cell. If provided, this message will
  /// be displayed as the tooltip, overriding any automatic tooltip generation
  /// or column-level tooltip formatters.
  final String? tooltip;

  /// A boolean indicating whether the cell is interactive (e.g., clickable).
  /// If `false`, any `onTap`, `onDoubleTap`, or `onSecondaryTap` callbacks
  /// will not be triggered for this cell.
  /// Defaults to `true`.
  final bool enabled;

  /// An optional callback function invoked when the cell is tapped.
  /// This is separate from row-level tap callbacks.
  final VoidCallback? onTap;

  /// An optional callback function invoked when the cell is double-tapped.
  final VoidCallback? onDoubleTap;

  /// An optional callback function invoked when the cell receives a secondary tap
  /// (e.g., right-click on desktop).
  final VoidCallback? onSecondaryTap;

  /// Creates a [BasicTableCell] instance.
  ///
  /// Requires either [data] or [widget] to be provided.
  const BasicTableCell({
    this.data,
    this.widget,
    this.style,
    this.backgroundColor,
    this.alignment,
    this.padding,
    this.tooltip,
    this.enabled = true,
    this.onTap,
    this.onDoubleTap,
    this.onSecondaryTap,
  }) : assert(
          data != null || widget != null,
          'Either data or widget must be provided',
        );

  /// Creates a [BasicTableCell] primarily for displaying text.
  ///
  /// [text] is the string content of the cell.
  factory BasicTableCell.text(
    String text, {
    TextStyle? style,
    Color? backgroundColor,
    Alignment? alignment,
    EdgeInsets? padding,
    String? tooltip,
    bool enabled = true,
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onSecondaryTap,
  }) {
    return BasicTableCell(
      data: text,
      style: style,
      backgroundColor: backgroundColor,
      alignment: alignment,
      padding: padding,
      tooltip: tooltip,
      enabled: enabled,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onSecondaryTap: onSecondaryTap,
    );
  }

  /// Creates a [BasicTableCell] for displaying a custom Flutter widget.
  ///
  /// [widget] is the custom widget to be rendered inside the cell.
  factory BasicTableCell.widget(
    Widget widget, {
    Color? backgroundColor,
    EdgeInsets? padding,
    String? tooltip,
    bool enabled = true,
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onSecondaryTap,
  }) {
    return BasicTableCell(
      widget: widget,
      backgroundColor: backgroundColor,
      padding: padding,
      tooltip: tooltip,
      enabled: enabled,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onSecondaryTap: onSecondaryTap,
    );
  }

  /// Creates a [BasicTableCell] that displays a generic status indicator.
  ///
  /// This factory leverages [GenericStatusIndicator] to render a visual
  /// representation of a status, configured by a [StatusConfig] object.
  ///
  /// [status] is an enum value representing the current status.
  /// [config] defines the visual properties of the status indicator (color, text, icon, etc.).
  /// [direction] specifies the layout direction of the status indicator (horizontal or vertical).
  /// [mainAxisAlignment] and [crossAxisAlignment] control the alignment of elements within the indicator.
  factory BasicTableCell.status(
    Enum status,
    StatusConfig config, {
    Axis direction = Axis.horizontal,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    Color? backgroundColor,
    Alignment? alignment,
    EdgeInsets? padding,
    String? tooltip,
    bool enabled = true,
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onSecondaryTap,
  }) {
    final statusWidget = GenericStatusIndicator(
      status: status,
      config: config,
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );

    return BasicTableCell(
      data: config.text ?? status.toString(),
      widget: statusWidget,
      backgroundColor: backgroundColor,
      alignment: alignment,
      padding: padding,
      tooltip: tooltip ?? config.tooltip,
      enabled: enabled,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onSecondaryTap: onSecondaryTap,
    );
  }

  /// Creates a [BasicTableCell] with a horizontally laid out status indicator.
  ///
  /// This is a convenience factory for [BasicTableCell.status] with `direction` set to `Axis.horizontal`.
  factory BasicTableCell.statusHorizontal(
    Enum status,
    StatusConfig config, {
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    Color? backgroundColor,
    Alignment? alignment,
    EdgeInsets? padding,
    String? tooltip,
    bool enabled = true,
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onSecondaryTap,
  }) {
    return BasicTableCell.status(
      status,
      config,
      direction: Axis.horizontal,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      backgroundColor: backgroundColor,
      alignment: alignment,
      padding: padding,
      tooltip: tooltip,
      enabled: enabled,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onSecondaryTap: onSecondaryTap,
    );
  }

  /// Creates a [BasicTableCell] with a vertically laid out status indicator.
  ///
  /// This is a convenience factory for [BasicTableCell.status] with `direction` set to `Axis.vertical`.
  factory BasicTableCell.statusVertical(
    Enum status,
    StatusConfig config, {
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    Color? backgroundColor,
    Alignment? alignment,
    EdgeInsets? padding,
    String? tooltip,
    bool enabled = true,
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onSecondaryTap,
  }) {
    return BasicTableCell.status(
      status,
      config,
      direction: Axis.vertical,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      backgroundColor: backgroundColor,
      alignment: alignment,
      padding: padding,
      tooltip: tooltip,
      enabled: enabled,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onSecondaryTap: onSecondaryTap,
    );
  }

  /// Creates a [BasicTableCell] from a simple string data.
  /// This factory is primarily for backward compatibility and convenience.
  factory BasicTableCell.fromString(String data) {
    return BasicTableCell(data: data);
  }

  /// Returns the displayable text of the cell.
  ///
  /// If [data] is provided, its `toString()` representation is returned.
  /// If only a [widget] is provided (and no [data]), returns `null`.
  String? get displayText {
    if (data != null) return data.toString();
    return null;
  }

  /// Returns `true` if this cell is configured to display a custom [widget],
  /// `false` otherwise.
  bool get usesWidget => widget != null;

  /// Returns `true` if this cell is configured to display text [data] (and not a custom widget),
  /// `false` otherwise.
  bool get usesText => widget == null && data != null;

  /// Creates a copy of this [BasicTableCell] with the given fields replaced
  /// with new values.
  BasicTableCell copyWith({
    dynamic data,
    Widget? widget,
    TextStyle? style,
    Color? backgroundColor,
    Alignment? alignment,
    EdgeInsets? padding,
    String? tooltip,
    bool? enabled,
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onSecondaryTap,
  }) {
    return BasicTableCell(
      data: data ?? this.data,
      widget: widget ?? this.widget,
      style: style ?? this.style,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      alignment: alignment ?? this.alignment,
      padding: padding ?? this.padding,
      tooltip: tooltip ?? this.tooltip,
      enabled: enabled ?? this.enabled,
      onTap: onTap ?? this.onTap,
      onDoubleTap: onDoubleTap ?? this.onDoubleTap,
      onSecondaryTap: onSecondaryTap ?? this.onSecondaryTap,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableCell &&
        other.data == data &&
        other.widget == widget &&
        other.style == style &&
        other.backgroundColor == backgroundColor &&
        other.alignment == alignment &&
        other.padding == padding &&
        other.tooltip == tooltip &&
        other.enabled == enabled &&
        other.onTap == onTap &&
        other.onDoubleTap == onDoubleTap &&
        other.onSecondaryTap == onSecondaryTap;
  }

  @override
  int get hashCode {
    return Object.hash(
      data,
      widget,
      style,
      backgroundColor,
      alignment,
      padding,
      tooltip,
      enabled,
      onTap,
      onDoubleTap,
      onSecondaryTap,
    );
  }

  @override
  String toString() {
    return 'BasicTableCell('
        'data: $data, '
        'widget: $widget, '
        'style: $style, '
        'backgroundColor: $backgroundColor, '
        'alignment: $alignment, '
        'padding: $padding, '
        'tooltip: $tooltip, '
        'enabled: $enabled'
        ')';
  }
}
