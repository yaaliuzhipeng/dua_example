import 'package:flutter/cupertino.dart';

class FadeInOutLayoutAnimationWidgetController {
  late void Function() forward;
  late void Function() reverse;
}

class FadeInOutLayoutAnimationWidget extends StatefulWidget {
  FadeInOutLayoutAnimationWidget({
    super.key,
    required this.visible,
    required this.child,
    bool? removeAfterOutAnimation,
    this.controller,
    int? duration,
    double? from,
    double? to,
  })  : duration = duration ?? 280,
        begin = from ?? 0,
        end = to ?? 1,
        removeAfterOutAnimation = removeAfterOutAnimation ?? false;

  final int duration;
  final Widget child;
  final bool visible;
  final double begin;
  final double end;
  final FadeInOutLayoutAnimationWidgetController? controller;
  final bool removeAfterOutAnimation;

  @override
  State<StatefulWidget> createState() => _FadeInOutLayoutAnimationWidget();
}

class _FadeInOutLayoutAnimationWidget extends State<FadeInOutLayoutAnimationWidget> with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration));
  late Animation<double> animation;
  late FadeInOutLayoutAnimationWidgetController _controller = widget.controller ?? FadeInOutLayoutAnimationWidgetController();
  bool visible = false;
  bool isMounted = true;

  @override
  void initState() {
    super.initState();
    animation = Tween<double>(begin: widget.begin, end: widget.end).animate(CurvedAnimation(parent: controller, curve: Curves.linear))
      ..addListener(() {
        if (controller.status == AnimationStatus.dismissed) {
          //完全隐藏了
          visible = false;
        }
        setState(() {});
      });
    _controller.forward = () {
      if (isMounted) {
        controller.forward();
        visible = true;
        setState(() {});
      }
    };
    _controller.reverse = () {
      if (isMounted) {
        controller.reverse();
      }
    };
  }

  @override
  void dispose() {
    isMounted = false;
    super.dispose();
    controller.clearListeners();
    controller.dispose();
  }

  @override
  void didUpdateWidget(covariant FadeInOutLayoutAnimationWidget oldWidget) {
    if (widget.visible && !visible) {
      visible = true;
      controller.forward();
      setState(() {});
    } else {
      controller.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: animation, child: widget.child);
  }
}

/// extensions on FadeInOutLayoutAnimationWidget
///

extension FadeInOutLayoutAnimationWidgetExtension on Widget {
  FadeInOutLayoutAnimationWidget fade({
    bool? visible,
    double? from,
    double? to,
    int? duration,
    bool? removeAfterOutAnimation,
  }) =>
      FadeInOutLayoutAnimationWidget(
        visible: visible ?? true,
        child: this,
        duration: duration,
        from: from,
        to: to,
        removeAfterOutAnimation: removeAfterOutAnimation,
      );
}
