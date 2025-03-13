import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/application/lifecycle_event_handler.dart';

class MainController extends GetxController {
  final tabController = PageController();

  var currentIndex = 0.obs;
  final pages = <String>[
    ROUTER_HOME,
    ROUTER_SUMMARY,
    ROUTER_CONNECT,
    ROUTER_GIFT_BAG,
    ROUTER_LAUNCHPAD,
  ];

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(resumeCallBack: checkMaintenance),
    );
  }

  Future<void> changePage(int index) async {
    if (currentIndex.value == index) return;

    currentIndex.value = index;
    final targetPage = pages[index];

    if (targetPage == ROUTER_HOME) {
      // Get.find<HomeController>().checkInAppleReview();
      // Get.find<HomeController>().onNewReload();
    }

    if (targetPage == ROUTER_PERSON) {
      // Get.find<PersonController>().getInfo();
    }

    if (targetPage == ROUTER_SUMMARY) {
      // Get.find<SummaryController>().getInfo();
    }

    tabController.jumpToPage(index);
  }

  Future<void> reloadProfile() async {
    await goToAndRemoveAll(screen: ROUTER_MAIN_TAB);
    currentIndex.value = 0;
    // await Get.find<HomeController>().getProfile();
  }
}
