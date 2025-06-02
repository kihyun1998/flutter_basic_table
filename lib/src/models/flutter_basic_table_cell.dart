// lib/src/models/flutter_basic_table_cell.dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/src/widgets/generate_status_indicator.dart';

import 'status_config.dart';

/// 테이블 셀의 데이터와 스타일을 정의하는 모델
///
/// 각 셀은 다음 중 하나의 방식으로 표시될 수 있습니다:
/// 1. [data] + [style] - 텍스트 데이터와 스타일
/// 2. [widget] - 완전히 커스텀한 위젯
///
/// [widget]이 제공되면 [data]와 [style]은 무시됩니다.
class BasicTableCell {
  /// 셀에 표시할 데이터 (보통 String, 하지만 toString()이 가능한 모든 타입)
  final dynamic data;

  /// 커스텀 위젯 (제공되면 data와 style은 무시됨)
  final Widget? widget;

  /// 개별 셀의 텍스트 스타일 (테마보다 우선 적용)
  final TextStyle? style;

  /// 개별 셀의 배경색 (테마보다 우선 적용)
  final Color? backgroundColor;

  /// 개별 셀의 텍스트 정렬
  final Alignment? alignment;

  /// 개별 셀의 패딩
  final EdgeInsets? padding;

  /// 개별 셀의 tooltip 메시지 (자동 감지 대신 강제 지정)
  final String? tooltip;

  /// 셀 클릭 가능 여부
  final bool enabled;

  /// 셀 클릭 콜백 (행 클릭과 별개)
  final VoidCallback? onTap;

  /// 셀 더블클릭 콜백
  final VoidCallback? onDoubleTap;

  /// 셀 우클릭 콜백
  final VoidCallback? onSecondaryTap;

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

  /// 문자열 데이터로 간단한 셀 생성
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

  /// 커스텀 위젯으로 셀 생성
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

  /// Generic 상태 표시기로 셀 생성
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

  /// 가로 레이아웃 상태 표시기 셀 생성
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

  /// 세로 레이아웃 상태 표시기 셀 생성
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

  /// 기존 String 데이터와의 호환성을 위한 팩토리
  factory BasicTableCell.fromString(String data) {
    return BasicTableCell(data: data);
  }

  /// 표시될 텍스트를 반환 (정렬용 데이터 포함)
  String? get displayText {
    if (data != null) return data.toString();
    // widget만 있고 data가 없으면 null
    return null;
  }

  /// 실제로 위젯을 사용할지 여부
  bool get usesWidget => widget != null;

  /// 텍스트를 사용할지 여부
  bool get usesText => widget == null && data != null;

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
