import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../resource/color.resource.dart';
import '../../resource/style.resource.dart';

class BBPasswordInput extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autoFocus;
  final BuildContext appContext;

  const BBPasswordInput({
    Key? key,
    required this.appContext,
    required this.onChanged,
    this.onCompleted,
    this.controller,
    this.autoFocus = false,
    this.focusNode,
  }) : super(key: key);

  @override
  build(BuildContext context) => PinCodeTextField(
    appContext: context,
    length: 6,
    animationType: AnimationType.fade,
    obscureText: true,
    autoFocus: autoFocus,
    focusNode: focusNode,
    pinTheme: PinTheme(
      borderWidth: 1,
      inactiveColor: MyColor.grayDark.withOpacity(0.3),
      inactiveFillColor: Colors.transparent,
      shape: PinCodeFieldShape.underline,
      selectedColor: MyColor.pinkNew,
      selectedFillColor: Colors.transparent,
      activeColor: MyColor.pinkNew,
      activeFillColor: Colors.transparent,
      fieldHeight: 48,
    ),
    cursorColor: MyColor.pinkNew,
    animationDuration: const Duration(milliseconds: 150),
    textStyle: MyStyle.typeBold.copyWith(color: MyColor.black, fontSize: 12.sp),
    enableActiveFill: true,
    controller: controller,
    keyboardType: TextInputType.number,
    onChanged: onChanged,
    onCompleted: onCompleted,
  );
}
