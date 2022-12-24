import 'package:flutter/material.dart';
import '../empty.dart';
import '../visible.dart';

class BasePlainListItem extends StatelessWidget {
  const BasePlainListItem({
    super.key,
    this.image,
    this.label,
    this.labelWidget,
    this.rightWidget,
    this.height,
    this.useTopBorder,
    this.useBotBorder,
    this.borderColor,
    this.borderHeight,
    this.centerPadding,
  });

  final Widget? image;
  final String? label;
  final Widget? labelWidget;
  final Widget? rightWidget;
  final double? height;
  final bool? useTopBorder;
  final bool? useBotBorder;
  final Color? borderColor;
  final double? borderHeight;
  final EdgeInsets? centerPadding;

  bool get _useTopBorder => useTopBorder ?? false;
  bool get _useBotBorder => useBotBorder ?? false;
  Color get _borderColor => borderColor ?? const Color(0xFFf3f3f3);
  double get _borderHeight => borderHeight ?? 1;
  EdgeInsets get _centerPadding => centerPadding ?? const EdgeInsets.symmetric(vertical: 8.0);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        image ?? empty(),
        Expanded(
          child: SizedBox(
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(height: _borderHeight, color: _borderColor).visible(_useTopBorder),
                Padding(
                  padding: _centerPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildLabelWidget(),
                      rightWidget ?? empty(),
                    ],
                  ),
                ),
                Container(height: _borderHeight, color: _borderColor).visible(_useBotBorder),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLabelWidget() {
    if (labelWidget != null) {
      return labelWidget!;
    }
    return Text(
      label ?? "",
      style: const TextStyle(color: Colors.black, fontSize: 15),
    );
  }
}
