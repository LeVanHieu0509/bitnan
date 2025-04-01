import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/image/image.widget.dart';
import 'package:bitnan/@share/widget/scaffold.widget.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/resource/style.resource.dart';

class ContainerEmpty extends StatelessWidget {
  const ContainerEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => CustomScaffold(
    titleAppBar: 'Launchpad',
    isShowLeading: false,
    body: SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageCaches(url: MyImage.ic_system_maintain, width: 287.w),
          spaceHeight(24.h),
          Text(
            getLocalize(kNewFeature),
            textAlign: TextAlign.center,
            style: MyStyle.typeRegular.copyWith(fontSize: 16.sp),
          ),
          spaceHeight(12.h),
          Text(
            getLocalize(kPleaseBackCome),
            textAlign: TextAlign.center,
            style: MyStyle.typeRegular.copyWith(fontSize: 16.sp),
          ),
          spaceHeight(44.h),
        ],
      ),
    ),
  );
}
