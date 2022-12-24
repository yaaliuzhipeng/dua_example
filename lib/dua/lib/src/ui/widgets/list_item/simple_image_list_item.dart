import './base_plain_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SimpleImageListItem extends StatelessWidget {
  SimpleImageListItem({
    super.key,
    required this.image,
    this.label,
    this.labelWidget,
    this.rightWidget,
    this.hideRightWidget,
    this.margin,
    this.radius,
    this.backgroundColor,
    this.decoration,
    this.height,
  });
  final Widget image;
  final String? label;
  final Widget? labelWidget;
  final Widget? rightWidget;
  final bool? hideRightWidget;
  final EdgeInsets? margin;
  final double? radius;
  final Color? backgroundColor;
  final BoxDecoration? decoration;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: decoration ??
          BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
          ),
      child: BasePlainListItem(
        height: height ?? 46,
        image: image,
        label: label,
        rightWidget: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Icon(
            CupertinoIcons.chevron_right,
            color: Colors.black38,
            size: 18,
          ),
        ),
      ),
    );
  }
}
