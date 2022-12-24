import '../../appstructure/broadcast.dart';
import 'package:flutter/widgets.dart';

const String DUA_NAVIGATION_FOCUS_EVENT = "DUA_NAVIGATION_FOCUS_EVENT";
mixin DuaNavigationFocusMixin {
  bool __focused = false;
  void Function()? unsubscribe;

  void _unsubscribe() {
    if (unsubscribe != null) unsubscribe!();
    unsubscribe = null;
  }

  void loadNavigationFocus() {
    _unsubscribe();
    unsubscribe = Broadcast.shared.addListener(DUA_NAVIGATION_FOCUS_EVENT, (routename) {
      if (routename == name()) {
        onFocusChanged(true);
        __focused = true;
      } else {
        if (__focused) {
          onFocusChanged(false);
          __focused = false;
        }
      }
    });
  }

  void disposeNavigationFocus() {
    _unsubscribe();
  }

  ///required
  String name();

  /// required
  void onFocusChanged(bool focused);
}
mixin DuaNavigationFocusEmitterMixin {
  void dispatchFocus(String route) {
    WidgetsBinding.instance.addPostFrameCallback((t) {
      Broadcast.shared.emit(DUA_NAVIGATION_FOCUS_EVENT, route);
    });
  }
}
