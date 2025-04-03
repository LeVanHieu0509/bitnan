import 'package:bitnan/@share/widget/text/text_gradient.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:bitnan/@core/data/repo/model/currency.model.dart';
import 'package:bitnan/@share/common/debouncer.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/data.utils.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/image/image.widget.dart';
import 'package:bitnan/@share/widget/scaffold.widget.dart';
import 'package:bitnan/@share/widget/text/text_field_border.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';
import 'transfers_reward.controller.dart';

// Màn hình này có nhiệm vụ hiển thị giao diện rút tiền (có thể là ví điện tử hoặc chuyển tiền) và tương tác với người dùng
class TransfersRewardScreen extends GetView<TransfersRewardController> {
  // Đối tượng này được sử dụng để hạn chế việc xử lý các sự kiện liên tục trong khoảng thời gian ngắn (300ms)
  // Thường dùng trong các trường hợp như nhập liệu vào TextField để không làm gửi quá nhiều yêu cầu đến server khi người dùng gõ.
  final debouncer = Debouncer(milliseconds: 300);

  // Chiều cao của màn hình (dựa trên chiều cao của màn hình trừ đi các yếu tố như chiều cao của AppBar và padding trên, dưới của màn hình).
  final fullHeight =
      heightScreen(100) -
      (kToolbarHeight +
          Get.mediaQuery.viewPadding.top +
          Get.mediaQuery.viewPadding.bottom);

  // Các biến xác định chiều cao của nút và banner trên giao diện.
  final heightButton = kHeightButton + kToolbarHeight + kHalfTopButton;
  final heightBanner = 120.h;

  TransfersRewardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Widget tùy chỉnh giống như Scaffold nhưng có thể chứa thêm các tùy chỉnh về màu sắc và hành vi.
    return CustomScaffold(
      resizeToAvoidBottomInset: false,
      appBarColor: MyColor.colorContainer,
      backgroundColor: MyColor.colorContainer,
      titleAppBar: getLocalize(kWithdrawal),
      body: _itemNew(),
    );
  }

  // Nội dung chính của màn hình được gọi thông qua hàm _itemNew()
  // sử dụng VStack (dạng dọc) và chứa:
  Widget _itemNew() =>
      VStack([
        VxBox(
          child: VStack([
            VStack([
                  _itemInputVNCD(),
                  _itemMinWithdraw(),
                  8.heightBox,
                  // Chứa các lựa chọn số tiền rút tùy thuộc vào loại tiền tệ (VNDC hoặc BBC).
                  Wrap(
                    children: [
                      for (var item
                          in controller.currency == kVNDC ? listVNDC : listBBC)
                        _itemAmount(amount: item),
                    ],
                  ).marginSymmetric(horizontal: 16),
                  8.heightBox,
                  // Hiển thị thông tin về các khoản phí giao dịch, số tiền có sẵn để rút, và các giới hạn rút tiền.
                  _itemTextWithdraw(
                    getLocalize(kFeeTransaction),
                    '${moneyFormatSAT(controller.model.config?.fee)} ${controller.currency}',
                  ),
                  //  Được sử dụng để tạo sự thay đổi giao diện khi có sự thay đổi trong trạng thái controller.
                  Obx(
                    () => _itemTextWithdraw(
                      kMoneyWithdraw,
                      '${moneyFormatSAT(controller.availableCoin.value)} ${controller.currency}',
                    ),
                  ),
                  _itemTextWithdraw(
                    kTodayWithdraw,
                    '${moneyFormatSAT(controller.model.config?.maxPerDay)} ${controller.currency}',
                  ),
                  _itemLocalWithdraw(),
                  _itemOnusInfo(),
                  16.heightBox,
                  Obx(
                    () => Visibility(
                      visible: controller.paddingShowKeyBoard.value != 0,
                      child: controller.paddingShowKeyBoard.value.heightBox,
                    ),
                  ),
                ])
                .scrollVertical(
                  physics: const BouncingScrollPhysics(),
                  controller: controller.scrollController,
                )
                .box
                .height(fullHeight - heightButton - heightBanner)
                .make(),
            _itemBanner(),
          ]),
        ).height(fullHeight - heightButton).make(),
        _itemSubmit(),
      ]).box.color(MyColor.colorContainer).height(fullHeight).make();

  // Hiển thị ô nhập liệu cho người dùng nhập số tiền muốn rút
  Widget _itemInputVNCD() =>
      VStack([
        getLocalize(
          kWantWithdraw,
        ).toString().text.size(14.sp).color(MyColor.black).make(),
        HStack([
          ImageCaches(url: controller.model.coins?.icon, height: 25, width: 25),
          8.widthBox,
          Obx(
            () =>
                // Ô nhập liệu cho số tiền rút, với các kiểm tra về số tiền hợp lệ,
                // bao gồm các ràng buộc như số tiền tối thiểu, tối đa và số tiền giữ lại.
                TextFieldBorder(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  onChanged: (val) {
                    if (val.isEmpty || val == '0') {
                      controller.error.value = '';
                    } else {
                      controller.amount.value = replaceAmount(val);
                      final configMin = controller.model.config?.min ?? 0;
                      final configMax = controller.model.config?.max ?? 0;
                      final configMinHold =
                          controller.model.config?.minHold ?? 0;
                      var amount = controller.amount.value;
                      if (amount < configMin) {
                        controller.error.value = getLocalize(
                          kMinDeposit,
                          args: [
                            '${moneyFormatSAT(controller.model.config?.min)} ${controller.currency}',
                          ],
                        );
                      } else {
                        controller.error.value = '';
                        if (amount > configMax) {
                          controller.error.value = getLocalize(
                            kMaxDeposit,
                            args: [
                              '${moneyFormatSAT(configMax)} ${controller.currency}',
                            ],
                          );
                        }

                        if (amount > controller.model.amount - configMinHold) {
                          controller.error.value = getLocalize(
                            kHoldMin,
                            args: [
                              '${moneyFormatSAT(configMinHold)} ${controller.model.currency}',
                            ],
                          );
                        }

                        if (amount > controller.model.amount) {
                          controller.error.value = getLocalize(kInvalidBalance);
                        }
                      }
                    }
                  },
                  inputType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputFormatter: MoneyInputFormatter(mantissaLength: 0),
                  maxLength: controller.maxLength.value,
                  style: MyStyle.typeBold.copyWith(
                    fontSize: 16.sp,
                    color: MyColor.black,
                  ),
                  borderColor: MyColor.colorContainer,
                  color: MyColor.colorContainer,
                  controller: controller.amountController,
                  initialValue: null,
                ).expand(),
          ),
          // Một nút có chữ "Max" để người dùng có thể dễ dàng nhập số tiền tối đa có thể rút.
          GradientText(
            'Max'.toUpperCase(),
            style: MyStyle.typeBold.copyWith(fontSize: 16.sp),
            gradient: const LinearGradient(
              colors: [MyColor.gradientStart, MyColor.gradientStop],
            ),
          ).box.padding(EdgeInsets.symmetric(horizontal: 8.w)).make().onTap(() {
            getMaxVNDC();
          }),
          controller.currency
              .toString()
              .toUpperCase()
              .text
              .size(16.sp)
              .color(MyColor.grayDark_29.withOpacity(0.6))
              .make(),
        ]),
        1.heightBox.box.width(widthScreen(100)).color(MyColor.black).make(),
      ]).box.margin(EdgeInsets.only(left: 16.w, right: 8.w)).make();

  // Hàm getMaxVNDC() có nhiệm vụ tính toán số tiền tối đa mà người dùng có thể rút
  // và cập nhật lại giá trị vào trường nhập liệu,
  // đồng thời kiểm tra và hiển thị lỗi nếu số tiền nhập vào không hợp lệ
  getMaxVNDC() {
    controller.error.value = '';

    // Các giá trị lấy từ cấu hình của mô hình (model), đại diện cho
    // Mức tối thiểu cần có để rút.
    final configMin = controller.model.config?.min ?? 0;
    // Mức tối đa có thể rút.
    final configMax = controller.model.config?.max ?? 0;

    // Số tiền tối thiểu cần giữ lại trong tài khoản sau khi rút
    final configMinHold = controller.model.config?.minHold ?? 0;

    // Kiểm tra nếu số tiền trong tài khoản lớn hơn 0.
    if (controller.model.amount > 0) {
      // Nếu số tiền trong tài khoản nhỏ hơn mức tối thiểu (configMin):
      if (controller.model.amount < configMin) {
        controller.error.value = getLocalize(
          kMinDeposit,
          args: ['${moneyFormatSAT(configMin)} ${controller.currency}'],
        );
        // Đặt lại giá trị trong ô nhập liệu thành số tiền hiện có trong tài khoản
        controller.amountController.text = moneyFormatSAT(
          controller.model.amount,
        );
        // Nếu không có yêu cầu giữ tiền tối thiểu (configMinHold == 0):
      } else if (configMinHold == 0) {
        // Đặt lại giá trị trong ô nhập liệu thành toàn bộ số tiền hiện có trong tài khoản (controller.model.amount).
        controller.amountController.text = moneyFormatSAT(
          controller.model.amount,
        );
      } else {
        // Nếu số tiền cần rút lớn hơn số tiền còn lại sau khi trừ đi số tiền giữ lại
        if (controller.model.amount - configMinHold > configMax) {
          // Nếu số tiền còn lại nhỏ hơn mức tối đa (configMax), gán số tiền tối đa vào ô nhập liệu.
          controller.amountController.text = moneyFormatSAT(configMax);
        } else {
          // Ngược lại, gán số tiền còn lại sau khi trừ đi số tiền giữ lại vào ô nhập liệu
          controller.amountController.text = moneyFormatSAT(
            controller.model.amount - configMinHold,
          );
        }
      }

      // Sau khi tính toán và chọn số tiền phù hợp,
      // hàm cập nhật lại giá trị cho TextField với số tiền đã tính toán,
      // đảm bảo người dùng có thể thấy giá trị đã thay đổi.
      controller.amountController.value = TextEditingValue(
        text: controller.amountController.text,
        selection: TextSelection.fromPosition(
          TextPosition(offset: controller.amountController.text.length),
        ),
      );
    } else {
      // Nếu số tiền trong tài khoản bằng 0, giá trị của ô nhập liệu sẽ được đặt thành "0".s
      controller.amountController.text = '0';
    }
  }

  // Hiển thị lỗi (nếu có) khi nhập số tiền không hợp lệ.
  // Wrap: Chứa các lựa chọn số tiền rút tùy thuộc vào loại tiền tệ (VNDC hoặc BBC).
  Widget _itemMinWithdraw() => VStack([
    8.heightBox,
    Obx(
      () => Visibility(
        visible: controller.error.value.isNotEmpty,
        child:
            controller.error.value
                .toString()
                .text
                .size(14.sp)
                .color(MyColor.colorError)
                .make(),
      ),
    ),
  ]).marginSymmetric(horizontal: 16);

  // có nhiệm vụ hiển thị một khoản tiền (sử dụng amount) và xử lý việc cập nhật giá trị khi người dùng nhấn vào đó
  Widget _itemAmount({required String amount}) {
    return VxBox(
          child: amount.toString().text.size(14.sp).color(MyColor.black).make(),
        )
        // Được áp dụng cho widget VxBox để tạo khoảng cách bên trong của hộp (lề trên/bottom: 6 và lề trái/phải: 8).
        .padding(const EdgeInsets.symmetric(horizontal: 8, vertical: 6))
        .withDecoration(
          BoxDecoration(
            border: Border.all(color: MyColor.grayBorder_15.withOpacity(0.15)),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
        )
        .make()
        .marginOnly(right: 8)
        .onTap(() {
          // Khi người dùng nhấn vào hộp, hàm updateAmount(amount) sẽ được gọi,
          // truyền vào số tiền amount để xử lý việc cập nhật.
          updateAmount(amount);
        });
  }

  // Hàm này thực hiện một loạt kiểm tra để cập nhật số tiền rút,
  // đồng thời xác nhận rằng số tiền nhập vào không vi phạm các điều kiện giới hạn và hiển thị lỗi nếu cần thiết.
  void updateAmount(String val) {
    controller.amount.value = replaceAmount(val);
    var value = val;
    var amount = controller.amount.value;
    final configMax = controller.model.config?.max ?? 0;
    if (controller.model.amount == 0) {
      //Nếu tài khoản không có tiền, sẽ hiển thị lỗi với thông báo kInvalidBalance.
      controller.error.value = getLocalize(kInvalidBalance);
    } else if (amount == configMax) {
      if (amount > controller.model.amount) {
        // Nếu số tiền nhập vào lớn hơn số tiền hiện có trong tài khoản, sẽ hiển thị lỗi kInvalidBalance.
        controller.error.value = getLocalize(kInvalidBalance);
      } else {
        // Nếu số tiền nhập vào đúng bằng configMax, sẽ thông báo rằng số tiền tối đa có thể rút là configMax.
        controller.error.value = getLocalize(
          kMaxDeposit,
          args: ['${moneyFormatSAT(configMax)} ${controller.currency}'],
        );
      }
    } else if (amount > configMax && controller.model.amount > amount) {
      controller.error.value = getLocalize(
        kMaxDeposit,
        args: ['${moneyFormatSAT(configMax)} ${controller.currency}'],
      );
      value = moneyFormatSAT(configMax);
    } else if (amount > controller.model.amount) {
      controller.error.value = getLocalize(kInvalidBalance);
    } else {
      controller.error.value = '';
    }

    // Nếu số tiền nhập vào vượt quá configMax và số tiền trong tài khoản còn lại đủ để rút,
    // hiển thị thông báo rằng số tiền rút không thể vượt quá giới hạn.
    controller.amountController.value = TextEditingValue(
      text: value,
      // Đặt con trỏ của trường nhập liệu vào cuối chuỗi vừa nhập, giúp người dùng tiếp tục thao tác dễ dàng.
      selection: TextSelection.fromPosition(TextPosition(offset: value.length)),
    );
  }

  // Đây là một widget hiển thị một đoạn văn bản đơn giản với tiêu đề (title) và giá trị (value)
  Widget _itemTextWithdraw(String title, String value) => getLocalize(
        title,
        // Lấy bản địa hóa của tiêu đề và truyền vào giá trị để hiển thị
        args: [value],
      )
      .toString()
      .text
      .size(14.sp)
      .color(MyColor.grayDark_29.withOpacity(0.6))
      .make() // Xây dựng widget văn bản.
      .paddingSymmetric(vertical: 4) // Thêm padding dọc với giá trị 4
      .marginSymmetric(horizontal: 16);

  // Đây là một widget hiển thị thông tin liên quan đến "Local Withdraw" (rút tiền tại chỗ)
  // và thông tin "Onus" (có thể là dịch vụ hoặc một loại ví điện tử):
  Widget _itemLocalWithdraw() => VStack([
    getLocalize(kLocalWithdraw)
        .toString()
        .text
        .size(14.sp)
        .color(MyColor.black)
        .make()
        .marginOnly(top: 24, bottom: 16),
    HStack([
      // Hiển thị một hình ảnh (có thể là biểu tượng của Onus).
      const ImageCaches(url: MyImage.ic_onus, height: 24, width: 24),
      8.widthBox,
      // Hiển thị văn bản "ONUS" với kiểu chữ in hoa, cỡ chữ 16.sp, màu đen và đậm.
      'Onus'.toUpperCase().text.size(16.sp).color(MyColor.black).bold.make(),
    ]),
    8.heightBox,
    1.heightBox.box.width(widthScreen(100)).color(MyColor.black).make(),
  ]).marginSymmetric(horizontal: 16);

  // Widget này hiển thị thông tin và cho phép người dùng nhập thông tin tài khoản Onus
  Widget _itemOnusInfo() => VStack([
    getLocalize(kOnusInfo)
        .toString()
        .text
        .size(14.sp)
        .color(MyColor.black)
        .make()
        .paddingOnly(top: 32),
    Obx(
      // Đây là một trường nhập liệu tùy chỉnh cho phép người dùng nhập thông tin về tài khoản Onus
      () => TextFieldBorder(
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        // Chỉ định focusNode cho trường nhập liệu (giúp điều khiển focus).
        focusNode: controller.focusOnus,
        onChanged: (val) {
          controller.errorOnus.value = false;
          controller.account.value = val;
        },
        style: MyStyle.typeBold.copyWith(fontSize: 16.sp, color: MyColor.black),
        // Được sử dụng để điều khiển trường nhập liệu
        controller: controller.onusController,
        borderColor: MyColor.colorContainer,
        color: MyColor.colorContainer,
        enable: controller.editableEmail.value,
        initialValue: null, // Không có giá trị ban đầu cho trường nhập liệu
      ),
    ),
    1.heightBox.box.width(widthScreen(100)).color(MyColor.black).make(),
    Obx(
      () => Visibility(
        visible: controller.errorOnus.value,
        child: getLocalize(controller.mgsOnus.value)
            .toString()
            .text
            .color(MyColor.colorError)
            .size(14.sp)
            .make()
            .paddingSymmetric(vertical: 8),
      ),
    ),
  ]).marginSymmetric(horizontal: 16);

  Widget _itemBanner() => ImageCaches(
        url: controller.bannerOnus,
        height: heightBanner,
        width: widthScreen(100),
      ).box
      .withShadow([const BoxShadow(color: MyColor.grayBorder_6, blurRadius: 8)])
      .margin(const EdgeInsets.symmetric(horizontal: 16))
      .make()
      .onTap(() async {
        await launchUrlString(kUrlVndc);
      });

  Widget _itemSubmit() => VxBox(
        child:
            getLocalize(kWithDraw)
                .toString()
                .text
                .bold
                .size(16.sp)
                .color(MyColor.white)
                .makeCentered(),
      )
      .withDecoration(getDecoration())
      .height(kHeightButton)
      .width(widthScreen(100) - kToolbarHeight)
      .margin(
        const EdgeInsets.only(
          left: kToolbarHeight,
          right: kToolbarHeight,
          bottom: kToolbarHeight,
          top: kHalfTopButton,
        ),
      )
      .makeCentered()
      .onTap(() {
        hideKeyboard();
        submitButton();
      });

  getError() {
    return controller.error.value.isNotEmpty ||
            controller.amount.value == 0 ||
            controller.model.amount == 0
        ? true
        : false;
  }

  double replaceAmount(String val) {
    return double.tryParse(val.replaceAll(',', '')) ?? 0;
  }

  // Hàm submitButton() trong đoạn mã trên xử lý logic khi người dùng nhấn nút "Submit"
  // để thực hiện yêu cầu giao dịch (rút tiền)
  void submitButton() async {
    //Lấy giá trị số tiền và tài khoản
    String account = controller.account.value.toString();

    //  Lấy giá trị số tiền từ ô nhập liệu, nếu không rỗng thì chuyển đổi nó sang kiểu double sau khi loại bỏ dấu phẩy.
    if (controller.amountController.text.isNotEmpty) {
      controller.amount.value = double.parse(
        controller.amountController.text.toString().replaceAll(',', ''),
      );
    }
    double amount = controller.amount.value;

    // Lấy thông tin cấu hình từ model (bao gồm các giá trị như số tiền tối thiểu, tối đa, và số tiền cần giữ lại).
    ConfigModel? config = controller.model.config;
    // Lấy thông tin loại tiền tệ từ controller
    String currency = controller.currency;

    // Nếu số tiền là 0 hoặc số dư tài khoản là 0
    if (amount == 0 || amount == 0.0 || controller.model.amount == 0) {
      if (controller.model.amount > 0) {
        controller.error.value = getLocalize(
          kMinDeposit,
          args: ['${moneyFormatSAT(controller.model.config?.min)} $currency'],
        );
      } else {
        controller.error.value = getLocalize(kInvalidBalance);
      }
      // Nếu tài khoản rỗng
    } else if (account.isEmpty) {
      controller.showErrorAccount();
      // Nếu có lỗi đã được hiển thị trước đó (controller.error.value.isNotEmpty)
    } else if (controller.error.value.isNotEmpty) {
      return;
      // Nếu số tiền nhỏ hơn mức tối thiểu (config?.min):
    } else if (amount < (config?.min ?? 0)) {
      controller.error.value = getLocalize(
        kMinDeposit,
        args: ['${moneyFormatSAT(controller.model.config?.min)} $currency'],
      );
      // Nếu tài khoản không hợp lệ (bao gồm độ dài tài khoản không phải là 10 ký tự hoặc không chứa dấu '@'):
    } else if (account.length != 10 && !account.contains('@')) {
      controller.showErrorAccount();
      controller.mgsOnus.value = kOnusNotFound;
      // Nếu tài khoản là email nhưng không hợp lệ:
    } else if (account.contains('@') && !validEmail(account.trim())) {
      controller.showErrorAccount();
      controller.mgsOnus.value = kOnusNotFound;
      // Kiểm tra nếu số tiền rút ít hơn số tiền cần giữ lại trong tài khoản
    } else if ((controller.model.amount - amount) < (config?.minHold ?? 0) &&
        config?.minHold != 0) {
      controller.showErrorAmount();
      controller.error.value = getLocalize(
        kHoldMin,
        args: ['${moneyFormatSAT(controller.model.config?.minHold)} $currency'],
      );
      // Nếu số tiền rút lớn hơn số dư tài khoản
    } else if (amount > controller.model.amount) {
      controller.showErrorAmount();
      controller.error.value = getLocalize(kInvalidBalance);
      // Nếu số tiền rút nhỏ hơn mức tối thiểu (config?.min) hoặc lớn hơn mức tối đa (config?.max):
    } else if (amount < (config?.min ?? 0)) {
      controller.showErrorAmount();
      controller.error.value = getLocalize(
        kMinDeposit,
        args: ['${moneyFormatSAT(controller.model.config?.min)} $currency'],
      );
    } else if (amount > (config?.max ?? 0)) {
      controller.error.value = getLocalize(
        kMaxDeposit,
        args: ['${moneyFormatSAT(controller.model.config?.max)} $currency'],
      );
      // Nếu số tiền rút bằng đúng số tiền tối đa hoặc số tiền còn lại sau khi trừ đi số tiền cần giữ lại
    } else if (amount == controller.model.amount - (config?.minHold ?? 0) ||
        amount == (config?.max ?? 0)) {
      debouncer.run(() async {
        hideKeyboard();
        await controller.exchangeInquiry();
      });
    } else {
      debouncer.run(() async {
        // Được gọi trước khi thực hiện giao dịch để ẩn bàn phím
        hideKeyboard();
        await controller.exchangeInquiry();
      });
    }
  }
}

/*
Tóm tắt:
1. Hàm submitButton() kiểm tra một loạt các điều kiện trước khi thực hiện giao dịch (rút tiền), bao gồm:
2. Kiểm tra số tiền và tài khoản có hợp lệ không.
3. Kiểm tra số dư tài khoản và các giới hạn như tối thiểu, tối đa, và số tiền cần giữ lại.
4. Nếu tất cả điều kiện đều hợp lệ, nó sẽ gửi yêu cầu rút tiền qua controller.exchangeInquiry().
5. Sử dụng debouncer.run() để tránh việc gửi quá nhiều yêu cầu quá nhanh.
6. Nếu có lỗi ở bất kỳ bước nào, hàm sẽ dừng và hiển thị thông báo lỗi cho người dùng.
 */
