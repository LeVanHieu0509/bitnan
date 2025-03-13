import 'package:bitnan/@core/binding/splash.binding.dart';
import 'package:bitnan/@core/data/local/storage/data.storage.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@core/router/router.dart';
import 'package:bitnan/@share/localize/localize.dart';
import 'package:bitnan/application/theme.dart';
import 'package:bitnan/plugins/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Application là một StatefulWidget, nghĩa là widget này có thể thay đổi
// trạng thái trong suốt vòng đời của ứng dụng (ví dụ: thay đổi ngôn ngữ, theme, v.v.).
class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);

  // createState() trả về _ApplicationState(), nơi chúng ta quản lý trạng thái của widget.
  @override
  createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  Locale locale = const Locale('vi', 'VN');

  // initState() là phương thức khởi tạo khi widget được tạo ra lần đầu tiên.
  @override
  void initState() {
    super.initState();
    initConfig();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder:
          (_, __) => GetMaterialApp(
            navigatorKey: Get.key,
            debugShowCheckedModeBanner: false,
            theme: applicationTheme(),
            initialBinding: SplashBinding(),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: FlutterEasyLoading(child: child),
                // child: GiftBagScreen(),
              );
            },
            initialRoute: ROUTER_SPLASH,
            getPages: Routers.route,
            translations: Localizes(),
            locale: locale,
            fallbackLocale: Localizes.fallbackLocale,
          ),
    );
  }

  // Phương thức này gọi initConfig() để thiết lập cấu hình ban đầu cho ứng dụng,
  // bao gồm việc tải ngôn ngữ người dùng, khởi tạo loading và các cấu hình khác.
  Future initConfig() async {
    // await setBaseUrl();
    await getLang();
    initEasyLoading();
    // await _initServiceMessage();
  }

  // Future _initServiceMessage() async {
  //   final message = await FirebaseMessaging.instance.getInitialMessage();
  //   if (message != null) await _handleOpenApp(message);
  // }

  // static Future _handleOpenApp(RemoteMessage message) async {
  //   print('🔥 Message: $message');
  // }

  Future getLang() async {
    final store = Get.find<DataStorage>();

    print(store.getLang());
    if (store.getLang() == 'vi') {
      setState(() {
        locale = const Locale('vi', 'VN');
      });
    } else {
      setState(() {
        locale = const Locale('en', 'US');
      });
    }
  }
}
