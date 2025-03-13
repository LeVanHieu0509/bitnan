import 'package:bitnan/@core/data/api/upload.api.dart';
import 'package:bitnan/@core/data/api/user.api.dart';
import 'package:bitnan/@core/data/local/storage/data.storage.dart';
import 'package:bitnan/@core/data/repo/user.repo.dart';
import 'package:bitnan/@core/service/dynamic_link.service.dart';
import 'package:bitnan/screen/splash/splash.controller.dart';
import 'package:get/get.dart';

/*
  - Đoạn code trên sử dụng GetX, 
  một framework quản lý trạng thái và dependency injection cho Flutter.
  - Đây là thư viện GetX. GetX cung cấp các tính năng như dependency injection, routing, 
  và quản lý trạng thái một cách dễ dàng trong Flutter.
 */

// SplashBinding kế thừa Bindings
// Sử dụng lazy loading giúp tiết kiệm tài nguyên,
// bởi vì SplashController chỉ được khởi tạo khi thực sự cần đến (khi màn hình Splash được mở).
class SplashBinding extends Bindings {
  // Bindings là một lớp trong GetX giúp quản lý việc đăng ký (binding) các dependency,
  // tức là các đối tượng hoặc service mà bạn cần trong một màn hình hoặc một lớp nào đó.
  @override
  // Đây là phương thức dependencies() được ghi đè từ Bindings
  // để thực hiện việc đăng ký các dependencies (các đối tượng, service) cho màn hình Splash.
  void dependencies() {
    // Get.put() dùng để đăng ký một đối tượng vào GetX Dependency Injection (DI).
    //  là đối tượng được tạo ra và đưa vào DI.
    Get.put(
      DataStorage(),
      permanent: true,
    ); //permanent: true có nghĩa là đối tượng này sẽ tồn tại trong suốt vòng đời ứng dụng và không bị hủy khi chuyển qua các màn hình khác.
    Get.put(DynamicLinkService(), permanent: true);
    // Get.lazyPut() đăng ký đối tượng SplashController chỉ khi nào nó thực sự được yêu cầu (lazy loading).
    Get.lazyPut(() => SplashController());
    Get.put(UserApi(), permanent: true);
    Get.put(UploadApi(), permanent: true);
    Get.put(UserRepo(Get.find(), Get.find()), permanent: true);
  }
}
