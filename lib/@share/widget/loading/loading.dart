import 'package:bitnan/@share/widget/image/image.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animationController.repeat();
    _animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        RotationTransition(
          turns: _animation,
          child: ImageCaches(
            height: 80.w,
            width: 80.w,
            url: 'assets/images/loading_bg.png',
          ),
        ),
        ImageCaches(
          height: 65.w,
          width: 65.w,
          url: 'assets/images/loading_logo.png',
        ),
      ],
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
