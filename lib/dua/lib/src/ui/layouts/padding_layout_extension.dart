import 'package:flutter/material.dart';

extension PaddingLayoutExtension on Widget {
  Padding p(double value) => Padding(padding: EdgeInsets.all(value), child: this);
  Padding pt(double value) => Padding(padding: EdgeInsets.only(top: value), child: this);
  Padding pr(double value) => Padding(padding: EdgeInsets.only(right: value), child: this);
  Padding pb(double value) => Padding(padding: EdgeInsets.only(bottom: value), child: this);
  Padding pl(double value) => Padding(padding: EdgeInsets.only(left: value), child: this);
  Padding pv(double value) => Padding(padding: EdgeInsets.symmetric(vertical: value), child: this);
  Padding ph(double value) => Padding(padding: EdgeInsets.symmetric(horizontal: value), child: this);
  Padding ps(double h, double v) => Padding(padding: EdgeInsets.symmetric(horizontal: h, vertical: v), child: this);
}
