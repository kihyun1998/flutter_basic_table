import 'package:flutter/material.dart';

/// 여러 ScrollController를 동기화해주는 위젯
/// 수직/수평 스크롤을 각각 메인 컨트롤러와 스크롤바 컨트롤러로 동기화합니다.
class SyncedScrollControllers extends StatefulWidget {
  const SyncedScrollControllers({
    super.key,
    required this.builder,
    this.scrollController,
    this.verticalScrollbarController,
    this.horizontalScrollController,
    this.horizontalScrollbarController,
  });

  final ScrollController? scrollController;
  final ScrollController? verticalScrollbarController;
  final ScrollController? horizontalScrollController;
  final ScrollController? horizontalScrollbarController;

  final Widget Function(
    BuildContext context,
    ScrollController verticalDataController,
    ScrollController verticalScrollbarController,
    ScrollController horizontalMainController,
    ScrollController horizontalScrollbarController,
  ) builder;

  @override
  State<SyncedScrollControllers> createState() =>
      _SyncedScrollControllersState();
}

class _SyncedScrollControllersState extends State<SyncedScrollControllers> {
  ScrollController? _sc11; // 메인 수직 (ListView 용)
  late ScrollController _sc12; // 수직 스크롤바
  ScrollController? _sc21; // 메인 수평 (헤더 & 데이터 공통)
  late ScrollController _sc22; // 수평 스크롤바

  // 각 컨트롤러에 대한 리스너들을 명확하게 관리하기 위한 Map
  final Map<ScrollController, VoidCallback> _listenersMap = {};

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void didUpdateWidget(SyncedScrollControllers oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disposeOrUnsubscribe();
    _initControllers();
  }

  @override
  void dispose() {
    _disposeOrUnsubscribe();
    super.dispose();
  }

  void _initControllers() {
    _doNotReissueJump.clear();

    // 수직 스크롤 컨트롤러 (메인, ListView 용)
    _sc11 = widget.scrollController ?? ScrollController();

    // 수평 스크롤 컨트롤러 (메인, 헤더와 데이터 영역의 가로 스크롤 공통)
    _sc21 = widget.horizontalScrollController ?? ScrollController();

    // 수직 스크롤바 컨트롤러
    _sc12 = widget.verticalScrollbarController ??
        ScrollController(
          initialScrollOffset: _sc11!.hasClients && _sc11!.positions.isNotEmpty
              ? _sc11!.offset
              : 0.0,
        );

    // 수평 스크롤바 컨트롤러
    _sc22 = widget.horizontalScrollbarController ??
        ScrollController(
          initialScrollOffset: _sc21!.hasClients && _sc21!.positions.isNotEmpty
              ? _sc21!.offset
              : 0.0,
        );

    // 각 쌍의 컨트롤러를 동기화합니다.
    _syncScrollControllers(_sc11!, _sc12);
    _syncScrollControllers(_sc21!, _sc22);
  }

  void _disposeOrUnsubscribe() {
    // 모든 리스너 제거
    _listenersMap.forEach((controller, listener) {
      controller.removeListener(listener);
    });
    _listenersMap.clear();

    // 위젯에서 제공된 컨트롤러가 아니면 직접 dispose
    if (widget.scrollController == null) _sc11?.dispose();
    if (widget.horizontalScrollController == null) _sc21?.dispose();
    if (widget.verticalScrollbarController == null) _sc12.dispose();
    if (widget.horizontalScrollbarController == null) _sc22.dispose();
  }

  final Map<ScrollController, bool> _doNotReissueJump = {};

  void _syncScrollControllers(ScrollController master, ScrollController slave) {
    // 마스터 컨트롤러에 리스너 추가
    masterListener() => _jumpToNoCascade(master, slave);
    master.addListener(masterListener);
    _listenersMap[master] = masterListener;

    // 슬레이브 컨트롤러에 리스너 추가
    slaveListener() => _jumpToNoCascade(slave, master);
    slave.addListener(slaveListener);
    _listenersMap[slave] = slaveListener;
  }

  void _jumpToNoCascade(ScrollController master, ScrollController slave) {
    if (!master.hasClients || !slave.hasClients || slave.position.outOfRange) {
      return;
    }

    if (_doNotReissueJump[master] == null ||
        _doNotReissueJump[master]! == false) {
      _doNotReissueJump[slave] = true;
      slave.jumpTo(master.offset);
    } else {
      _doNotReissueJump[master] = false;
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        _sc11!,
        _sc12,
        _sc21!,
        _sc22,
      );
}
