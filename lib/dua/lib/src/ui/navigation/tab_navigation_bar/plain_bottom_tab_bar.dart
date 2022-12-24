import 'dart:ui';

import 'package:flutter/material.dart';

// 获取导航栏高度
double usePlainBottomTabBarHeight(BuildContext context) {
  return MediaQuery.of(context).viewPadding.bottom + 56;
}

class PlainBottomTabBarItem {
  final Widget icon;
  final String label;

  PlainBottomTabBarItem({required this.icon, required this.label});
}

class _PlainBottomTabBarItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final bool isActive;
  final void Function()? onTap;
  final Widget Function(String label, bool isFocused)? renderLabelWidget;
  final Color color;
  final Color hintColor;
  final Color labelColor;
  final Color labelHintColor;

  _PlainBottomTabBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.color,
    required this.hintColor,
    required this.labelColor,
    required this.labelHintColor,
    this.onTap,
    this.renderLabelWidget,
  });

  Widget _renderLabelWidget() {
    if (renderLabelWidget != null) return renderLabelWidget!(label, isActive);
    return Text(label, style: const TextStyle(color: Color(0xFF000000)));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Opacity(
        opacity: isActive ? 1.0 : 0.39,
        child: GestureDetector(
          onTap: onTap,
          child: SizedBox.expand(
            child: Container(
              color: Colors.white.withOpacity(0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  _renderLabelWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlainBottomTabBar extends StatefulWidget {
  final List<BoxShadow> defaultShadow = const [BoxShadow(color: Color(0x22000000), spreadRadius: 2, blurRadius: 12)];
  final Color defaultColor = const Color(0xFF000000).withOpacity(0.39);
  final Color defaultHintColor = const Color(0XFF000000);
  final Color defaultBackground = const Color(0xFFFFFFFF);
  PlainBottomTabBar({
    required this.tabs,
    required this.index,
    required this.onChangeIndex,
    this.enableShadow,
    this.color,
    this.hintColor,
    this.labelColor,
    this.labelHintColor,
    this.backgroundColor,
    this.height,
    this.renderLabelWidget,
  });

  List<PlainBottomTabBarItem> tabs;
  int index;
  void Function(int index) onChangeIndex;
  bool? enableShadow;
  Color? backgroundColor;
  Color? color;
  Color? hintColor;
  Color? labelColor;
  Color? labelHintColor;
  double? height;
  final Widget Function(String label, bool isFocused)? renderLabelWidget;

  Color get _color => color ?? defaultColor;
  Color get _hintColor => hintColor ?? defaultHintColor;
  Color get _labelColor => labelColor ?? defaultColor;
  Color get _labelHintColor => labelHintColor ?? defaultHintColor;
  Color get _backgroundColor => backgroundColor ?? defaultBackground;

  @override
  PlainBottomTabBarState createState() => PlainBottomTabBarState();
}

class PlainBottomTabBarState extends State<PlainBottomTabBar> {
  @override
  Widget build(BuildContext context) {
    var insets = MediaQuery.of(context).viewPadding;
    var height = widget.height != null ? (widget.height! + insets.bottom) : usePlainBottomTabBarHeight(context);
    return Container(
      constraints: BoxConstraints(maxHeight: height),
      height: height,
      decoration: BoxDecoration(
        boxShadow: (widget.enableShadow ?? true) ? widget.defaultShadow : null,
        color: widget._backgroundColor,
      ),
      padding: EdgeInsets.only(bottom: insets.bottom),
      child: SizedBox.expand(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var i = 0; i < widget.tabs.length; i++)
              _PlainBottomTabBarItem(
                onTap: () {
                  widget.onChangeIndex(i);
                },
                icon: widget.tabs[i].icon,
                label: widget.tabs[i].label,
                isActive: widget.index == i,
                color: widget._color,
                hintColor: widget._hintColor,
                labelColor: widget._labelColor,
                labelHintColor: widget._labelHintColor,
                renderLabelWidget: widget.renderLabelWidget,
              )
          ],
        ),
      ),
    );
  }
}
