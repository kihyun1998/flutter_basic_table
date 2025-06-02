import 'package:flutter/material.dart';

/// 상태 표시기의 설정을 정의하는 클래스
/// 사용자가 자신만의 상태 시스템을 구현할 때 사용합니다.
class StatusConfig {
  /// 상태 표시 색상
  final Color color;

  /// 상태 텍스트 (null이면 텍스트 없음)
  final String? text;

  /// 원형 표시기 크기
  final double circleSize;

  /// 텍스트 스타일
  final TextStyle? textStyle;

  /// 아이콘 (원형 대신 아이콘 사용 가능)
  final IconData? icon;

  /// 아이콘 크기
  final double? iconSize;

  /// 원형과 텍스트/아이콘 사이의 간격
  final double spacing;

  /// 툴팁 텍스트 (null이면 자동 툴팁 또는 툴팁 없음)
  final String? tooltip;

  /// 배경 모양 (원형, 사각형, 라운드 사각형 등)
  final ShapeBorder? shape;

  /// 배경 패딩
  final EdgeInsets? padding;

  const StatusConfig({
    required this.color,
    this.text,
    this.circleSize = 8.0,
    this.textStyle,
    this.icon,
    this.iconSize,
    this.spacing = 6.0,
    this.tooltip,
    this.shape,
    this.padding,
  }) : assert(circleSize >= 0, 'circleSize must be non-negative');

  /// 간단한 원형 + 텍스트 설정
  factory StatusConfig.simple({
    required Color color,
    required String text,
    double circleSize = 8.0,
    TextStyle? textStyle,
    double spacing = 6.0,
    String? tooltip,
  }) {
    return StatusConfig(
      color: color,
      text: text,
      circleSize: circleSize,
      textStyle: textStyle,
      spacing: spacing,
      tooltip: tooltip,
    );
  }

  /// 원형만 있는 설정 (텍스트 없음)
  factory StatusConfig.circleOnly({
    required Color color,
    double circleSize = 8.0,
    String? tooltip,
    ShapeBorder? shape,
    EdgeInsets? padding,
  }) {
    return StatusConfig(
      color: color,
      text: null,
      circleSize: circleSize,
      tooltip: tooltip,
      shape: shape,
      padding: padding,
    );
  }

  /// 아이콘 + 텍스트 설정
  factory StatusConfig.withIcon({
    required Color color,
    required IconData icon,
    String? text,
    double iconSize = 16.0,
    TextStyle? textStyle,
    double spacing = 6.0,
    String? tooltip,
    EdgeInsets? padding,
  }) {
    return StatusConfig(
      color: color,
      text: text,
      icon: icon,
      iconSize: iconSize,
      textStyle: textStyle,
      spacing: spacing,
      tooltip: tooltip,
      padding: padding,
      circleSize: 0, // 아이콘을 사용하므로 원형은 숨김
    );
  }

  /// 텍스트만 있는 설정 (원형/아이콘 없음)
  factory StatusConfig.textOnly({
    required String text,
    required Color color,
    TextStyle? textStyle,
    String? tooltip,
    EdgeInsets? padding,
  }) {
    return StatusConfig(
      color: color,
      text: text,
      textStyle: textStyle,
      tooltip: tooltip,
      padding: padding,
      circleSize: 0, // 원형 숨김
      spacing: 0, // 간격 없음
    );
  }

  /// 배지 스타일 설정 (배경색이 있는 라운드 사각형)
  factory StatusConfig.badge({
    required Color color,
    required String text,
    Color? textColor,
    double fontSize = 12.0,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    double borderRadius = 12.0,
    String? tooltip,
  }) {
    return StatusConfig(
      color: Colors.transparent, // 원형은 투명
      text: text,
      textStyle: TextStyle(
        color: textColor ?? Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
      ),
      tooltip: tooltip,
      circleSize: 0, // 원형 숨김
      spacing: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
    );
  }

  /// 표시할 색상 계산 (아이콘이나 배지 배경색 등에 사용)
  Color get effectiveColor => color;

  /// 텍스트 표시 여부
  bool get hasText => text != null && text!.isNotEmpty;

  /// 원형 표시 여부
  bool get hasCircle => circleSize > 0 && icon == null;

  /// 아이콘 표시 여부
  bool get hasIcon => icon != null;

  /// 배경 모양 사용 여부
  bool get hasShape => shape != null;

  /// 패딩 사용 여부
  bool get hasPadding => padding != null;

  StatusConfig copyWith({
    Color? color,
    String? text,
    double? circleSize,
    TextStyle? textStyle,
    IconData? icon,
    double? iconSize,
    double? spacing,
    String? tooltip,
    ShapeBorder? shape,
    EdgeInsets? padding,
  }) {
    return StatusConfig(
      color: color ?? this.color,
      text: text ?? this.text,
      circleSize: circleSize ?? this.circleSize,
      textStyle: textStyle ?? this.textStyle,
      icon: icon ?? this.icon,
      iconSize: iconSize ?? this.iconSize,
      spacing: spacing ?? this.spacing,
      tooltip: tooltip ?? this.tooltip,
      shape: shape ?? this.shape,
      padding: padding ?? this.padding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StatusConfig &&
        other.color == color &&
        other.text == text &&
        other.circleSize == circleSize &&
        other.textStyle == textStyle &&
        other.icon == icon &&
        other.iconSize == iconSize &&
        other.spacing == spacing &&
        other.tooltip == tooltip &&
        other.shape == shape &&
        other.padding == padding;
  }

  @override
  int get hashCode {
    return Object.hash(
      color,
      text,
      circleSize,
      textStyle,
      icon,
      iconSize,
      spacing,
      tooltip,
      shape,
      padding,
    );
  }

  @override
  String toString() {
    return 'StatusConfig('
        'color: $color, '
        'text: $text, '
        'circleSize: $circleSize, '
        'hasIcon: $hasIcon, '
        'hasShape: $hasShape'
        ')';
  }
}
