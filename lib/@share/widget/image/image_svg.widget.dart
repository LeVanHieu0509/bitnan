import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageSvg extends StatelessWidget {
  final String path;
  final double h, w;

  const ImageSvg({Key? key, required this.path, this.h = 12, this.w = 12})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(path, height: h, width: w);
  }
}
