import 'package:bitnan/@share/widget/container_empty.dart';
import 'package:bitnan/screen/main/home/summary/summary.screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/screen/main/main.controller.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../resource/color.resource.dart';
import '../../resource/image.resource.dart';

class MainScreen extends GetWidget<MainController> {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // const HomeScreen(),
          // // BitPlayScreen(onBack: false),
          // const SummaryScreen(),
          // ConnectScreen(),
          // // const GiftBagScreen(),
          const ContainerEmpty(),
          const SummaryScreen(),
          const ContainerEmpty(),
          const ContainerEmpty(),
        ],
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Theme(
        // Must use Theme to change BottomNavigationBar's background color
        data: Theme.of(context).copyWith(canvasColor: Colors.white),
        child: Obx(() => _bottomNavBar()),
      ),
    );
  }

  Widget _bottomNavBar() => BottomNavigationBar(
    currentIndex: controller.currentIndex.value,
    onTap: controller.changePage,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: MyColor.pinkNew,
    showUnselectedLabels: true,
    unselectedFontSize: 12,
    selectedFontSize: 12,
    items: [
      BottomNavigationBarItem(
        label: getLocalize(kHome),
        icon: _icon(MyImage.ic_tabbar_home),
        activeIcon: _icon(MyImage.ic_tabbar_home_selected, true),
      ),
      BottomNavigationBarItem(
        label: getLocalize(kTabbarwallet),
        icon: _icon(MyImage.ic_tabbar_wallet),
        activeIcon: _icon(MyImage.ic_tabbar_wallet_selected, true),
      ),
      BottomNavigationBarItem(
        label: getLocalize(kTabBarIntro),
        icon: _icon(MyImage.ic_tabbar_intro),
        activeIcon: _icon(MyImage.ic_tabbar_intro_selected, true),
      ),
      BottomNavigationBarItem(
        label: getLocalize(kGiftBag),
        icon: _icon(MyImage.ic_tabbar_gift_bag),
        activeIcon: _icon(MyImage.ic_tabbar_gift_bag_selected, true),
      ),
      // BottomNavigationBarItem(
      //   label: getLocalize(kRanking),
      //   icon: _icon(MyImage.ic_rank_black),
      //   activeIcon: _icon(MyImage.ic_rank_selected, true),
      // ),
      // BottomNavigationBarItem(
      //   label: getLocalize(kTabbarLaunchpad),
      //   icon: _icon(MyImage.ic_tabbar_launchpad),
      //   activeIcon: _icon(MyImage.ic_tabbar_launchpad_selected, true),
      // ),
    ],
  );

  Widget _icon(String path, [active = false]) =>
      path.isNotEmpty
          ? Image(image: AssetImage(path))
              .w(active ? 30 : 26)
              .h(active ? 30 : 26)
              .marginOnly(top: active ? 6 : 8, bottom: active ? 2 : 4)
          : VxBox().make();
}
