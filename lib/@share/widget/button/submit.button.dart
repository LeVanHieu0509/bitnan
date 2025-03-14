import 'package:flutter/material.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonSubmit extends StatelessWidget {
  final double? radius;
  final double? height;
  final double? width;
  final double? opacity;
  final Color? color;
  final String title;
  final String? rightImage;
  final double? titleSize;
  final VoidCallback? action;
  final double? marginVertical, marginHorizontal;
  final double? borderWidth;
  final Color? textColor;
  final Color? borderColor;
  final Widget? titleWidget;

  const ButtonSubmit({
    Key? key,
    this.radius,
    this.height,
    this.width,
    this.color,
    this.action,
    required this.title,
    this.opacity,
    this.marginVertical,
    this.marginHorizontal,
    this.borderWidth,
    this.textColor,
    this.borderColor,
    this.titleSize,
    this.titleWidget,
    this.rightImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Vx.white,
      highlightColor: Vx.white,
      onTap: () {
        if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
          FocusScope.of(context).unfocus();
        }
        action?.call();
      },
      child: VxBox(
            child: HStack([
              titleWidget ??
                  title
                      .toString()
                      .text
                      .textStyle(
                        MyStyle.typeBold.copyWith(
                          color: textColor ?? Vx.white,
                          fontSize: titleSize ?? 16.sp,
                        ),
                      )
                      .make(),
              rightImage != null
                  ? Image(
                    image: AssetImage(rightImage!),
                    fit: BoxFit.fill,
                    height: 24.w,
                    width: 24.w,
                  ).box.make().pOnly(left: 16.w)
                  : const SizedBox(),
            ]),
          )
          .withRounded(value: radius ?? 90.r)
          .height(48.h)
          // .height(height ?? (kToolbarHeight * 0.85))
          .width(width ?? widthScreen(80))
          .margin(
            EdgeInsets.symmetric(
              vertical: marginVertical ?? 16.w,
              horizontal: marginHorizontal ?? 0,
            ),
          )
          .alignCenter
          .color(color ?? MyColor.blueTeal)
          .border(
            width: borderWidth ?? 0,
            color: borderColor ?? MyColor.blueTeal,
          )
          .makeCentered()
          .opacity(value: opacity ?? 1),
    );
  }
}
