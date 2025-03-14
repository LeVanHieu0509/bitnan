import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/image/image.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:velocity_x/velocity_x.dart';

class TextFieldUnderline extends StatefulWidget {
  final String? initialValue;
  final String text;
  final void Function(String)? onChanged;
  final VoidCallback? actionRight, actionLeft;
  final String iconLeft;
  final String iconRight;
  final bool enabled;
  final String hintText;
  final double sizeIcLeft;
  final double sizeIcRight;
  final TextStyle? style;
  final TextInputType textInputType;
  final bool autoFocus;
  final bool isDense;
  final EdgeInsets? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const TextFieldUnderline({
    Key? key,
    this.initialValue = '',
    this.onChanged,
    this.iconLeft = '',
    this.iconRight = '',
    this.enabled = true,
    this.hintText = '',
    this.sizeIcLeft = 24,
    this.contentPadding,
    this.sizeIcRight = 24,
    this.actionRight,
    this.actionLeft,
    this.text = '',
    this.style,
    this.textInputType = TextInputType.text,
    this.autoFocus = false,
    this.isDense = false,
    this.inputFormatters,
    this.validator,
  }) : super(key: key);

  @override
  createState() => _TextFieldUnderlineState();
}

class _TextFieldUnderlineState extends State<TextFieldUnderline> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.autoFocus,
      initialValue: widget.initialValue,
      style: widget.style ?? MyStyle.typeBold.copyWith(fontSize: 16.sp),
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      keyboardType: widget.textInputType,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      decoration: InputDecoration(
        isDense: widget.isDense,
        contentPadding: widget.contentPadding,
        disabledBorder: getBorder(),
        enabledBorder: getBorder(),
        focusedBorder: getBorder(),
        hintText: getLocalize(widget.hintText),
        hintStyle: MyStyle.typeRegular.copyWith(
          fontSize: 14.sp,
          color: MyColor.black.withOpacity(0.5),
        ),
        prefixIconConstraints:
            widget.iconLeft.isEmpty
                ? null
                : BoxConstraints(maxHeight: 25.w, maxWidth: 32.w),
        prefixIcon:
            widget.iconLeft.isEmpty
                ? null
                : Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: ImageCaches(
                    height: widget.sizeIcLeft.w,
                    width: widget.sizeIcLeft.w,
                    url: widget.iconLeft,
                  ).onTap(() => widget.actionLeft?.call()),
                ),
        suffixIconConstraints:
            widget.iconRight.isEmpty
                ? null
                : BoxConstraints(maxHeight: 24.w, maxWidth: 32.w),
        suffixIcon:
            widget.iconRight.isEmpty
                ? null
                : ImageCaches(
                  height: widget.sizeIcRight.w,
                  width: widget.sizeIcRight.w,
                  url: widget.iconRight,
                ).onTap(() => widget.actionRight?.call()),
      ),
    );
  }

  UnderlineInputBorder getBorder() {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        width: 0.5,
        color:
            widget.text.isEmpty
                ? MyColor.black.withOpacity(0.3)
                : MyColor.black,
      ),
    );
  }
}
