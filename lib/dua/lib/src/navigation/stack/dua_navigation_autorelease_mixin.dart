import '../../appstructure/dio.dart';

mixin DuaNavigationAutoReleaseMixin {
  bool __autoReleaseResourceInjected = false;

  /// implementation required
  List makeAutoReleaseResource();

  void loadNavigationAutoRelease() {
    if (__autoReleaseResourceInjected) return;
    __autoReleaseResourceInjected = true;
    for (var o in makeAutoReleaseResource()) {
      Dio.put(o, tag: o.runtimeType.toString());
    }
  }

  void disposeNavigationAutoRelease() {
    if (__autoReleaseResourceInjected) {
      for (var o in makeAutoReleaseResource()) {
        Dio.remove(o.runtimeType.toString());
      }
    }
  }
}
