import 'dart:convert';
import 'package:get/get.dart';
import 'package:bitnan/config.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:bitnan/@core/data/api/url.api.dart';
import 'package:bitnan/@core/data/local/storage/data.storage.dart';
import 'package:bitnan/@core/data/repo/model/token.model.dart';
import 'package:bitnan/@core/data/repo/response/base.response.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';

class BaseConnect extends GetConnect {
  @override
  void onInit() {
    var storage = Get.find<DataStorage>();
    httpClient
      ..baseUrl = BBConfig.instance.base_url
      ..maxAuthRetries = kAuthRetry
      ..timeout = const Duration(seconds: kTimeOut)
      ..addAuthenticator<void>((request) async {
        if (storage.getRefreshToken().isNotEmpty) {
          var res = await get(
            kApiRefreshToken,
            query: {'token': storage.getRefreshToken()},
            decoder: (map) => BaseResponse.fromMap(map),
          );
          if (res.isOk) {
            TokenModel model = TokenModel.fromMap(res.body?.data);
            if (!model.accessToken.isEmptyOrNull) {
              await storage.setToken(model);
              request.headers[kApiVersion] = storage.getVersion();
              request.headers[kAuthorization] = '$kBearer ${model.accessToken}';
            }
          }
        }
        return request;
      })
      ..addRequestModifier<void>((request) {
        Get.log('[URL] : ${request.url}');
        var token = storage.getAccessToken();
        if (token.isNotEmpty) {
          request.headers[kAuthorization] = '$kBearer $token';
        }
        request.headers[kApiVersion] = storage.getVersion();
        Get.log('[HEADER] : ${request.headers.toString()}');
        return request;
      });
  }

  Future<BaseResponse> getResponse(String url, {dynamic query}) async {
    try {
      Get.log('[GET-QUERY] : $query');
      var response = await get(
        url,
        query: query,
        decoder: (map) => BaseResponse.fromMap(map),
      );
      if (response.isOk) {
        Get.log('[RESPONSE] : ${response.body?.toMap()}');
        return response.body?.toMap()['status'] == kSuccessApi
            ? response.body!
            : BaseResponse.fromMap(response.body?.toMap());
      } else {
        Get.log('[ERROR] : ${response.bodyString}');
        hideLoading();
        return BaseResponse.fromMap(
          response.bodyString != null ? jsonDecode(response.bodyString!) : null,
        );
      }
    } finally {
      Get.log('==================[END Request on $url]=======================');
    }
  }

  Future<BaseResponse> postRequest(String url, {dynamic body}) async {
    Get.log('[POST-BODY] : ${body.toString()}');
    var response = await post(
      url,
      body,
      decoder: (map) => BaseResponse.fromMap(map),
    );
    if (response.isOk) {
      Get.log('[RESPONSE] : ${response.body?.toMap()}');
      return response.body?.toMap()['status'] == kSuccessApi
          ? response.body!
          : BaseResponse.fromMap(response.body?.toMap());
    } else {
      return getError(response);
    }
  }

  Future<BaseResponse> patchRequest(String url, {dynamic body}) async {
    Get.log('[PATCH-BODY] : ${body.toString()}');
    var response = await patch(
      url,
      body,
      decoder: (map) => BaseResponse.fromMap(map),
    );
    if (response.isOk) {
      Get.log('[RESPONSE] : ${response.body?.toMap()}');
      return response.body?.toMap()['status'] == kSuccessApi
          ? response.body!
          : BaseResponse.fromMap(response.body?.toMap());
    } else {
      return getError(response);
    }
  }

  Future<BaseResponse> patchRequest2(String url, {dynamic body}) async {
    Get.log('[PATCH-BODY] : ${body.toString()}');
    var response = await patch(
      url,
      body,
      decoder: (map) => BaseResponse.fromMap(map),
    );
    if (response.isOk) {
      Get.log('[RESPONSE] : ${response.body?.toMap()}');
      return response.body?.toMap()['status'] == kSuccessApi
          ? response.body!
          : BaseResponse.fromMap(response.body?.toMap());
    } else {
      Get.log('[ERROR] : ${response.bodyString}');
      hideLoading();
      return BaseResponse.fromMap(
        response.bodyString != null ? jsonDecode(response.bodyString!) : null,
      );
    }
  }

  Future<BaseResponse> deleteRequest(String url) async {
    Get.log('[DELETE-BODY] : ${url.toString()}');
    var response = await delete(
      url,
      decoder: (map) => BaseResponse.fromMap(map),
    );
    if (response.isOk) {
      Get.log('[RESPONSE] : ${response.body?.toMap()}');
      return response.body?.toMap()['status'] == kSuccessApi
          ? response.body!
          : BaseResponse.fromMap(response.body?.toMap());
    } else {
      return getError(response);
    }
  }

  BaseResponse getError(Response<BaseResponse> response) {
    final bodyString = response.bodyString;
    Get.log('[ERROR] : $bodyString');
    hideLoading();
    if (bodyString == null) {
      Get.snackbar(
        getLocalize(kNotify),
        getLocalize(kError),
        snackPosition: SnackPosition.BOTTOM,
      );
      return BaseResponse.fromMap(
        jsonEncode({'status': 500, 'message': 'CREATE_ERROR_INVALID'}),
      );
    } else {
      return BaseResponse.fromMap(jsonDecode(bodyString));
    }
  }
}
