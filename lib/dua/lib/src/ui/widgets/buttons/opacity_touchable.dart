import 'package:flutter/material.dart';

class TouchableOpacity extends StatefulWidget {
  TouchableOpacity({super.key, this.child, this.onTap, this.opacity});

  final Widget? child;
  final void Function()? onTap;
  final double? opacity;

  @override
  State<StatefulWidget> createState() => _TouchableOpacity();
}

class _TouchableOpacity extends State<TouchableOpacity> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation animation;

  double get opacity => widget.opacity ?? 0.56;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 80));
    animation = Tween(begin: 1.0, end: opacity).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (d) {
        controller.forward();
      },
      onTapUp: (d) {
        controller.reverse();
      },
      onTapCancel: () {
        controller.reverse();
      },
      onTap: widget.onTap,
      child: Opacity(
        opacity: animation.value,
        child: widget.child,
      ),
    );
  }
}

extension WidgetTouchableOpacity on Widget {
  TouchableOpacity touchableOpacity(void Function()? onTap, [double? opacity]) => TouchableOpacity(onTap: onTap, opacity: opacity, child: this);
}
