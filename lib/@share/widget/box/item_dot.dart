import 'package:bitnan/resource/color.resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemDot extends StatelessWidget {
  final bool isActive;
  const ItemDot({Key? key, this.isActive = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 4.h,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: isActive ? null : MyColor.grayDark.withOpacity(0.15),
        borderRadius: BorderRadius.circular(2.0),
        gradient:
            isActive
                ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFFF54351), Color(0xFFD0008F)],
                )
                : null,
      ),
    );
  }
}
