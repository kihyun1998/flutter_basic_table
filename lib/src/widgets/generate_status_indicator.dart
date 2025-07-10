// lib/src/widgets/generic_status_indicator.dart
import 'package:flutter/material.dart';

import '../models/status_config.dart';

/// A generic widget for displaying status indicators based on a [StatusConfig].
///
/// This widget can render a combination of a circle, an icon, and text to visually
/// represent a given status, with flexible layout and styling options.
class GenericStatusIndicator extends StatelessWidget {
  /// The status value (e.g., an enum member) that this indicator represents.
  final Enum status;

  /// The configuration for the status indicator's appearance, including color,
  /// text, icon, size, and spacing.
  final StatusConfig config;

  /// The primary axis along which the circle/icon and text are laid out.
  /// Defaults to [Axis.horizontal].
  final Axis direction;

  /// How the children are aligned along the main axis.
  /// Defaults to [MainAxisAlignment.start] for horizontal, [MainAxisAlignment.center] for vertical.
  final MainAxisAlignment mainAxisAlignment;

  /// How the children are aligned along the cross axis.
  /// Defaults to [CrossAxisAlignment.center].
  final CrossAxisAlignment crossAxisAlignment;

  /// Creates a [GenericStatusIndicator] instance.
  const GenericStatusIndicator({
    super.key,
    required this.status,
    required this.config,
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  /// Creates a [GenericStatusIndicator] with a horizontal layout.
  ///
  /// This is a convenience factory for common horizontal status displays.
  factory GenericStatusIndicator.horizontal(
    Enum status,
    StatusConfig config, {
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return GenericStatusIndicator(
      status: status,
      config: config,
      direction: Axis.horizontal,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );
  }

  /// Creates a [GenericStatusIndicator] with a vertical layout.
  ///
  /// This is a convenience factory for common vertical status displays.
  factory GenericStatusIndicator.vertical(
    Enum status,
    StatusConfig config, {
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return GenericStatusIndicator(
      status: status,
      config: config,
      direction: Axis.vertical,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );
  }

  /// Extension methods for [Enum] to easily create [GenericStatusIndicator] widgets.
extension GenericStatusIndicatorExtensions on Enum {
  /// Creates a [GenericStatusIndicator] from this enum value and a [StatusConfig].
  ///
  /// [config] defines the visual properties of the status indicator.
  /// [direction] specifies the layout direction (horizontal or vertical).
  /// [mainAxisAlignment] and [crossAxisAlignment] control the alignment of elements.
  GenericStatusIndicator toStatusIndicator(
    StatusConfig config, {
    Axis direction = Axis.horizontal,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return GenericStatusIndicator(
      status: this,
      config: config,
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );
  }

  /// Creates a horizontally laid out [GenericStatusIndicator] from this enum value.
  GenericStatusIndicator toHorizontalStatusIndicator(StatusConfig config) {
    return GenericStatusIndicator.horizontal(this, config);
  }

  /// Creates a vertically laid out [GenericStatusIndicator] from this enum value.
  GenericStatusIndicator toVerticalStatusIndicator(StatusConfig config) {
    return GenericStatusIndicator.vertical(this, config);
  }
}
