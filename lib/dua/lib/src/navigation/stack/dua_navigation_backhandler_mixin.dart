import './dua_back_handler.dart';

mixin DuaNavigationBackHandlerMixin {
  bool __backHandlerLoaded = false;

  ///@return Future<bool>
  ///返回的结果决定最终返回行为
  Future<bool> onBackHandlerInvoked();

  loadNavigationBackHandler() {
    if (__backHandlerLoaded) return;
    __backHandlerLoaded = true;
    DuaBackHandler.shared.addInvoker(onBackHandlerInvoked);
  }

  disposeNavigationBackHandler() {
    if (__backHandlerLoaded) {
      DuaBackHandler.shared.pop();
      __backHandlerLoaded = false;
    }
  }
}
