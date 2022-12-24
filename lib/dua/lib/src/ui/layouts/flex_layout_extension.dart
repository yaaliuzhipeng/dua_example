import 'package:flutter/material.dart';

extension HorizontalLayoutExtension on List<Widget> {
  /// start
  Row hs({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  /// center
  Row hc({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  /// end
  Row he({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  /// space-between
  Row hsb({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  /// space-around
  Row hsa({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  /// space-evenly
  Row hse({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }
}

extension VerticalLayoutExtension on List<Widget> {
  Column vs({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  Column vc({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  Column ve({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  Column vsb({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  Column vsa({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  Column vse({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }
}
