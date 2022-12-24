import 'package:flutter/material.dart';

class Adaptivity {
  static Adaptivity? _instance;
  static Adaptivity get shared => _instance ??= Adaptivity();

  late Size _base;
  late Size _actual;

  Adaptivity() {
    _base = const Size(375, 812);
    _actual = const Size(375, 812);
  }

  Size get dimension => _actual;

  setup({Size? actual, Size? base}) {
    if (actual != null) _actual = actual;
    if (base != null) _base = base;
  }

  dp(n) {
    return n * (_actual.width / _base.width);
  }
}

extension IntegerScreenAdaptive on int {
  double dp() => Adaptivity.shared.dp(this);
}

extension DoubleScreenAdaptive on double {
  double dp() => Adaptivity.shared.dp(this);
}
