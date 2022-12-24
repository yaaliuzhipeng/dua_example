import '../../appstructure/dio.dart';

mixin DuaNavigationAutoReleaseMixin {
  bool _autoReleaseResourceInjected = false;
  List makeAutoReleaseResource();

  void loadNavigationAutoRelease() {
    if (_autoReleaseResourceInjected) return;
    _autoReleaseResourceInjected = true;
    for (var o in makeAutoReleaseResource()) {
      Dio.put(o, tag: o.runtimeType.toString());
    }
  }

  void disposeNavigationAutoRelease() {
    if (_autoReleaseResourceInjected) {
      for (var o in makeAutoReleaseResource()) {
        Dio.remove(o.runtimeType.toString());
      }
    }
  }
}
