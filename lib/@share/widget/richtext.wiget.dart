import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:velocity_x/velocity_x.dart';

class RichTexts extends StatelessWidget {
  final String titlePre;
  final String titleSuf;
  final bool style;
  final double? sizeTitlePre, sizeTitleSuf;
  final TextStyle? titleStyle, titleSufStyle;

  const RichTexts({
    Key? key,
    required this.titlePre,
    required this.titleSuf,
    this.titleStyle,
    this.titleSufStyle,
    required this.style,
    this.sizeTitlePre,
    this.sizeTitleSuf,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _itemRichText(titlePre, titleSuf, style);
  }

  Widget _itemRichText(String titlePre, String titleSuf, bool style) =>
      VxRichText(titlePre)
          .withTextSpanChildren([
            VelocityXTextSpan(titleSuf)
                .textStyle(
                  titleSufStyle != null
                      ? titleSufStyle!
                      : MyStyle.typeRegular.copyWith(
                        fontSize: sizeTitleSuf ?? 14,
                        color: style ? MyColor.grayDark : MyColor.orangeLight,
                      ),
                )
                .make(),
          ])
          .textStyle(
            titleStyle != null
                ? titleStyle!
                : MyStyle.typeBold.copyWith(
                  fontSize: sizeTitlePre ?? 22,
                  color: style ? MyColor.grayDark : MyColor.graySemi,
                ),
          )
          .make()
          .paddingOnly(top: style ? 8 : 4, bottom: style ? 4 : 8);
}
