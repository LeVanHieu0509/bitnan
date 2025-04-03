import 'package:bitnan/@share/widget/text/text_gradient.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/image/image.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../../resource/style.resource.dart';

class PopupConfirm extends StatelessWidget {
  final String? title,
      content,
      contentGradient,
      textSubmit,
      urlImage,
      textCancel;
  final double? heightImage;
  final bool isShowSubmit;
  final bool isShowCancel;

  final VoidCallback? action;

  const PopupConfirm({
    Key? key,
    this.title,
    this.urlImage,
    this.content,
    this.heightImage,
    this.textSubmit,
    this.textCancel,
    this.contentGradient,
    this.isShowSubmit = true,
    this.isShowCancel = true,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _itemNew();
  }

  Widget _itemNew() =>
      VStack(
        [
          VxBox()
              .height(3.h)
              .width(64.w)
              .color(MyColor.gray.withOpacity(0.15))
              .margin(EdgeInsets.only(top: 16.h, bottom: 28.h))
              .make(),
          if (urlImage != null)
            ImageCaches(
              url: urlImage,
              height: heightImage ?? 68.h,
              width: heightImage != null ? 162.w : 68.h,
              fit: BoxFit.fill,
            ),
          if (heightImage == null) 24.heightBox,
          if (title != null)
            title!.text.bold.size(16.sp).color(MyColor.black).make(),
          10.heightBox,
          if (content != null)
            content!.text.size(16.sp).center.lineHeight(2).makeCentered(),
          10.heightBox,
          if (contentGradient != null)
            GradientText(
              contentGradient,
              style: MyStyle.typeBold.copyWith(fontSize: 24.sp),
              gradient: const LinearGradient(
                colors: [MyColor.gradientStart, MyColor.gradientStop],
              ),
            ).box.margin(const EdgeInsets.only(bottom: 10)).make(),
          1.heightBox.expand(),
          HStack([
                if (isShowSubmit)
                  VxBox(
                        child:
                            (textSubmit != null
                                    ? textSubmit!
                                    : getLocalize(kTransfersMoney).toString())
                                .text
                                .bold
                                .size(16.sp)
                                .color(MyColor.white)
                                .makeCentered(),
                      )
                      .withDecoration(getDecoration())
                      .height(kHeightButton)
                      .margin(const EdgeInsets.symmetric(horizontal: 8))
                      .withRounded(value: 4)
                      .make()
                      .onTap(() {
                        goBack();
                        action?.call();
                        hideKeyboard();
                      })
                      .expand(),
                if (isShowCancel)
                  VxBox(
                        child:
                            (textCancel != null
                                    ? textCancel!
                                    : getLocalize(kCancelSwap).toString())
                                .text
                                .bold
                                .size(16.sp)
                                .color(MyColor.grayDark_29.withOpacity(0.6))
                                .makeCentered(),
                      )
                      .border(color: MyColor.grayDark_29.withOpacity(0.6))
                      .height(kHeightButton)
                      .margin(const EdgeInsets.symmetric(horizontal: 8))
                      .withRounded(value: 4)
                      .make()
                      .onTap(() {
                        goBack();
                        hideKeyboard();
                      })
                      .expand(),
              ]).box
              .padding(
                EdgeInsets.symmetric(
                  horizontal:
                      (isShowSubmit && isShowCancel) ? 8 : kToolbarHeight,
                ),
              )
              .make(),
          kToolbarHeight.heightBox,
        ],
        axisSize: MainAxisSize.max,
        crossAlignment: CrossAxisAlignment.center,
      ).box.width(widthScreen(100)).height(390.h).make();
}
