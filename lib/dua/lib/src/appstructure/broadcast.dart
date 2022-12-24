import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
// import 'package:flutter/cupertino.dart';

/// Broadcast 事件订阅发布工具
///
/// emit 进行事件发送
/// addListener 进行事件订阅、返回取消函数

typedef ListenerInvoker = void Function(dynamic data);

class ListenerObject {
  ListenerObject(this.invoker) : uuid = const Uuid().v4();
  final String uuid;
  final ListenerInvoker invoker;
}

class B {
  static void emit(String event, dynamic data) {
    Broadcast.shared.emit(event, data);
  }

  static void addListener(
    String event,
    ListenerInvoker onData, {
    void Function()? onDone,
  }) {
    Broadcast.shared.addListener(event, onData, onDone: onDone);
  }

  static bool hasListeners(String event) {
    return Broadcast.shared.hasListeners(event);
  }
}

class Broadcast {
  static Broadcast? _instance;

  static Broadcast get shared => _instance ??= Broadcast();

  Broadcast() {
    debugPrint("===> Broadcast Constructing <===");
  }

  bool _debugLogEnabled = false;
  final Map<String, StreamController> _streamControllers = {};
  final Map<String, List<ListenerObject>> _streamListeners = {};

  void _log(String msg) {
    if (_debugLogEnabled) log("【Broadcast - ⚠️】$msg");
  }

  void openDebugLog() {
    _debugLogEnabled = true;
  }

  void emit(String event, dynamic data) {
    if (_streamControllers.containsKey(event)) {
      var c = _streamControllers[event];
      if (c != null && !c.isClosed) {
        c.sink.add(data);
      } else {
        _log("event => $event | Registered subscribe is closed anyway");
      }
    } else {
      _log("event => $event | There are no registered listeners");
    }
  }

  bool hasListeners(String event) {
    return (_streamListeners[event] ?? []).isNotEmpty;
  }

  /// @return close();
  addListener(
    String event,
    ListenerInvoker onData, {
    void Function()? onDone,
  }) {
    StreamController? c;
    ListenerObject? lo;
    bool requireListen = true;
    if (_streamControllers.containsKey(event)) {
      c = _streamControllers[event];
      if (c == null || c.isClosed) {
        c = StreamController.broadcast();
        _log("event => $event | event registered but not valid、recreating");
      } else {
        _log("event => $event | event is registered and in-using");
        requireListen = false;
      }
    } else {
      _log("event => $event | event registered");
      c = StreamController.broadcast();
    }
    _streamControllers[event] = c;
    lo = ListenerObject(onData);
    if (_streamListeners[event] == null) {
      _streamListeners[event] = [lo];
    } else {
      _streamListeners[event]!.add(lo);
    }
    if (requireListen) {
      c.stream.listen((data) {
        // notify all listeners
        for (ListenerObject sl in _streamListeners[event] ?? []) {
          sl.invoker(data);
        }
      }, onDone: onDone);
    }
    return ([bool? all]) {
      if (all == true) {
        _streamListeners[event] = [];
        if (c?.isClosed == false) {
          c?.close();
        }
      } else {
        for (ListenerObject sl in _streamListeners[event] ?? []) {
          if (sl.uuid == lo!.uuid) {
            _streamListeners[event]!.remove(sl);
            break;
          }
        }
      }
    };
  }
}
