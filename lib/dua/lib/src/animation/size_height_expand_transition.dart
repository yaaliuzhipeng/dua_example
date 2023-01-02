import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';

typedef ExpandAnimateFunc = void Function(bool expand);

class SizeHeightExpandTransitionController {
  late ExpandAnimateFunc animate;
}

class SizeHeightExpandTransition extends StatefulWidget {
  const SizeHeightExpandTransition({
    super.key,
    this.controller,
    this.child,
    this.expandImmediately,
    this.collapseMillisecondsDuration,
  });
  final SizeHeightExpandTransitionController? controller;
  final Widget? child;
  final int? collapseMillisecondsDuration;
  final bool? expandImmediately;

  @override
  State<StatefulWidget> createState() => _SizeHeightExpandTransition();
}

class _SizeHeightExpandTransition extends State<SizeHeightExpandTransition> with SingleTickerProviderStateMixin {
  late final SizeHeightExpandTransitionController _controller;
  final SpringDescription springDescription = const SpringDescription(mass: 1, stiffness: 800, damping: 38);
  SpringSimulation? springSimulation;
  double value = 0;
  Ticker? ticker;
  Size _size = Size.zero;
  bool _expand = false;
  double _start = 0;
  int get _collapseDuration => widget.collapseMillisecondsDuration ?? 150;
  bool get _expandImmediately => widget.expandImmediately ?? false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller != null ? widget.controller! : SizeHeightExpandTransitionController();
    _controller.animate = animate;
  }

  void animate(bool expand) {
    _start = value;
    _expand = expand;
    springSimulation = SpringSimulation(springDescription, value, expand ? _size.height : 0, 1);
    if (ticker != null) {
      if (ticker!.isActive) ticker?.stop(canceled: true);
    } else {
      ticker = createTicker(_onTick);
    }
    ticker?.start();
  }

  void _onTick(Duration time) {
    var v = 0.0;
    var t = time.inMilliseconds.toDouble();
    if (_expand) {
      t = t / 2000;
      v = springSimulation!.x(t);
      setState(() {
        value = max(v, 0);
      });
      if (springSimulation!.isDone(t)) {
        ticker?.stop();
      }
    } else {
      v = _start - _start * (t / _collapseDuration);
      setState(() {
        value = max(v, 0);
      });
      if (t > _collapseDuration) {
        ticker?.stop();
      }
    }
  }

  void _onChildSizeChanged(Size size) {
    _size = size;
    if (_expandImmediately) animate(true);
  }

  @override
  void dispose() {
    ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        height: value,
        child: CustomMultiChildLayout(
          delegate: LayoutDelegate(onSizeChanged: _onChildSizeChanged, currentSize: _size),
          children: [LayoutId(id: 1, child: SizedBox(child: widget.child))],
        ),
      ),
    );
  }
}

typedef OnSizeChanged = void Function(Size size);

class LayoutDelegate extends MultiChildLayoutDelegate {
  LayoutDelegate({required this.onSizeChanged, required this.currentSize});

  final OnSizeChanged onSizeChanged;
  final Size currentSize;

  @override
  void performLayout(Size size) {
    if (hasChild(1)) {
      final firstSize = layoutChild(1, const BoxConstraints());
      if (currentSize != firstSize) {
        onSizeChanged(firstSize);
      }
    }
  }

  /// always relayout children when system required
  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => true;
}
