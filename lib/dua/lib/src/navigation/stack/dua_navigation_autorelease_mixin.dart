import '../../appstructure/dio.dart';

mixin DuaNavigationAutoReleaseMixin {
  bool __autoReleaseResourceInjected = false;

  /// implementation required
  List makeAutoReleaseResource();

  void loadNavigationAutoRelease() {
    if (__autoReleaseResourceInjected) return;
    __autoReleaseResourceInjected = true;
    for (var o in makeAutoReleaseResource()) {
      Dio.put(o, tag: "auto_${o.runtimeType}");
    }
  }

  void disposeNavigationAutoRelease() {
    if (__autoReleaseResourceInjected) {
      for (var o in makeAutoReleaseResource()) {
        Dio.remove("auto_${o.runtimeType}");
      }
    }
  }

  T find<T>(){
    return Dio.find("auto_$T");
  }
}
