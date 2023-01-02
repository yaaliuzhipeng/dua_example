import 'package:flutter/Widgets.dart';

class SlideInAnimationWidgetController {
  late void Function() forward;
  late void Function() reverse;
}

class SlideInOutLayoutAnimationWidget extends StatefulWidget {
  SlideInOutLayoutAnimationWidget({
    super.key,
    required this.visible,
    required this.child,
    bool? removeAfterOutAnimation,
    this.controller,
    int? duration,
    Curve? curve,
    Curve? reverseCurve,
    Offset? from,
    Offset? to,
    this.onExited,
  })  : duration = duration ?? 280,
        curve = curve ?? Curves.decelerate,
        reverseCurve = reverseCurve ?? Curves.decelerate,
        begin = from ?? const Offset(0, 1),
        end = to ?? const Offset(0, 0),
        removeAfterOutAnimation = removeAfterOutAnimation ?? false;

  final int duration;
  final Curve curve;
  final Curve reverseCurve;
  final Widget child;
  final bool visible;
  final Offset begin;
  final Offset end;
  final SlideInAnimationWidgetController? controller;
  final bool removeAfterOutAnimation;
  final void Function()? onExited;

  @override
  State<StatefulWidget> createState() => _CurveSlideInOutLayoutAnimationWidget();
}

