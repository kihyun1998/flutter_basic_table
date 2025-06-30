import 'package:flutter/material.dart';

import '../enums/tooltip_position.dart';

/// 테이블에서 사용하기 위한 간단한 툴팁 위젯
///
/// 딱 필요한 기본 툴팁 기능만 제공합니다.
class CustomTooltip extends StatelessWidget {
  /// 툴팁에 표시할 메시지
  final String message;

  /// 툴팁을 적용할 자식 위젯
  final Widget child;

  /// 툴팁 위치 (auto, top, bottom)
  final TooltipPosition position;

  /// 활성화 여부
  final bool enabled;

  const CustomTooltip({
    super.key,
    required this.message,
    required this.child,
    this.position = TooltipPosition.auto,
    this.enabled = true,
  });

  /// position에 따른 preferBelow 값 계산
  bool get _preferBelow {
    switch (position) {
      case TooltipPosition.top:
        return false;
      case TooltipPosition.bottom:
        return true;
      case TooltipPosition.auto:
        return true; // Flutter가 자동으로 최적 위치 결정
    }
  }

  @override
  Widget build(BuildContext context) {
    // 비활성화된 경우 툴팁 없이 자식만 반환
    if (!enabled || message.isEmpty) {
      return child;
    }

    return Tooltip(
      message: message,
      preferBelow: _preferBelow,
      child: child,
    );
  }
}
