import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../resource/color.resource.dart';

class CustomSafeView extends StatefulWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final Color? backgroundColor;

  const CustomSafeView({
    Key? key,
    required this.child,
    this.top = false,
    this.bottom = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  createState() => _CustomSafeViewState();
}

class _CustomSafeViewState extends State<CustomSafeView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: widget.top,
      bottom: widget.bottom,
      child: widget.child,
    ).box.color(widget.backgroundColor ?? MyColor.white).make();
  }
}