class _CurveSlideInOutLayoutAnimationWidget extends State<SlideInOutLayoutAnimationWidget> with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration));
  late Animation<Offset> offset;
  late SlideInAnimationWidgetController _controller = widget.controller ?? SlideInAnimationWidgetController();
  bool visible = false;
  bool isMounted = true;

  @override
  void initState() {
    super.initState();
    offset = Tween<Offset>(begin: widget.begin, end: widget.end).animate(CurvedAnimation(parent: controller, curve: widget.curve, reverseCurve: widget.reverseCurve))
      ..addListener(() {
        if (controller.status == AnimationStatus.dismissed) {
          //完全隐藏了
          visible = false;
          if (widget.onExited != null) widget.onExited!();
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
    controller.dispose();
  }

  @override
  void didUpdateWidget(covariant SlideInOutLayoutAnimationWidget oldWidget) {
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
    if (widget.removeAfterOutAnimation && !visible) return const SizedBox(width: 0, height: 0);
    return SlideTransition(
      position: offset,
      child: widget.child,
    );
  }
}

/// @direction [bottom to up]
///
class SlideInDownLayoutAnimationWidget extends StatelessWidget {
  SlideInDownLayoutAnimationWidget({
    required this.visible,
    required this.child,
    this.duration,
    this.curve,
    this.reverseCurve,
    this.controller,
    this.removeAfterOutAnimation,
    this.onExited,
  });

  final bool visible;
  final Widget child;
  final Curve? curve;
  final Curve? reverseCurve;
  final int? duration;
  final SlideInAnimationWidgetController? controller;
  final bool? removeAfterOutAnimation;
  final void Function()? onExited;

  @override
  Widget build(BuildContext context) {
    return SlideInOutLayoutAnimationWidget(
      visible: visible,
      removeAfterOutAnimation: removeAfterOutAnimation,
      from: const Offset(0, 1),
      to: const Offset(0, 0),
      duration: duration,
      curve: curve,
      reverseCurve: reverseCurve,
      controller: controller,
      onExited: onExited,
      child: child,
    );
  }
}

/// @direction [up to bottom]
///
class SlideInUpLayoutAnimationWidget extends StatelessWidget {
  SlideInUpLayoutAnimationWidget({
    required this.visible,
    required this.child,
    this.duration,
    this.curve,
    this.reverseCurve,
    this.controller,
    this.removeAfterOutAnimation,
    this.onExited,
  });

  final bool visible;
  final Widget child;
  final Curve? curve;
  final Curve? reverseCurve;
  final int? duration;
  final SlideInAnimationWidgetController? controller;
  final bool? removeAfterOutAnimation;
  final void Function()? onExited;

  @override
  Widget build(BuildContext context) {
    return SlideInOutLayoutAnimationWidget(
      visible: visible,
      removeAfterOutAnimation: removeAfterOutAnimation,
      from: const Offset(0, -1),
      to: const Offset(0, 0),
      duration: duration,
      curve: curve,
      reverseCurve: reverseCurve,
      controller: controller,
      onExited: onExited,
      child: child,
    );
  }
}

/// @direction [left to right]
///
class SlideInLeftLayoutAnimationWidget extends StatelessWidget {
  SlideInLeftLayoutAnimationWidget({
    required this.visible,
    required this.child,
    this.duration,
    this.curve,
    this.reverseCurve,
    this.controller,
    this.removeAfterOutAnimation,
    this.onExited,
  });

  final bool visible;
  final Widget child;
  final Curve? curve;
  final Curve? reverseCurve;
  final int? duration;
  final SlideInAnimationWidgetController? controller;
  final bool? removeAfterOutAnimation;
  final void Function()? onExited;

  @override
  Widget build(BuildContext context) {
    return SlideInOutLayoutAnimationWidget(
      visible: visible,
      removeAfterOutAnimation: removeAfterOutAnimation,
      from: const Offset(-1, 0),
      to: const Offset(0, 0),
      duration: duration,
      curve: curve,
      reverseCurve: reverseCurve,
      controller: controller,
      onExited: onExited,
      child: child,
    );
  }
}

/// @direction [right to left]
///
class SlideInRightLayoutAnimationWidget extends StatelessWidget {
  SlideInRightLayoutAnimationWidget({
    required this.visible,
    required this.child,
    this.duration,
    this.curve,
    this.reverseCurve,
    this.controller,
    this.removeAfterOutAnimation,
    this.onExited,
  });

  final Widget child;
  final bool visible;
  final Curve? curve;
  final Curve? reverseCurve;
  final int? duration;
  final SlideInAnimationWidgetController? controller;
  final bool? removeAfterOutAnimation;
  final void Function()? onExited;

  @override
  Widget build(BuildContext context) {
    return SlideInOutLayoutAnimationWidget(
      visible: visible,
      removeAfterOutAnimation: removeAfterOutAnimation,
      from: const Offset(1, 0),
      to: const Offset(0, 0),
      duration: duration,
      curve: curve,
      reverseCurve: reverseCurve,
      controller: controller,
      onExited: onExited,
      child: child,
    );
  }
}

/// extensions
///

extension SlideInOutLayoutAnimationWidgetExtensions on Widget {
  SlideInDownLayoutAnimationWidget slideInDown({
    bool? visible,
    Curve? curve,
    Curve? reverseCurve,
    int? duration,
    SlideInAnimationWidgetController? controller,
    bool? removeAfterOutAnimation,
    void Function()? onExited,
  }) =>
      SlideInDownLayoutAnimationWidget(
        visible: visible ?? true,
        curve: curve,
        reverseCurve: reverseCurve,
        duration: duration,
        removeAfterOutAnimation: removeAfterOutAnimation,
        controller: controller,
        onExited: onExited,
        child: this,
      );

  SlideInUpLayoutAnimationWidget slideInUp({
    bool? visible,
    Curve? curve,
    Curve? reverseCurve,
    int? duration,
    SlideInAnimationWidgetController? controller,
    bool? removeAfterOutAnimation,
    void Function()? onExited,
  }) =>
      SlideInUpLayoutAnimationWidget(
        visible: visible ?? true,
        curve: curve,
        reverseCurve: reverseCurve,
        duration: duration,
        removeAfterOutAnimation: removeAfterOutAnimation,
        controller: controller,
        onExited: onExited,
        child: this,
      );

  SlideInLeftLayoutAnimationWidget slideInLeft({
    bool? visible,
    Curve? curve,
    Curve? reverseCurve,
    int? duration,
    SlideInAnimationWidgetController? controller,
    bool? removeAfterOutAnimation,
    void Function()? onExited,
  }) =>
      SlideInLeftLayoutAnimationWidget(
        visible: visible ?? true,
        curve: curve,
        reverseCurve: reverseCurve,
        duration: duration,
        removeAfterOutAnimation: removeAfterOutAnimation,
        controller: controller,
        onExited: onExited,
        child: this,
      );

  SlideInRightLayoutAnimationWidget slideInRight({
    bool? visible,
    Curve? curve,
    Curve? reverseCurve,
    int? duration,
    SlideInAnimationWidgetController? controller,
    bool? removeAfterOutAnimation,
    void Function()? onExited,
  }) =>
      SlideInRightLayoutAnimationWidget(
        visible: visible ?? true,
        curve: curve,
        reverseCurve: reverseCurve,
        duration: duration,
        removeAfterOutAnimation: removeAfterOutAnimation,
        controller: controller,
        onExited: onExited,
        child: this,
      );
}
