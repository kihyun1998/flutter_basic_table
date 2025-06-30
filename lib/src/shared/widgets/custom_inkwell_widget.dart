import 'dart:async';

import 'package:flutter/material.dart';

/// 간단한 클릭 상호작용을 제공하는 커스텀 InkWell 위젯
///
/// 딱 필요한 클릭 기능만 제공합니다.
class CustomInkWell extends StatefulWidget {
  /// 자식 위젯
  final Widget child;

  /// 일반 클릭 콜백
  final VoidCallback? onTap;

  /// 더블클릭 콜백
  final VoidCallback? onDoubleTap;

  /// 우클릭 (보조 클릭) 콜백
  final VoidCallback? onSecondaryTap;

  /// 더블클릭 인식 시간
  final Duration doubleClickTime;

  /// 스플래시 색상
  final Color? splashColor;

  /// 하이라이트 색상
  final Color? highlightColor;

  /// 모서리 둥글기
  final BorderRadius? borderRadius;

  const CustomInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onSecondaryTap,
    this.doubleClickTime = const Duration(milliseconds: 300),
    this.splashColor,
    this.highlightColor,
    this.borderRadius,
  });

  @override
  State<CustomInkWell> createState() => _CustomInkWellState();
}

class _CustomInkWellState extends State<CustomInkWell> {
  int _clickCount = 0;
  Timer? _timer;

  void _handleTap() {
    _clickCount++;

    if (_clickCount == 1) {
      // 첫 번째 클릭 - 즉시 처리 (지연 없음!)
      widget.onTap?.call();

      if (widget.onDoubleTap != null) {
        // 더블클릭 콜백이 있으면 타이머 시작
        _timer = Timer(widget.doubleClickTime, () {
          _clickCount = 0;
        });
      } else {
        _clickCount = 0;
      }
    } else if (_clickCount == 2) {
      // 두 번째 클릭 - 더블클릭 처리
      _timer?.cancel();
      widget.onDoubleTap?.call();
      _clickCount = 0;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTap: widget.onSecondaryTap,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (widget.onTap != null || widget.onDoubleTap != null)
              ? _handleTap
              : null,
          splashColor: widget.splashColor,
          highlightColor: widget.highlightColor,
          borderRadius: widget.borderRadius,
          child: widget.child,
        ),
      ),
    );
  }
}
