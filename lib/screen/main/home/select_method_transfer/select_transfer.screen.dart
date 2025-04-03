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

/*
  chọn phương thức chuyển tiền, 
  với các phần chính như danh sách các loại tiền tệ, 
  khả năng chọn phương thức và một nút "Submit".
 */
class SelectTransferScreen extends GetWidget<SelectTransferController> {
  const SelectTransferScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(controller.listCoin);
    print(controller.listCurrency);

    // Trả về một widget CustomScaffold (widget tùy chỉnh) với màu sắc appBar, tiêu đề và body.
    return CustomScaffold(
      appBarColor: MyColor.colorContainer,
      titleAppBar: getLocalize(kSelectCashBack),
      body: _itemNew(),
    );
  }

  // Tạo cấu trúc giao diện chứa một danh sách tiền xu, một vùng trống, và một nút "Submit".
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
          // Khi người dùng nhấn vào nút, màn hình sẽ chuyển đến màn hình khác (thông qua goTo).
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

  // Hiển thị danh sách tiền tệ (coin) trong ListView.builder.
  // Mỗi phần tử trong danh sách có thể được nhấn để chọn (bằng cách gọi controller.updatePosition(index)).
  Widget _itemListCoin() => Obx(
    () =>
        VxBox(
          // ListView.builder là một widget Flutter dùng để tạo
          // danh sách có thể cuộn với số lượng phần tử thay đổi động (dựa trên dữ liệu).
          child: ListView.builder(
            // Đảm bảo rằng ListView chỉ chiếm không gian cần thiết thay vì mở rộng hết không gian có sẵn.
            shrinkWrap: true,
            // const BouncingScrollPhysics(): Điều này tạo hiệu ứng cuộn như kiểu trên iOS, khi người dùng kéo đến cuối danh sách
            physics: const BouncingScrollPhysics(),
            // Số lượng phần tử trong danh sách (số lượng đồng xu trong controller.listCoin).
            itemCount: controller.listCoin.length,
            // Hàm này tạo ra mỗi mục trong danh sách. Mỗi mục được xây dựng bằng cách lấy thông tin từ controller.listCoin.
            itemBuilder: (_, index) {
              // Mỗi phần tử trong controller.listCoin là một đối tượng MasterConfigCoin
              MasterConfigCoin modelCoin = controller.listCoin[index];

              CurrencyModel? model = controller.listCurrency.firstWhereOrNull(
                (element) => element.currency == modelCoin.code,
              );

              // InkWell là một widget Flutter giúp tạo hiệu ứng nhấn (ripple effect) khi người dùng chạm vào phần tử.
              return InkWell(
                onTap: () {
                  // Khi người dùng nhấn vào một phần tử trong danh sách,
                  // nó sẽ gọi controller.updatePosition(index) để cập nhật vị trí hoặc trạng thái của phần tử được nhấn.
                  controller.updatePosition(index);
                },
                // GetBuilder là một widget từ thư viện Get,
                // dùng để xây dựng giao diện dựa trên sự thay đổi trong SelectTransferController.
                child: GetBuilder<SelectTransferController>(
                  // SelectTransferController() khởi tạo controller khi widget được xây dựng
                  init: SelectTransferController(),
                  builder: (_) {
                    // Đây là một builder function, nơi bạn có thể trả về widget muốn tái xây dựng.
                    // Trong trường hợp này, nó sẽ tạo ra Container chứa thông tin của mỗi đồng xu.

                    // Container dùng để đóng gói các widget khác,
                    // cho phép dễ dàng áp dụng các kiểu dáng như margin, padding, border, v.v.
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration:
                      // Dùng để tạo hiệu ứng gradient và bóng đổ cho phần tử
                      BoxDecoration(
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
