import 'package:flutter/material.dart';

/// 테마 관련 유틸리티 클래스
///
/// 딱 필요한 스타일 병합 기능만 제공합니다.
class ThemeUtils {
  ThemeUtils._(); // private 생성자 (유틸리티 클래스)

  /// 두 TextStyle을 안전하게 병합합니다.
  ///
  /// [baseStyle]: 기본 스타일 (null 가능)
  /// [overrideStyle]: 덮어쓸 스타일 (null 가능)
  ///
  /// 반환: 병합된 TextStyle (null일 수 있음)
  static TextStyle? mergeTextStyles(
      TextStyle? baseStyle, TextStyle? overrideStyle) {
    if (baseStyle == null && overrideStyle == null) return null;
    if (baseStyle == null) return overrideStyle;
    if (overrideStyle == null) return baseStyle;

    return baseStyle.merge(overrideStyle);
  }

  /// EdgeInsets를 안전하게 병합합니다.
  ///
  /// [basePadding]: 기본 패딩 (null 가능)
  /// [overridePadding]: 덮어쓸 패딩 (null 가능)
  ///
  /// 반환: 병합된 EdgeInsets (null일 수 있음)
  static EdgeInsets? mergeEdgeInsets(
      EdgeInsets? basePadding, EdgeInsets? overridePadding) {
    if (basePadding == null && overridePadding == null) return null;
    if (basePadding == null) return overridePadding;
    if (overridePadding == null) return basePadding;

    // 덮어쓰기 방식으로 병합
    return overridePadding;
  }
}
