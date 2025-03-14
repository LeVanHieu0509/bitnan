import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../resource/color.resource.dart';

class SubmitButtonV3 extends StatelessWidget {
  final VoidCallback action;
  final Widget child;
  final Color? backgroundColor;
  final double? height;
  final double? radius;
  final Gradient? gradient;
  final Border? border;
  final bool disable;

  final bool primary;
  const SubmitButtonV3({
    Key? key,
    required this.child,
    this.backgroundColor,
    required this.action,
    this.height,
    this.radius,
    this.gradient,
    this.border,
    this.primary = true,
    this.disable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VxBox(
          child: Material(
            borderRadius: BorderRadius.circular(15.r),
            color: Colors.transparent,
            child: InkWell(
              onTap: disable ? () {} : action,
              splashColor: MyColor.white.withOpacity(0.5),
              child: child,
            ),
          ),
        )
        .height(height ?? (primary ? 48 : 40))
        .clip(Clip.antiAlias)
        .withDecoration(
          BoxDecoration(
            border: border,
            color: backgroundColor?.withOpacity(disable ? 0.4 : 1.0),
            gradient: gradient,
            borderRadius: BorderRadius.circular(radius ?? 16.r),
          ),
        )
        .make();
  }
}
