import './opacity_touchable.dart';
import '../empty.dart';
import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  SimpleButton({
    this.title,
    this.titleStyle,
    this.icon,
    this.backgroundColor,
    this.padding,
    this.radius,
    this.mainAxisAlignment,
    this.size,
    this.isIconOnStart,
    this.opacity,
    this.onTap,
  });

  final String? title;
  final TextStyle? titleStyle;
  final Widget? icon;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final double? radius;
  final MainAxisAlignment? mainAxisAlignment;
  final Size? size;
  final bool? isIconOnStart;
  final double? opacity;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size?.height,
      width: size?.width,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFF000000),
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 0)),
      ),
      child: Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: buildTextIcon(),
      ),
    ).touchableOpacity(onTap, opacity);
  }

  buildTextIcon() {
    var ic = icon ?? empty();
    List<Widget> ws = [Text(title ?? "", style: titleStyle ?? const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))];
    if (isIconOnStart == true) {
      ws.insert(0, ic);
    } else {
      ws.add(ic);
    }
    return ws;
  }
}
