// lib/src/widgets/generic_status_indicator.dart
import 'package:flutter/material.dart';

import '../models/status_config.dart';

/// Generic 상태 표시기 위젯
/// 사용자 정의 상태 타입과 StatusConfig를 받아서 렌더링합니다.
class GenericStatusIndicator extends StatelessWidget {
  /// 상태 값 (사용자 정의 enum 등)
  final Enum status;

  /// 상태 설정 (색상, 텍스트, 스타일 등)
  final StatusConfig config;

  /// 레이아웃 방향 (가로/세로)
  final Axis direction;

  /// 정렬 방식
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const GenericStatusIndicator({
    super.key,
    required this.status,
    required this.config,
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  /// 간단한 가로 레이아웃 팩토리
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

  /// 세로 레이아웃 팩토리
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

  /// 원형 표시기 위젯
  Widget _buildCircle() {
    if (!config.hasCircle) return const SizedBox.shrink();

    return Container(
      width: config.circleSize,
      height: config.circleSize,
      decoration: BoxDecoration(
        color: config.effectiveColor,
        shape: BoxShape.circle,
      ),
    );
  }

  /// 아이콘 위젯
  Widget _buildIcon() {
    if (!config.hasIcon) return const SizedBox.shrink();

    return Icon(
      config.icon!,
      size: config.iconSize ?? 16.0,
      color: config.effectiveColor,
    );
  }

  /// 텍스트 위젯
  Widget _buildText() {
    if (!config.hasText) return const SizedBox.shrink();

    return Text(
      config.text!,
      style: config.textStyle ?? const TextStyle(fontSize: 13),
    );
  }

  /// 간격 위젯
  Widget _buildSpacing() {
    // 표시할 요소가 2개 이상이고 spacing > 0일 때만 간격 추가
    final hasMultipleElements = [
          config.hasCircle,
          config.hasIcon,
          config.hasText,
        ].where((has) => has).length >
        1;

    if (!hasMultipleElements || config.spacing <= 0) {
      return const SizedBox.shrink();
    }

    return direction == Axis.horizontal
        ? SizedBox(width: config.spacing)
        : SizedBox(height: config.spacing);
  }

  /// 콘텐츠 위젯들을 빌드
  List<Widget> _buildContentWidgets() {
    final widgets = <Widget>[];

    // 원형 또는 아이콘 추가
    if (config.hasCircle) {
      widgets.add(_buildCircle());
    } else if (config.hasIcon) {
      widgets.add(_buildIcon());
    }

    // 간격 추가 (앞에 요소가 있고 뒤에 텍스트가 있을 때)
    if (widgets.isNotEmpty && config.hasText) {
      widgets.add(_buildSpacing());
    }

    // 텍스트 추가
    if (config.hasText) {
      widgets.add(_buildText());
    }

    return widgets;
  }

  /// 배경 모양이 있는 콘텐츠 래핑
  Widget _wrapWithShape(Widget child) {
    if (!config.hasShape) return child;

    return Container(
      padding: config.padding,
      decoration: ShapeDecoration(
        color: config.effectiveColor,
        shape: config.shape!,
      ),
      child: child,
    );
  }

  /// 패딩이 있는 콘텐츠 래핑 (배경 모양이 없을 때)
  Widget _wrapWithPadding(Widget child) {
    if (!config.hasPadding || config.hasShape) return child;

    return Padding(
      padding: config.padding!,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final contentWidgets = _buildContentWidgets();

    if (contentWidgets.isEmpty) {
      return const SizedBox.shrink();
    }

    Widget content;

    if (direction == Axis.horizontal) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: contentWidgets,
      );
    } else {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: contentWidgets,
      );
    }

    // 배경 모양이나 패딩 적용
    content = _wrapWithShape(content);
    content = _wrapWithPadding(content);

    // 툴팁 적용
    if (config.tooltip != null && config.tooltip!.isNotEmpty) {
      content = Tooltip(
        message: config.tooltip!,
        child: content,
      );
    }

    return content;
  }
}

/// 편의를 위한 Enum 확장 메서드들
extension GenericStatusIndicatorExtensions on Enum {
  /// 이 상태 값으로 상태 표시기 생성
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

  /// 가로 레이아웃 상태 표시기 생성
  GenericStatusIndicator toHorizontalStatusIndicator(StatusConfig config) {
    return GenericStatusIndicator.horizontal(this, config);
  }

  /// 세로 레이아웃 상태 표시기 생성
  GenericStatusIndicator toVerticalStatusIndicator(StatusConfig config) {
    return GenericStatusIndicator.vertical(this, config);
  }
}
