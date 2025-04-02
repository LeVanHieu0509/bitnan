import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/button/submit.button.dart';
import 'package:bitnan/@share/widget/image/image.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PopupWallet extends StatelessWidget {
  final String account;
  final VoidCallback? action;

  const PopupWallet({Key? key, this.action, required this.account})
    : super(key: key);

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
                    const ImageCaches(
                      height: 54,
                      width: 54,
                      url: MyImage.ic_onus,
                    ),
                    spaceHeight(16),
                    Text(
                      getLocalize(kHasAccountYet, args: [account]),
                      style: MyStyle.typeBold.copyWith(fontSize: 16),
                    ),
                    spaceHeight(8),
                    Text(
                      getLocalize(kTransferBitBack),
                      style: MyStyle.typeRegular.copyWith(fontSize: 16),
                    ),
                    Text(
                      getLocalize(kNeedAccount, args: [account]),
                      style: MyStyle.typeRegular.copyWith(fontSize: 16),
                    ),
                    spaceHeight(16),
                  ],
                ),
              ],
            ),
            ButtonSubmit(
              color: MyColor.blueTeal,
              title: getLocalize(kHasAccount, args: [account]),
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
              title: getLocalize(kNoHasAccount, args: [account]),
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
