import 'package:flutter/widgets.dart';

class Box extends StatelessWidget {
  const Box({super.key, this.w, this.h});
  final double? w;
  final double? h;
  double? get _w => w ?? 0;
  double? get _h => h ?? 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: _w, height: _h);
  }
}

extension BoxIntExtension on int {
  SizedBox box() => SizedBox(width: toDouble(), height: toDouble());
  SizedBox boxw([double? h]) => SizedBox(width: toDouble(), height: h ?? 0);
  SizedBox boxh([double? w]) => SizedBox(width: w ?? 0, height: toDouble());
}

extension BoxDoubleExtension on double {
  SizedBox box() => SizedBox(width: this, height: this);
  SizedBox boxw([double? h]) => SizedBox(width: this, height: h ?? 0);
  SizedBox boxh([double? w]) => SizedBox(width: w ?? 0, height: this);
}
