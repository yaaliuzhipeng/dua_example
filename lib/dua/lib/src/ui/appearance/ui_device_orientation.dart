import 'package:flutter/services.dart';

class UIDeviceOrientation {
  static void lockToPortrait() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
  }

  static void lockToPortraitUpDown() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  static void lockToLandscapeRight() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.landscapeRight]);
  }

  static void lockToLandscapeLeft() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.landscapeLeft]);
  }

  static void lockToLandscape() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  static void unlockOrientation() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  static void setDeviceOrientation(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }
}
