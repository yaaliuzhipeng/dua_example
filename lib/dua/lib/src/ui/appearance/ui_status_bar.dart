import 'package:flutter/services.dart';

class UIStatusBar {
  static void setImmersiveStatusBar() {
    SystemUiOverlayStyle style = const SystemUiOverlayStyle(
      statusBarColor: Color(0x00000000),
      systemNavigationBarColor: Color(0xFF000000),
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}
