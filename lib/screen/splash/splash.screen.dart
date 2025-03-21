import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/image/image.widget.dart';
import 'package:bitnan/@share/widget/scaffold.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/screen/splash/splash.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

// GetWidget: Dùng khi bạn muốn truy cập controller nhưng không cần khai báo ngay từ đầu
// Đây là một widget stateless sử dụng GetX
// GetWidget được sử dụng để lấy controller mà không cần phải khai báo nó trong constructor
// SplashController sẽ được tự động lấy từ GetX thông qua Dependency Injection (DI) mà không cần phải gọi Get.find() mỗi lần
// SplashController sẽ được kết nối với widget này thông qua kiểu GetWidget<SplashController>.
class SplashScreen extends GetWidget<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);

  // Controller được lấy bằng Get.find() trong hàm build()
  @override
  Widget build(BuildContext context) {
    print(controller.refCode);

    return CustomScaffold(
      isShowLeading: false, // Tắt phần leading của AppBar nếu có
      backgroundColor: Colors.white, // Đặt màu nền của màn hình là màu trắng.
      body:
          // tạo ra một Column với các widget xếp theo chiều dọc.
          VStack(
            [
              const Spacer(),
              // Đây là cách sử dụng flutter_screenutil để tạo
              // một SizedBox với chiều cao được tính toán tự động dựa trên kích thước màn hình.
              SizedBox(height: 44.h),

              // Đây là widget tuỳ chỉnh dùng để hiển thị hình ảnh
              ImageCaches(
                height: 80.h,
                width: 80.w,
                url: MyImage.logo_bit_back,
              ),
              const Spacer(),
              'ANH HIEU 12345678'
                  .text
                  .bold //sử dụng VelocityX để tạo Text widget
                  .size(
                    16.sp,
                  ) //16.sp là đơn vị kích thước chữ được tính tự động với ScreenUtil.
                  .color(MyColor.black)
                  .make(),
              SizedBox(height: 44.h),
            ],
            crossAlignment: CrossAxisAlignment.center,
          ).box.width(widthScreen(100)).make(),
    );
  }
}
