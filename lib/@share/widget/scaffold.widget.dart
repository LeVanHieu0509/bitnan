import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:velocity_x/velocity_x.dart';

import 'custom_safe_view/custom_safe_view.dart';

class CustomScaffold extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? leftWidget;
  final String? titleAppBar;
  final bool isShowLeading;
  final bool centerTitle;
  final Widget? actionWidget;
  final VoidCallback? onBackPress;
  final bool isPaddingTop;
  final bool isPaddingBottom;
  final bool resizeToAvoidBottomInset;
  final TextStyle? titleTextStyle;
  final Color? appBarColor;
  final Color? backgroundColor;
  final Color? colorBack;
  final Color? assetsColor;
  final Color? assetsBoxColor;
  final Widget? bottomNavigationBar;
  final bool isShowAssets;
  final String? ticketAvailable;
  final String? bbcAvailable;
  final bool? isWonTickets;

  const CustomScaffold({
    Key? key,
    this.appBar,
    required this.body,
    this.titleAppBar,
    this.isShowLeading = true,
    this.resizeToAvoidBottomInset = true,
    this.centerTitle = true,
    this.actionWidget,
    this.onBackPress,
    this.isPaddingTop = false,
    this.isPaddingBottom = false,
    this.appBarColor,
    this.backgroundColor,
    this.colorBack,
    this.bottomNavigationBar,
    this.titleTextStyle,
    this.isShowAssets = false,
    this.assetsBoxColor,
    this.assetsColor,
    this.ticketAvailable,
    this.bbcAvailable,
    this.isWonTickets,
    this.leftWidget,
  }) : super(key: key);

  @override
  createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          widget.appBar ??
          AppBar(
            backgroundColor: widget.appBarColor ?? MyColor.white,
            titleTextStyle: const TextStyle(color: Colors.black),
            actions: <Widget>[
              widget.isShowAssets
                  ? VxBox(
                        child: ZStack(alignment: Alignment.center, [
                          HStack([
                            HStack([
                              widget.bbcAvailable
                                  .toString()
                                  .toUpperCase()
                                  .text
                                  .textStyle(
                                    MyStyle.typeProExtraBold.copyWith(
                                      fontSize: 14.sp,
                                      color:
                                          widget.assetsColor ?? MyColor.black,
                                    ),
                                  )
                                  .make(),
                              5.w.widthBox,
                              Image.asset(
                                MyImage.ic_bbc,
                                width: 20,
                                height: 24,
                                fit: BoxFit.contain,
                              ),
                            ]),
                            12.widthBox,
                            HStack([
                              widget.ticketAvailable
                                  .toString()
                                  .toUpperCase()
                                  .text
                                  .textStyle(
                                    MyStyle.typeProExtraBold.copyWith(
                                      fontSize: 14.sp,
                                      color:
                                          widget.assetsColor ?? MyColor.black,
                                    ),
                                  )
                                  .make(),
                              5.widthBox,
                              Image.asset(
                                MyImage.ic_ticket_2,
                                width: 20,
                                height: 24,
                                fit: BoxFit.contain,
                              ),
                            ]),
                          ]),
                          Positioned(
                            top: 0,
                            left: -30,
                            child: VxBox(child: Image.asset(MyImage.ic_plus))
                                .width(20)
                                .height(20)
                                .padding(const EdgeInsets.all(5))
                                .withDecoration(
                                  BoxDecoration(
                                    color: MyColor.yellowGold4,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                )
                                .make()
                                .onTap(() {}),
                          ),
                        ]),
                      )
                      .height(40)
                      .padding(EdgeInsets.symmetric(horizontal: MyStyle.sm))
                      .margin(EdgeInsets.only(right: MyStyle.sm))
                      .withDecoration(
                        BoxDecoration(
                          color:
                              widget.assetsBoxColor ??
                              MyColor.gray90.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(MyStyle.lg),
                        ),
                      )
                      .make()
                      .paddingSymmetric(vertical: 8)
                  : const SizedBox(),
              widget.actionWidget ?? Container(),
            ],
            leading:
                widget.leftWidget ??
                (widget.isShowLeading
                    ? IconButton(
                      onPressed:
                          () =>
                              widget.onBackPress != null
                                  ? widget.onBackPress!()
                                  : Get.back(),
                      icon: Image(
                        image: const AssetImage(MyImage.ic_back_left),
                        width: 20,
                        height: 20,
                        color: widget.colorBack ?? MyColor.black,
                      ),
                    )
                    : Container()),
            title: Text(
              widget.titleAppBar ?? '',
              style:
                  widget.titleTextStyle ??
                  MyStyle.typeSemiBold.copyWith(
                    color: MyColor.black,
                    fontSize: 15.sp,
                  ),
            ),
            centerTitle: widget.centerTitle,
            elevation: 0,
          ),
      backgroundColor: widget.backgroundColor ?? MyColor.colorContainer,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomSafeView(
          top: widget.isPaddingTop,
          bottom: widget.isPaddingBottom,
          backgroundColor: widget.backgroundColor,
          child: widget.body,
        ),
      ),
      // resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      // bottomNavigationBar:
      //     widget.bottomNavigationBar ?? widget.bottomNavigationBar,
      // resizeToAvoidBottomPadding: true,
    );
  }
}
