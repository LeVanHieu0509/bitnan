import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bitnan/@share/widget/text/currency_input_formatter.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/style.resource.dart';

class TextFieldBorder extends StatefulWidget {
  final String? placeholderText;
  final String? initialValue;
  final TextInputType? inputType;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final bool isObscureText;
  final bool enable;
  final int? maxLine;
  final int? maxLength;
  final Function(String)? onClickAdd;
  final Color? borderColor;
  final Color? cursorColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextAlign? textAlign;
  final Color? color;
  final InputBorder? enabledBorder;
  final TextInputFormatter? textInputFormatter;
  final int? minLine;
  final Function()? onTap;
  final bool? showCursor;
  final bool? readOnly;
  final bool hideBorder;
  final FocusNode? focusNode;
  final EdgeInsets? contentPadding;

  const TextFieldBorder({
    Key? key,
    this.onClickAdd,
    this.contentPadding,
    this.placeholderText,
    this.cursorColor,
    this.inputType,
    this.hideBorder = false,
    this.suffixIcon,
    this.prefixIcon,
    this.style,
    this.isObscureText = false,
    this.borderColor,
    this.onChanged,
    this.maxLength,
    this.validator,
    this.enable = true,
    this.controller,
    this.maxLine,
    this.initialValue = '',
    this.textAlign,
    this.hintStyle,
    this.color,
    this.enabledBorder,
    this.textInputFormatter,
    this.minLine,
    this.onTap,
    this.showCursor,
    this.readOnly,
    this.focusNode,
  }) : super(key: key);

  @override
  createState() => _TextFieldBorderState();
}

class _TextFieldBorderState extends State<TextFieldBorder> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: widget.textAlign ?? TextAlign.left,
      cursorColor: widget.cursorColor ?? MyColor.blueTeal,
      initialValue: widget.initialValue,
      controller: widget.controller,
      enabled: widget.enable,
      maxLength: widget.maxLength,
      validator: widget.validator,
      style: widget.style ?? MyStyle.typeRegular,
      keyboardType: widget.inputType ?? TextInputType.text,
      obscureText: widget.isObscureText,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      showCursor: widget.showCursor,
      readOnly: widget.readOnly ?? false,
      focusNode: widget.focusNode,
      inputFormatters:
          widget.textInputFormatter != null
              ? [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyInputFormatter(maxDigits: 8),
              ]
              : null,
      onFieldSubmitted: (val) => _onClickSubmit(),
      minLines: widget.minLine ?? 1,
      maxLines: widget.isObscureText ? 1 : widget.maxLine,
      scrollPhysics: const BouncingScrollPhysics(),
      decoration: InputDecoration(
        fillColor: widget.color ?? MyColor.white,
        contentPadding: widget.contentPadding,
        filled: true,
        prefixIcon: widget.prefixIcon,
        isDense: true,
        counterText: '',
        errorMaxLines: 10,
        errorStyle: MyStyle.typeRegular.copyWith(color: Colors.red),
        hintText: widget.placeholderText ?? '',
        suffixIcon:
            widget.suffixIcon != null
                ? IconButton(
                  onPressed: _onClickSubmit,
                  icon: widget.suffixIcon!,
                )
                : null,
        hintStyle:
            widget.hintStyle ??
            MyStyle.typeRegular.copyWith(
              color: MyColor.blueSteel,
              fontSize: 15.sp,
            ),
        disabledBorder:
            widget.hideBorder
                ? InputBorder.none
                : widget.enabledBorder ??
                    OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide(
                        color: widget.borderColor ?? MyColor.blueTeal,
                      ),
                    ),
        enabledBorder:
            widget.hideBorder
                ? InputBorder.none
                : widget.enabledBorder ??
                    OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide(
                        color: widget.borderColor ?? MyColor.blueTeal,
                      ),
                    ),
        border:
            widget.hideBorder
                ? InputBorder.none
                : OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? MyColor.blueTeal,
                  ),
                ),
        focusedBorder:
            widget.hideBorder
                ? InputBorder.none
                : OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? MyColor.blueTeal,
                  ),
                ),
      ),
    );
  }

  _onClickSubmit() {
    if (widget.controller != null) {
      widget.onClickAdd?.call(widget.controller!.text);
    }
  }
}
