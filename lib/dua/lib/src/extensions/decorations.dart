import 'package:flutter/widgets.dart';

extension DecorationExtension on double {
  ///
  BorderRadius radius({
    double? tl,
    double? tr,
    double? bl,
    double? br,
    double? ht,
    double? hb,
    double? vl,
    double? vr,
  }) {
    double rtl = ht ?? this;
    double rtr = ht ?? this;
    double rbl = hb ?? this;
    double rbr = hb ?? this;
    if (vl != null) {
      rtl = vl;
      rbl = vl;
    }
    if (vr != null) {
      rtr = vr;
      rbr = vr;
    }
    if (tl != null) rtl = tl;
    if (tr != null) rtr = tr;
    if (bl != null) rbl = bl;
    if (br != null) rbr = br;

    return BorderRadius.only(
      topLeft: Radius.circular(rtl),
      topRight: Radius.circular(rtr),
      bottomLeft: Radius.circular(rbl),
      bottomRight: Radius.circular(rbr),
    );
  }
}
