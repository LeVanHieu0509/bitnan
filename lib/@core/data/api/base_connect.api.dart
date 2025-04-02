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

/*
  Đoạn mã trên là một lớp BaseConnect sử dụng GetConnect để 
  thực hiện các yêu cầu HTTP trong ứng dụng Flutter, 
  với các phương thức GET, POST, PATCH, DELETE cùng các cơ chế xác thực và xử lý lỗi.
 */
class BaseConnect extends GetConnect {
  @override
  void onInit() {
    /*
      Phương thức này được gọi khi đối tượng BaseConnect được khởi tạo. 
      Nó cấu hình client HTTP của GetConnect để sử dụng base URL, 
      thiết lập thời gian chờ, số lần thử lại khi xác thực thất bại, 
      và thêm các chức năng xác thực và sửa đổi yêu cầu HTTP.
     */

    var storage = Get.find<DataStorage>();

    httpClient
      ..baseUrl = BBConfig.instance.base_url
      ..maxAuthRetries = kAuthRetry
      ..timeout = const Duration(seconds: kTimeOut)
      // Đây là một middleware để thêm mã thông báo (token) xác thực vào các yêu cầu HTTP,
      // đồng thời thực hiện cập nhật mã thông báo nếu cần thiết.
      ..addAuthenticator<void>((request) async {
        // Đoạn mã này giúp tự động làm mới token khi nó hết hạn, từ đó đảm bảo các yêu cầu API luôn đi kèm với token hợp lệ
        if (storage.getRefreshToken().isNotEmpty) {
          var res = await get(
            kApiRefreshToken,
            query: {'token': storage.getRefreshToken()},
            decoder: (map) => BaseResponse.fromMap(map),
          );
          if (res.isOk) {
            TokenModel model = TokenModel.fromMap(res.body?.data);
            if (!model.accessToken.isEmptyOrNull) {
              // set token vào trong storage để sử dụng xuyên suốt quá trình app chạy
              await storage.setToken(model);
              request.headers[kApiVersion] = storage.getVersion();
              request.headers[kAuthorization] = '$kBearer ${model.accessToken}';
            }
          }
        }
        return request;
      })
      // Thêm middleware vào tất cả các yêu cầu HTTP để kiểm tra
      // và thêm tiêu đề xác thực (Authorization) và phiên bản API (ApiVersion).
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

  // Đây là phương thức gửi yêu cầu GET đến URL được chỉ định và trả về một BaseResponse
  // Nếu yêu cầu thành công và trả về mã trạng thái kSuccessApi,
  // dữ liệu sẽ được trả về dưới dạng một đối tượng BaseResponse. Nếu không, sẽ trả về lỗi.
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

  // Gửi yêu cầu POST với một body (dữ liệu gửi đi) và nhận về phản hồi dưới dạng BaseResponse.
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

  // Hai phương thức này đều gửi yêu cầu PATCH để cập nhật dữ liệu.
  // Mục đích chính là thực hiện cập nhật dữ liệu trên server.
  Future<BaseResponse> patchRequest(String url, {dynamic body}) async {
    Get.log('[PATCH-BODY] : ${body.toString()}');
    var response = await patch(
      url,
      body,
      decoder: (map) => BaseResponse.fromMap(map),
    );
    if (response.isOk) {
      // Phản hồi từ yêu cầu sẽ được kiểm tra và trả về dưới dạng BaseResponse.
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

  // Gửi yêu cầu DELETE để xóa dữ liệu trên server.
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

  // Phản hồi sẽ được kiểm tra mã trạng thái, nếu không thành công,
  // phương thức sẽ gọi getError() để xử lý lỗi.
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
