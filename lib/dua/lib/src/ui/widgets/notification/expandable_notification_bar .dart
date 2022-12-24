import '../empty.dart';
import './base_notification_bar.dart';
import 'package:flutter/material.dart';

import '../../animation/size_height_expand_transition.dart';

class ExpandableNotificationBar extends StatelessWidget {
  ExpandableNotificationBar({
    super.key,
    this.useBlurEffect,
    this.headerIcon,
    this.headerTitle,
    this.headerEnd,
    this.title,
    this.body,
    this.headerTitleWidget,
    this.titleWidget,
    this.bodyWidget,
    this.radius,
    this.expandContent,
    this.expandTransitionController,
    this.accessors,
    this.textContentPadding,
    this.padding,
  });

  final bool? useBlurEffect;
  final Widget? headerIcon;
  final String? headerTitle;
  final Widget? headerEnd;
  final String? title;
  final String? body;
  final Widget? headerTitleWidget;
  final Widget? titleWidget;
  final Widget? bodyWidget;
  final double? radius;
  final Widget? expandContent;
  final SizeHeightExpandTransitionController? expandTransitionController;
  final List<Widget>? accessors;
  final EdgeInsets? textContentPadding;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
      child: BaseNotificationBar(
        useBlurEffect: useBlurEffect,
        radius: radius ?? 24,
        headerStartIcon: headerIcon,
        headerTitle: buildHeaderTitle(),
        headerEnd: headerEnd,
        title: buildTitle(),
        body: buildBody(),
        textContentPadding: textContentPadding,
        accessor: Column(children: [
          SizeHeightExpandTransition(
            controller: expandTransitionController,
            child: expandContent ?? empty(),
          ),
          ...(accessors ?? []),
        ]),
      ),
    );
  }

  Widget buildBody() {
    if (bodyWidget != null) return bodyWidget!;
    return Text(
      body ?? "",
      style: const TextStyle(color: Colors.black54, fontSize: 14),
    );
  }

  Widget buildTitle() {
    if (titleWidget != null) return titleWidget!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(title ?? "", style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget buildHeaderTitle() {
    if (headerTitleWidget != null) return headerTitleWidget!;
    return Padding(
      padding: EdgeInsets.only(left: headerIcon != null ? 6.0 : 0.0),
      child: Text(headerTitle ?? "", style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)),
    );
  }
}
