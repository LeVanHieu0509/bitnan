import 'package:bitnan/@share/widget/richtext.wiget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/image/image.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:bitnan/screen/main/home/summary/summary.controller.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';

class ItemTotalValue extends StatefulWidget {
  final double valueBitBack;
  final bool isShowHideMoney;
  final Function? onClickShowHide;
  final Function? onClickWallet;
  final Function(String)? handleClickByName;
  final String type;

  const ItemTotalValue({
    Key? key,
    required this.valueBitBack,
    this.isShowHideMoney = false,
    this.onClickWallet,
    this.onClickShowHide,
    this.handleClickByName,
    required this.type,
  }) : super(key: key);

  @override
  createState() => _ItemTotalValueState();
}

class _ItemTotalValueState extends State<ItemTotalValue> {
  // HomeController homeController = Get.find();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _itemReward();
  }

  Widget _itemReward() => VxBox(
        child: VStack([
          8.heightBox,
          _childTopReward(),
          const Divider(color: MyColor.grayDark_15, endIndent: 16, indent: 16),
          _childBottomLeft(),
        ]),
      )
      .withRounded(value: 4)
      .color(MyColor.white)
      .withShadow([const BoxShadow(color: MyColor.grayBorder_6, blurRadius: 8)])
      .make()
      .paddingSymmetric(horizontal: 16);

  Widget _childTopReward() =>
      ZStack([
        VStack(
          [
            HStack([
              getLocalize(kSummary)
                  .toString()
                  .text
                  .textStyle(MyStyle.typeBold)
                  .size(15)
                  .color(MyColor.grayDark_29.withOpacity(0.6))
                  .make(),
              8.widthBox,
              ImageCaches(
                url:
                    widget.isShowHideMoney
                        ? MyImage.ic_eye_invisibility
                        : MyImage.ic_eye_visibility,
                height: 20,
                width: 25,
                fit: BoxFit.cover,
              ).onTap(() {
                widget.onClickShowHide?.call();
              }),
            ]),
            HStack([
              _itemTopPrice(),
              Visibility(
                visible: widget.onClickWallet != null,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ImageCaches(
                    height: 15.w,
                    width: 15.w,
                    url: MyImage.ic_next_arrow,
                  ).paddingOnly(right: 24.5.w, top: 4).onTap(() {
                    if (widget.onClickWallet != null) {
                      widget.onClickWallet?.call();
                    }
                  }),
                ),
              ),
            ]),
          ],
          crossAlignment: CrossAxisAlignment.center,
          alignment: MainAxisAlignment.center,
        ).box.makeCentered(),
      ]).box.height(heightScreen(10)).make();

  Widget _itemTopPrice() {
    // if (widget.type == kTypeHome) {
    // return GetBuilder<HomeController>(
    //   init: HomeController(),
    //   builder: (data) {
    //     return _itemPrice(data.valueBitBack.value);
    //   },
    // );
    // } else {
    //   return GetBuilder<SummaryController>(
    //     init: SummaryController(),
    //     builder: (data) {
    //       return _itemPrice(data.valueTotal.value);
    //     },
    //   );
    // }

    return GetBuilder<SummaryController>(
      init: SummaryController(),
      builder: (data) {
        return _itemPrice(data.valueTotal.value);
      },
    );
  }

  Widget _itemPrice(double amount) {
    return RichTexts(
      titlePre:
          widget.isShowHideMoney
              ? '${widget.valueBitBack != 0 ? moneyFormat(amount.round().toString()) : 0}'
              : '•••••••',
      style: true,
      titleSuf: getLocalize(kMoneyFormat, args: ['']),
      titleSufStyle: MyStyle.typeBold.copyWith(
        fontSize: 20,
        color: MyColor.black,
      ),
    ).centered().paddingOnly(left: widget.onClickWallet != null ? 42 : 2).expand();
  }

  Widget _childBottomLeft() =>
      HStack([
        // Obx(
        //   () =>
        //       !homeController.isInReview.value
        //           ? _itemChildReward(kRecharge, MyImage.ic_balance_pay)
        //           : Container(),
        // ),
        _itemChildReward(kRecharge, MyImage.ic_balance_pay),
        _itemChildReward(kWithdrawal, MyImage.ic_balance_widthdrawval),
        _itemChildReward(kTransfersMoney, MyImage.ic_balance_transfer),
      ]).box.height(heightScreen(10)).make();

  Widget _itemChildReward(String title, String icon) => Flexible(
    fit: FlexFit.tight,
    flex: 3,
    child: Center(
      child: VStack([
        Image(image: AssetImage(icon), height: 32, width: 32),
        4.heightBox,
        getLocalize(
          title,
        ).toString().text.textStyle(MyStyle.typeRegularSmall).size(14).make(),
      ], crossAlignment: CrossAxisAlignment.center),
    ).box.make().onTap(() {
      widget.handleClickByName?.call(title);
    }),
  );
}
