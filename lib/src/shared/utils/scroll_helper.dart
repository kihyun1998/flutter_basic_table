import 'package:flutter/material.dart';

/// 스크롤 관련 유틸리티 클래스
///
/// 딱 필요한 스크롤 동기화 기능만 제공합니다.
class ScrollHelper {
  ScrollHelper._(); // private 생성자 (유틸리티 클래스)

  /// 두 스크롤 컨트롤러를 동기화합니다.
  ///
  /// [primary]: 주 스크롤 컨트롤러 (사용자 상호작용 대상)
  /// [secondary]: 보조 스크롤 컨트롤러 (동기화 대상)
  /// [preventCascade]: 무한 루프 방지를 위한 플래그 맵
  ///
  /// 반환: 리스너 제거를 위한 VoidCallback
  static VoidCallback syncScrollControllers(
    ScrollController primary,
    ScrollController secondary,
    Map<ScrollController, bool> preventCascade,
  ) {
    void primaryListener() {
      _jumpToNoCascade(primary, secondary, preventCascade);
    }

    void secondaryListener() {
      _jumpToNoCascade(secondary, primary, preventCascade);
    }

    primary.addListener(primaryListener);
    secondary.addListener(secondaryListener);

    // 리스너 제거를 위한 콜백 반환
    return () {
      primary.removeListener(primaryListener);
      secondary.removeListener(secondaryListener);
    };
  }

  /// 무한 루프 없이 스크롤 위치를 동기화하는 내부 함수
  static void _jumpToNoCascade(
    ScrollController source,
    ScrollController target,
    Map<ScrollController, bool> preventCascade,
  ) {
    if (!source.hasClients || !target.hasClients) {
      return;
    }

    // target이 스크롤 범위를 벗어났는지 확인
    if (target.position.outOfRange) {
      return;
    }

    final cascadeFlag = preventCascade[source];
    if (cascadeFlag == null || cascadeFlag == false) {
      preventCascade[target] = true;
      target.jumpTo(source.offset);
    } else {
      preventCascade[source] = false;
    }
  }
}
