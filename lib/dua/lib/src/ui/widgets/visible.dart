import './empty.dart';
import 'package:flutter/Widgets.dart';

Widget visible(bool show, Widget child) {
  if (show) return child;
  return empty();
}

extension VisibleWidgetExtension on Widget {
  Widget visible(bool show) => show ? this : empty();
}
