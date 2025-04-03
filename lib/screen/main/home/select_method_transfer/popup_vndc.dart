import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/button/submit.button.dart';
import 'package:bitnan/@share/widget/image/image.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:url_launcher/url_launcher_string.dart';

/*
   để hiển thị thông tin về tài khoản ONUS và các tùy chọn cho người dùng liên quan đến tài khoản ONUS
    khi họ muốn rút tài sản từ Bitback. 
   Nó cung cấp hai nút để người dùng có thể lựa chọn, 
   và một số thông tin liên quan đến tài khoản ONUS.
 */
class PopupVNDC extends StatelessWidget {
  // : Một tham số callback tùy chọn.
  // Nếu được cung cấp, hàm action sẽ được gọi khi người dùng nhấn vào nút "Tôi đã có tài khoản ONUS".
  final VoidCallback? action;

  const PopupVNDC({Key? key, this.action}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: MyColor.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    // Hiển thị một hình ảnh biểu tượng (có thể là biểu tượng của ONUS).
                    const ImageCaches(
                      height: 54,
                      width: 54,
                      url: MyImage.ic_onus,
                    ),
                    spaceHeight(16),
                    Text(
                      'Bạn đã có tài khoản ONUS chưa?',
                      style: MyStyle.typeBold.copyWith(fontSize: 16),
                    ),
                    spaceHeight(8),
                    Text(
                      'Để rút tài sản từ Bitback',
                      style: MyStyle.typeRegular.copyWith(fontSize: 16),
                    ),
                    Text(
                      'bạn cần có tài khoản ONUS',
                      style: MyStyle.typeRegular.copyWith(fontSize: 16),
                    ),
                    spaceHeight(16),
                  ],
                ),
              ],
            ),
            ButtonSubmit(
              color: MyColor.blueTeal,
              title: 'Tôi đã có tài khoản ONUS',
              textColor: MyColor.white,
              width: double.infinity,
              marginHorizontal: 8,
              action: () {
                goBack();
                action?.call();
              },
              marginVertical: 12,
              radius: 8,
            ),
            ButtonSubmit(
              color: MyColor.white,
              title: 'Tôi chưa có tài khoản ONUS',
              textColor: MyColor.blueTeal,
              width: double.infinity,
              borderColor: MyColor.blueTeal,
              borderWidth: 1,
              marginVertical: 0,
              marginHorizontal: 8,
              radius: 8,
              action: () {
                goBack();
                _launchInBrowser();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchInBrowser() async {
    await launchUrlString(kUrlVndc);
  }
}


/*
Tóm tắt:
1. PopupVNDC là một pop-up giao diện người dùng cho phép người dùng lựa chọn một trong hai hành động:
2. Nếu đã có tài khoản ONUS, nhấn nút để thực hiện hành động nào đó (do callback action xác định).
3. Nếu chưa có tài khoản ONUS, nhấn nút để được chuyển đến trang web đăng ký tài khoản ONUS.
 */