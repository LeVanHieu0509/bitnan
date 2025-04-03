import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:velocity_x/velocity_x.dart';

class ButtonExchange extends StatefulWidget {
  final VoidCallback? refreshPrice;
  final VoidCallback? actionExchange;
  final String from, to;

  const ButtonExchange({
    Key? key,
    this.refreshPrice,
    this.actionExchange,
    required this.from,
    required this.to,
  }) : super(key: key);

  @override
  createState() => _ButtonExchangeState();
}

class _ButtonExchangeState extends State<ButtonExchange> {
  Timer? _timer;
  int _start = 10;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VxBox(
          child:
              (_start > 0
                      ? getLocalize(kButtonExchange, args: ['$_start'])
                      : getLocalize(kUpdatePriceExchange))
                  .toString()
                  .text
                  .bold
                  .size(16.sp)
                  .color(MyColor.white)
                  .makeCentered(),
        )
        .withDecoration(getDecoration())
        .height(kHeightButton)
        .margin(
          const EdgeInsets.only(
            left: kToolbarHeight,
            right: kToolbarHeight,
            bottom: kToolbarHeight,
            top: kPaddingTopButton,
          ),
        )
        .width(widthScreen(100))
        .makeCentered()
        .onTap(() {
          if (_start == 0 && widget.from != widget.to) {
            widget.refreshPrice?.call();
            setState(() {
              _start = 10;
            });
          } else {
            widget.actionExchange?.call();
          }
        });
  }
}
