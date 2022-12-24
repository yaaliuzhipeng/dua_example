import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../extensions/contexts.dart';

class PlainNavigationBar extends StatelessWidget {
  PlainNavigationBar({
    super.key,
    this.backIcon,
    this.leftAccessors,
    this.rightAccessors,
    this.title,
    this.onPressBack,
    this.height,
  });

  Widget? backIcon;
  List<Widget>? rightAccessors;
  List<Widget>? leftAccessors;
  Widget Function(String title)? renderTitle;
  final String? title;
  void Function()? onPressBack;
  double? height;

  @override
  Widget build(BuildContext context) {
    var insets = context.safeAreaInsets;
    return Container(
      padding: EdgeInsets.only(top: insets.top),
      height: (height ?? 46) + insets.top,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0x10000000), blurRadius: 5, spreadRadius: 2, offset: Offset(0, 0)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onPressBack,
                  child: backIcon ?? buildDefaultBackIcon(),
                ),
                ...(leftAccessors ?? [])
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Center(child: renderTitle != null ? renderTitle!(title ?? '') : buildDefaultTitle(title ?? '')),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [...(rightAccessors ?? [])],
            ),
          ),
        ],
      ),
    );
  }

  Text buildDefaultTitle(String title) => Text(title, style: const TextStyle(fontSize: 18, color: Colors.black));

  Padding buildDefaultBackIcon() {
    return const Padding(
      padding: EdgeInsets.only(left: 15),
      child: Icon(
        CupertinoIcons.chevron_left,
        size: 22,
        color: Colors.black,
      ),
    );
  }
}
