import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitnan/@core/data/repo/model/currency.model.dart';
import 'package:bitnan/@core/data/repo/model/master_config.model.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/image/image.widget.dart';
import 'package:bitnan/@share/widget/scaffold.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:bitnan/screen/main/home/select_method_transfer/select_transfer.controller.dart';
import 'package:velocity_x/velocity_x.dart';

class SelectTransferScreen extends GetWidget<SelectTransferController> {
  const SelectTransferScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(controller.listCoin);
    print(controller.listCurrency);

    return CustomScaffold(
      appBarColor: MyColor.colorContainer,
      titleAppBar: getLocalize(kSelectCashBack),
      body: _itemNew(),
    );
  }

  Widget _itemNew() =>
      VStack([_itemListCoin(), VxBox().make().expand(), _itemSubmit()]).box
          .padding(const EdgeInsets.symmetric(horizontal: 16))
          .color(MyColor.colorContainer)
          .make();

  Widget _itemSubmit() => Obx(
    () => Opacity(
      opacity: controller.isCheck.value ? 1 : 0.4,
      child: VxBox(
            child:
                getLocalize(
                  kChoose,
                ).toString().text.color(MyColor.white).bold.makeCentered(),
          )
          .withDecoration(getDecoration())
          .width(widthScreen(100))
          .margin(
            const EdgeInsets.only(
              left: kToolbarHeight,
              right: kToolbarHeight,
              bottom: kToolbarHeight,
            ),
          )
          .padding(const EdgeInsets.symmetric(vertical: 16))
          .makeCentered()
          .onTap(() async {
            // if (controller.model.currency == kVNDC) {
            goTo(screen: ROUTER_TRANSFERS_REWARD, argument: controller.model);
            // } else {
            //   showModalBottomSheet(
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.only(
            //               topRight: Radius.circular(4),
            //               topLeft: Radius.circular(4))),
            //       backgroundColor: MyColor.white,
            //       context: Get.overlayContext,
            //       builder: (_) => PopupConfirm(
            //             heightImage: 110,
            //             urlImage: MyImage.ic_system_maintain,
            //             textSubmit: 'OK',
            //             content: getLocalize(kSwapPending),
            //             isShowCancel: false,
            //             action: () {
            //               hideKeyboard();
            //             },
            //           ));
            // }
          }),
    ),
  );

  Widget _itemListCoin() => Obx(
    () =>
        VxBox(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: controller.listCoin.length,
            itemBuilder: (_, index) {
              MasterConfigCoin modelCoin = controller.listCoin[index];
              CurrencyModel? model = controller.listCurrency.firstWhereOrNull(
                (element) => element.currency == modelCoin.code,
              );
              return InkWell(
                onTap: () {
                  controller.updatePosition(index);
                },
                child: GetBuilder<SelectTransferController>(
                  init: SelectTransferController(),
                  builder: (_) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            modelCoin.isChecked
                                ? MyColor.gradientStart
                                : Colors.transparent,
                            modelCoin.isChecked
                                ? MyColor.gradientStop
                                : Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: const [
                          BoxShadow(
                            color: MyColor.grayBorder_6,
                            blurRadius: 8, // changes position of shadow
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: MyColor.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: MyColor.white),
                        ),
                        child: Row(
                          children: [
                            _itemImage(url: modelCoin.icon),
                            spaceWidth(8),
                            Text(modelCoin.name, style: MyStyle.typeRegular),
                            const Spacer(),
                            RichText(
                              text: TextSpan(
                                text: moneyFormat(
                                  model?.amount.toStringAsFixed(0) ?? '',
                                ),
                                style: MyStyle.typeMedium,
                                children: [
                                  TextSpan(
                                    text: '\t ${modelCoin.code}',
                                    style: MyStyle.typeRegular,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ).make(),
  );

  Widget _itemImage({required String url}) {
    return ImageCaches(
      url: url,
      height: 28,
      width: 28,
      urlError: MyImage.ic_token_default,
    );
  }
}
