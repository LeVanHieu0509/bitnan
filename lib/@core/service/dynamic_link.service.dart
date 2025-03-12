// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:uni_links/uni_links.dart';

class DynamicLinkService {
  Future<String> handleDynamicLinks() async {
    var refCode = '';
    // var data = await FirebaseDynamicLinks.instance.getInitialLink();
    // var deepLink = data?.link;
    // if (deepLink != null) {
    //   var isCheck = deepLink.pathSegments.contains('deeplink');
    //   refCode = isCheck ? (deepLink.queryParameters['refCode'] ?? '') : '';
    //   if (refCode.isEmpty && deepLink.queryParameters.containsKey('refCode')) {
    //     refCode = deepLink.queryParameters['refCode'] ?? '';
    //   }
    // }
    return refCode;
  }

  Future<String> createDeepLink(String refCode) async {
    // const bundleId = String.fromEnvironment('PRODUCT_BUNDLE_IDENTIFIER');
    // final dynamicLinkParams = DynamicLinkParameters(
    //   link: Uri.parse('https://bitback.vn/deeplink?refCode%3D$refCode'),
    //   uriPrefix: 'https://bitbackvn.page.link',
    //   androidParameters: const AndroidParameters(packageName: bundleId),
    //   iosParameters: const IOSParameters(
    //     bundleId: bundleId,
    //     appStoreId: '1564273275',
    //   ),
    // );
    // final shortenedLink = await FirebaseDynamicLinks.instance.buildShortLink(
    //   dynamicLinkParams,
    //   shortLinkType: ShortDynamicLinkType.unguessable,
    // );
    // return shortenedLink.shortUrl.toString();
    return "1";
  }

  Future<String> initUniLinks() async {
    var refCode = '';
    // try {
    //   var link = await getInitialLink();
    //   if (link != null && link.isNotEmpty) {
    //     var deepLink = link.split('&')[0];
    //     if (deepLink.isNotEmpty) {
    //       var paramRefCode = deepLink.split('?')[2];
    //       if (paramRefCode.isNotEmpty) refCode = paramRefCode.split('%3D')[1];
    //     }
    //   }
    // } catch (e) {
    //   // Ignored
    // }
    return refCode;
  }
}
