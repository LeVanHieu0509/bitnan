import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitnan/@share/common/password_input.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/image/image.widget.dart';
import 'package:bitnan/@share/widget/scaffold.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:bitnan/screen/auth/signIn/signIn.controller.dart';
import 'package:bitnan/screen/auth/signIn/widgets/modal_biometric.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/*
  SignInScreen kế thừa từ GetView<SignInController>, 
  nghĩa là GetX sẽ tự động tìm và cung cấp instance của SignInController mà không cần phải gọi Get.find().
 */
class SignInScreen extends GetView<SignInController> {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem cấu hình sinh trắc học có được bật hay không (có thể là đăng nhập bằng vân tay hoặc Face ID).
    return controller.configBio.value.isConfigBio
        ? _itemBody(context)
        : SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(height: Get.height + 12, child: _itemBody(context)),
        );
  }

  // CustomScaffold: Đây là một widget tùy chỉnh cho Scaffold, giúp cấu hình các thành phần như appBar, backgroundColor, và body.
  Widget _itemBody(context) {
    return CustomScaffold(
      // Được cấu hình với màu nền tùy chỉnh (MyColor.colorContainer) và có leading tùy chỉnh.
      // Nếu đang sử dụng sinh trắc học (isConfigBio là true), có một nút quay lại (back button).
      appBar: AppBar(
        flexibleSpace: VxBox().color(MyColor.colorContainer).make(),
        centerTitle: true,
        elevation: 0,
        backgroundColor: MyColor.colorContainer,
        automaticallyImplyLeading: true,
        leading:
            (controller.configBio.value.isConfigBio)
                ? IconButton(
                  onPressed: () => goBack(),
                  icon: const Image(
                    image: AssetImage(MyImage.ic_back_left),
                    width: 20,
                    height: 20,
                    color: MyColor.grayDark,
                  ),
                )
                : null,
        title:
            (controller.configBio.value.isConfigBio)
                ? Text(
                  getLocalize(kConfirmPass),
                  style: MyStyle.typeBold.copyWith(
                    color: MyColor.grayDark,
                    fontSize: 16.sp,
                  ),
                )
                : const SizedBox.shrink(),
      ),
      body:
          VStack([
            controller.configBio.value.isConfigBio
                ? 24.h.heightBox
                : 0.heightBox,
            Visibility(
              visible: !controller.configBio.value.isConfigBio,
              child: _itemHello(),
            ),
            getLocalize(kInputPass)
                .toString()
                .text
                .textStyle(
                  MyStyle.typeRegular.copyWith(
                    fontSize: 16.sp,
                    color: MyColor.grayDark.withOpacity(0.5),
                  ),
                )
                .make()
                .pOnly(top: 32.h, bottom: 8.h, left: 24.w),
            _passwordInput(context).paddingSymmetric(horizontal: 24.h),
            16.h.heightBox,
            _itemHorizontalButton(),
            40.h.heightBox,
            Visibility(
              visible: !controller.configBio.value.isConfigBio,
              child: _buildInkWell(
                text: kSignIn,
                action: () {
                  if (controller.passWord.value.length == kMaxPassword) {
                    controller.signInPassCode();
                  } else {
                    showModalSheet(
                      title: kInvalidNumberPass,
                      message: kInputAgain,
                    );
                  }
                },
              ),
            ),
            Visibility(
              visible: !controller.configBio.value.isConfigBio,
              child: 32.h.heightBox,
            ),
            _iconBiometrics(),
            const Spacer(),
            Visibility(
              visible: controller.configBio.value.isConfigBio,
              child: _buildInkWell(
                text: kConfirm,
                action: () {
                  if (controller.passWord.value.length == kMaxPassword) {
                    controller.verifyPassCode();
                  } else {
                    showModalSheet(
                      title: kInvalidNumberPass,
                      message: kInputAgain,
                    );
                  }
                },
              ),
            ),
          ]).box.color(MyColor.colorContainer).make(),
    );
  }

  // Tạo hiệu ứng nhấn cho một vùng chứa.
  // Khi người dùng nhấn vào, hàm action sẽ được gọi (như đăng nhập hoặc chuyển hướng).
  Widget _buildInkWell({VoidCallback? action, required String text}) {
    return InkWell(
      splashColor: Vx.white,
      highlightColor: Vx.white,
      onTap: () => action?.call(),
      child: Container(
        height: 48.h,
        width: Get.width,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 55.w),
        decoration: getDecoration(),
        child: Text(
          // Lấy văn bản đã được dịch trong hệ thống localization của ứng dụng.
          getLocalize(text),
          style: MyStyle.typeBold.copyWith(
            color: MyColor.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  Widget _iconBiometrics() {
    // Đảm bảo rằng nếu showIconAuth thay đổi, widget này sẽ được cập nhật tự động

    return Obx(
      // Đây là widget của GetX để theo dõi sự thay đổi của các reactive variables
      () =>
          //  là một biến reactive và sẽ tự động cập nhật giao diện khi giá trị của nó thay đổi.
          // controller.showIconAuth.value là một biến boolean phản ánh việc có hiển thị biểu tượng sinh trắc học hay không.
          !controller.showIconAuth.value
              ? const SizedBox.shrink()
              :
              // Nếu controller.showIconAuth.value là true, widget ImageCaches sẽ hiển thị biểu tượng sinh trắc học.
              ImageCaches(
                url: controller.availableBiometrics.value.url,
                width: 56.w,
                height: 80.h,
              ).onTap(() async {
                // Khi người dùng nhấn vào biểu tượng sinh trắc học, hàm onTap sẽ được gọi
                if (controller.hasPass.value) {
                  await controller.signInLocal();
                } else {
                  // Nếu controller.hasPass.value là false, nghĩa là người dùng chưa cấu hình passcode cho sinh trắc học,
                  // ứng dụng sẽ hiển thị một modal để yêu cầu người dùng cấu hình sinh trắc học qua ModalBiometric.
                  showModalBottomSheet(
                    context: Get.overlayContext!,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(4.r),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    builder: (_) {
                      // ModalBiometric là một widget tùy chỉnh được sử dụng để hiển thị một modal
                      // (bottom sheet) yêu cầu người dùng cấu hình hoặc cung cấp thông tin về
                      // phương thức sinh trắc học mà họ sử dụng.
                      return ModalBiometric(
                        url: controller.availableBiometrics.value.icon ?? '',
                        message:
                            controller.availableBiometrics.value.title ?? '',
                      );
                    },
                  );
                }
              }).centered(),
    );
  }

  _itemHello() => Obx(
    () =>
        getLocalize(
              kHelloDot,
              args: [controller.fullName.value],
            ) // Nếu tên người dùng thay đổi, giao diện sẽ tự động cập nhật.
            // Lấy văn bản từ hệ thống localization và hiển thị lời chào với tên người dùng.
            .toString()
            .text
            .textStyle(MyStyle.typeBold.copyWith(fontSize: 18.sp))
            .align(TextAlign.center)
            .make(),
  ).paddingOnly(left: 24.w, top: 12.h);

  _itemHorizontalButton() => Obx(
    () =>
        !controller.configBio.value.isConfigBio
            ? HStack([
                  // TODO: hide forgot pass
                  // GradientText(
                  //   getLocalize(kForgetPass),
                  //   style: MyStyle.typeBold,
                  //   gradient: LinearGradient(colors: [
                  //     HexColor('#F54351'),
                  //     HexColor('#D0008F'),
                  //   ]),
                  // ),
                  const Spacer(),
                  _itemButton(
                    name: kExitAccount,
                    action: controller.handleNotMe,
                    color: MyColor.grayDark.withOpacity(0.5),
                  ),
                ], alignment: MainAxisAlignment.spaceBetween).box
                .width(widthScreen(100))
                .make()
                .paddingSymmetric(horizontal: 24.w)
            : const SizedBox.shrink(),
  );

  _itemButton({
    required String name,
    Color? color,
    required VoidCallback action,
  }) => getLocalize(name)
      .toString()
      .text
      .textStyle(MyStyle.typeBold.copyWith(color: color ?? MyColor.blueTeal))
      .make()
      .onTap(action);

  // BBPasswordInput là widget tùy chỉnh để nhập mật khẩu,
  // hỗ trợ tự động lấy tiêu điểm và thay đổi trạng thái của mật khẩu thông qua
  Widget _passwordInput(BuildContext context) => BBPasswordInput(
    appContext: context,
    autoFocus: true,
    focusNode: controller.passwordEditingNode,
    controller: controller.passwordEditingController,
    onChanged: (v) => controller.passWord.value = v,
    onCompleted: (_) => controller.signInPassCode(),
  );
}

/*
  - SignInScreen là một màn hình đăng nhập với 2 phương thức xác thực: Mã PIN và Sinh trắc học (vân tay, nhận diện khuôn mặt).
  - GetX được sử dụng để quản lý trạng thái, điều hướng và các thao tác với controller.
  - VelocityX giúp tạo ra các widget linh hoạt và dễ dàng sử dụng như VStack, HStack, Obx().
  - Các thành phần giao diện như nhập mật khẩu và biểu tượng xác thực sinh trắc học được xây dựng tùy chỉnh để tạo ra trải nghiệm người dùng mượt mà.
 */
