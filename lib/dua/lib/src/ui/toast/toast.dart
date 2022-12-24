import 'dart:ui';
import 'package:flutter/material.dart';

import '../widgets/empty.dart';
import '../../extensions/decorations.dart';

class Toast extends StatelessWidget {
  const Toast({
    super.key,
    this.text,
    this.textWidget,
    this.backgroundColor,
  });

  final String? text;
  final Widget? textWidget;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (text == null && textWidget == null) return empty();
    return UnconstrainedBox(
      child: ClipRRect(
        borderRadius: 30.0.radius(),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(color: backgroundColor ?? Colors.white.withOpacity(0.58)),
            child: buildTextWidget(),
          ),
        ),
      ),
    );
  }

  Widget buildTextWidget() {
    if (textWidget != null) return textWidget!;
    return Text(
      text ?? "",
      style: const TextStyle(color: Colors.black, fontSize: 14),
      maxLines: 5,
    );
  }
}
