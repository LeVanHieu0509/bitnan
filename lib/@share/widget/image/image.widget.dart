import 'dart:io';
import 'package:bitnan/resource/image.resource.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ImageCaches extends StatelessWidget {
  final String? url;
  final String urlError;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final double radius;
  final Color? color;
  final BlendMode? blendMode;
  final BorderRadius? borderRadius;

  const ImageCaches({
    Key? key,
    this.url,
    this.height,
    this.width,
    this.fit,
    this.radius = 0,
    this.color,
    this.blendMode,
    this.borderRadius,
    this.urlError = MyImage.ic_not_found_image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = this.url;
    final width = this.width;
    final height = this.height;

    if (url == null) return Container();
    // TODO: need to optimize here
    errorNetworkImage(context, error, stackTrace) =>
        Image.asset(urlError, fit: fit, height: height, width: width);

    errorCachedNetwork(context, _, error) => Image.network(
      url,
      fit: fit,
      height: height,
      width: width,
      errorBuilder: errorNetworkImage,
    );

    final box = VxBox(
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
        child:
            url.contains('http') || url.contains('https)')
                ? CachedNetworkImage(
                  imageUrl: url,
                  height: height,
                  width: width,
                  fit: fit,
                  color: color,
                  useOldImageOnUrlChange: true,
                  colorBlendMode: blendMode,
                  errorWidget: errorCachedNetwork,
                )
                : url.contains('assets')
                ? Image(
                  image: AssetImage(url),
                  color: color,
                  height: height,
                  width: width,
                  fit: fit,
                  colorBlendMode: blendMode,
                )
                : Image.file(
                  File(url),
                  height: height,
                  width: width,
                  fit: fit,
                  color: color,
                  colorBlendMode: blendMode,
                ),
      ),
    );

    if (height != null) box.height(height);
    if (width != null) box.width(width);

    return box.make();
  }
}
