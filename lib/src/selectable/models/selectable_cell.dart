import 'package:flutter/material.dart';

/// SelectableTable에서 사용하는 셀 모델
///
/// 선택 기능이 있는 테이블의 개별 셀 데이터를 정의합니다.
class SelectableCell {
  /// 셀에 표시할 데이터
  final dynamic data;

  /// 커스텀 위젯 (제공되면 data 대신 사용)
  final Widget? widget;

  /// 텍스트 스타일
  final TextStyle? style;

  /// 배경색
  final Color? backgroundColor;

  /// 텍스트 정렬
  final Alignment? alignment;

  /// 패딩
  final EdgeInsets? padding;

  /// 셀 클릭 콜백
  final VoidCallback? onTap;

  /// 활성화 여부
  final bool enabled;

  const SelectableCell({
    this.data,
    this.widget,
    this.style,
    this.backgroundColor,
    this.alignment,
    this.padding,
    this.onTap,
    this.enabled = true,
  }) : assert(
          data != null || widget != null,
          'Either data or widget must be provided',
        );

  /// 텍스트 셀 생성 팩토리
  factory SelectableCell.text(
    String text, {
    TextStyle? style,
    Color? backgroundColor,
    VoidCallback? onTap,
  }) {
    return SelectableCell(
      data: text,
      style: style,
      backgroundColor: backgroundColor,
      onTap: onTap,
    );
  }

  /// 위젯 셀 생성 팩토리
  factory SelectableCell.widget(
    Widget widget, {
    Color? backgroundColor,
    VoidCallback? onTap,
  }) {
    return SelectableCell(
      widget: widget,
      backgroundColor: backgroundColor,
      onTap: onTap,
    );
  }

  /// 표시될 텍스트 반환
  String? get displayText {
    if (data != null) return data.toString();
    return null;
  }

  /// 위젯 사용 여부
  bool get usesWidget => widget != null;

  /// 텍스트 사용 여부
  bool get usesText => widget == null && data != null;

  SelectableCell copyWith({
    dynamic data,
    Widget? widget,
    TextStyle? style,
    Color? backgroundColor,
    Alignment? alignment,
    EdgeInsets? padding,
    VoidCallback? onTap,
    bool? enabled,
  }) {
    return SelectableCell(
      data: data ?? this.data,
      widget: widget ?? this.widget,
      style: style ?? this.style,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      alignment: alignment ?? this.alignment,
      padding: padding ?? this.padding,
      onTap: onTap ?? this.onTap,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SelectableCell &&
        other.data == data &&
        other.widget == widget &&
        other.style == style &&
        other.backgroundColor == backgroundColor &&
        other.alignment == alignment &&
        other.padding == padding &&
        other.onTap == onTap &&
        other.enabled == enabled;
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
      onTap,
      enabled,
    );
  }

  @override
  String toString() {
    return 'SelectableCell(data: $data, usesWidget: $usesWidget)';
  }
}
