import 'package:flutter/material.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/style.resource.dart';

class ItemTitle extends StatelessWidget {
  final String titleLeft, titleRight;

  const ItemTitle({Key? key, required this.titleLeft, required this.titleRight})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titleLeft, style: MyStyle.typeBold),
        Text(
          titleRight,
          style: MyStyle.typeMedium.copyWith(
            color: MyColor.grayDark.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
