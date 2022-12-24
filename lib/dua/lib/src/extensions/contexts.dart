import 'dart:ui';

import 'package:flutter/widgets.dart';

extension CommonBuildContextExtension on BuildContext {
  ///
  EdgeInsets get safeAreaInsets => MediaQuery.of(this).viewPadding;

  ///
  double get keyboardAvoidingHeight => MediaQuery.of(this).viewInsets.bottom;

  ///
  Size get windowSize => MediaQuery.of(this).size;

  ///
  bool get isDark => MediaQuery.of(this).platformBrightness == Brightness.dark;
}
