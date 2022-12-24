import 'dart:ui';
import 'package:flutter/material.dart';
import '../empty.dart';

class BaseNotificationBar extends StatefulWidget {
  const BaseNotificationBar({
    super.key,
    this.headerStartIcon,
    this.headerTitle,
    this.headerEnd,
    this.title,
    this.body,
    this.accessor,
    this.textContentPadding,
    this.radius,
    this.useBlurEffect,
  });

  final Widget? headerStartIcon;
  final Widget? headerTitle;
  final Widget? headerEnd;
  final Widget? title;
  final Widget? body;
  final Widget? accessor;
  final EdgeInsets? textContentPadding;
  final double? radius;
  final bool? useBlurEffect;

  final EdgeInsets defaultTextContentPadding = const EdgeInsets.only(left: 3.0, top: 6.0);

  @override
  State<StatefulWidget> createState() => _BaseNotificationBar();
}

class _BaseNotificationBar extends State<BaseNotificationBar> {
  bool get useBlurEffect => widget.useBlurEffect ?? true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 0)),
      child: buildOptionalBlurContent(),
    );
  }

  Widget buildOptionalBlurContent() {
    if (useBlurEffect) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: buildContentView(),
      );
    }
    return buildContentView();
  }

  Container buildContentView() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      color: Colors.white.withOpacity(0.72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [widget.headerStartIcon ?? empty(), widget.headerTitle ?? empty()]),
              widget.headerEnd ?? empty(),
            ],
          ),
          Padding(
            padding: widget.textContentPadding ?? widget.defaultTextContentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [widget.title ?? empty(), widget.body ?? empty()],
            ),
          ),
          widget.accessor ?? empty()
        ],
      ),
    );
  }
}
