import 'package:bitnan/screen/main/home/child_tab/child_tab.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/scaffold.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/screen/main/home/summary/summary.controller.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../@share/widget/item_currency.widget.dart';
// import '../child_tab/child_tab.screen.dart';

// Màn hình này hiển thị thông tin người dùng liên quan đến ví (wallet)
// và trạng thái chờ của các giao dịch, sử dụng Obx để theo dõi thay đổi trong các biến Rx và cập nhật giao diện.
// SummaryScreen là một stateless widget kế thừa từ GetView<SummaryController>.
class SummaryScreen extends GetView<SummaryController> {
  const SummaryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Đây là widget tùy chỉnh thay thế cho Scaffold,
    // giúp tạo giao diện màn hình với AppBar, body và các phần tử khác.
    return CustomScaffold(
      titleAppBar: getLocalize(
        kMyWallet,
      ), // Tiêu đề trên AppBar được lấy từ getLocalize(kMyWallet).
      appBarColor: MyColor.colorContainer,
      backgroundColor: MyColor.colorContainer,
      isShowLeading: false, // Điều này ẩn nút quay lại (back button).
      //  Dùng để cho phép người dùng kéo xuống để làm mới dữ liệu với
      body: CustomScrollView(
        // Sử dụng CustomScrollView với CupertinoSliverRefreshControl để làm mới dữ liệu khi kéo xuống.
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // Đảm bảo rằng khi người dùng kéo để làm mới,
          // bạn gọi lại phương thức controller.getInfo() để lấy lại dữ liệu.
          CupertinoSliverRefreshControl(onRefresh: controller.getInfo),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  [
                    () => _topInfo(),
                    () => VStack([
                      _title(kInWallet),
                      // Cùng với đó, màn hình này sử dụng Obx() để theo dõi
                      // sự thay đổi trong các biến Rx và tự động
                      // cập nhật giao diện khi có sự thay đổi trong trạng thái.
                      Obx(
                        () =>
                            controller.loading.value
                                ? _loading(3)
                                : _itemMyWallet(),
                      ),
                    ]),
                    () => VStack([
                      _title(kPendingWallet),
                      Obx(
                        () =>
                            controller.loading.value
                                ? _loading(1)
                                : _itemPendingWallet(),
                      ),
                    ]),
                    () => null,
                  ][index](),
              // return SizedBox(height: Get.height, child: _itemReNew());
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemMyWallet() =>
  // Obx giúp theo dõi các biến Rx (như controller.listCurrency),
  // tự động cập nhật UI khi dữ liệu thay đổi.
  Obx(
    () =>
        controller.listCurrency.isNotEmpty
            ? ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.listCurrency.length,
              shrinkWrap: true,
              itemBuilder:
                  (_, index) =>
                      ItemCurrency(model: controller.listCurrency[index]),
            )
            : VxBox().make(),
  );

  // _itemMyWallet(), đây là phần hiển thị các giao dịch đang chờ (pending) trong controller.listPending.
  // Các item trong danh sách sẽ được render lại khi có sự thay đổi trong dữ liệu.
  Widget _itemPendingWallet() => Obx(
    () =>
        controller.listPending.isNotEmpty
            ? ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.listPending.length,
              shrinkWrap: true,
              itemBuilder:
                  (_, index) => ItemCurrency(
                    model: controller.listPending[index],
                    isPending: true,
                  ),
            )
            : VxBox().make(),
  );

  Widget _topInfo() => Obx(
    () =>
    //  là một widget tùy chỉnh hiển thị tổng giá trị ví và các thông tin liên quan
    ItemTotalValue(
      type: kSummary,
      onClickShowHide: () {
        controller.isShowHideMoney.value = !controller.isShowHideMoney.value;
      },
      isShowHideMoney: controller.isShowHideMoney.value,
      handleClickByName: (title) {
        print({"handleClickByName --> title": title});

        controller.getKYC(
          type:
              title == kRecharge
                  ? kRecharge
                  : title == kWithdrawal
                  ? kTranfersAmount
                  : kExchangeAmount,
        );
      },
      valueBitBack: controller.valueTotal.value,
    ),
  );

  // Hiển thị tiêu đề cho các phần trong giao diện (ví dụ: kInWallet, kPendingWallet).
  Widget _title(String title) => getLocalize(title)
      .toString()
      .text
      .size(14)
      .color(MyColor.black)
      .bold
      .make()
      .paddingSymmetric(vertical: 16, horizontal: 16);

  // _loading(int listCount): Hiển thị hiệu ứng loading khi dữ liệu đang được tải.
  Widget _loading(int listCount) => ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: listCount,
    itemBuilder:
        ((_, index) =>
            VxBox(
                  child:
                      VxBox(
                            child: HStack([
                              CircleAvatar(
                                radius: 19,
                                backgroundColor: MyColor.graySemi.withOpacity(
                                  0.2,
                                ),
                              ),
                              16.widthBox,
                              Expanded(
                                child:
                                    VxBox()
                                        .width(40)
                                        .height(15)
                                        .color(
                                          MyColor.graySemi.withOpacity(0.2),
                                        )
                                        .make(),
                              ),
                            ]),
                          )
                          .color(MyColor.white)
                          .width(widthScreen(100))
                          .padding(const EdgeInsets.all(16))
                          .withRounded(value: 4)
                          .make(),
                )
                .width(widthScreen(100))
                .withShadow([
                  const BoxShadow(color: MyColor.grayBorder_6, blurRadius: 8),
                ])
                .withRounded(value: 4)
                .padding(const EdgeInsets.all(1))
                .margin(const EdgeInsets.symmetric(horizontal: 16, vertical: 4))
                .make()),
  );
}

/*
  1. Obx được sử dụng để theo dõi sự thay đổi của các biến Rx trong SummaryController.
  2. Khi các biến như controller.loading.value, controller.listCurrency, hoặc controller.listPending thay đổi, 
  3. Obx sẽ giúp tự động làm mới giao diện mà không cần phải gọi thủ công setState().
  4. Obx là một cách hiệu quả và tối ưu để cập nhật giao diện khi sử dụng GetX.
  5. Các Rx variables luôn được thay đổi đúng cách (bằng .value).
 */

/*
Tóm tắt các điểm chính:
1. GetX giúp dễ dàng quản lý và theo dõi các thay đổi trong trạng thái của ứng dụng, đặc biệt là với các biến Rx.
2. Obx() là widget quan trọng trong GetX, giúp tự động cập nhật giao diện khi dữ liệu trong các Rx thay đổi.
3. Sử dụng CustomScrollView kết hợp với CupertinoSliverRefreshControl để cho phép người dùng kéo để làm mới dữ liệu.
 */
