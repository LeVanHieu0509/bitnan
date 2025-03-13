import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:bitnan/@core/data/api/url.api.dart';
import 'package:bitnan/@core/data/local/storage/data.storage.dart';
import 'package:bitnan/@core/data/repo/response/base.response.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/config.dart';

class UploadApi {
  Future<BaseResponse> postImages(File file, int type) async {
    var token = Get.find<DataStorage>().getAccessToken();
    var data = dio.FormData.fromMap({'file': await initFile(file.path)});
    try {
      var client =
          dio.Dio()
            ..interceptors.add(
              dio.LogInterceptor(
                responseBody: true,
                request: true,
                error: true,
                requestBody: true,
              ),
            );
      var res = await client.post(
        '${BBConfig.instance.base_url}$kApiUploadImage?type=$type',
        data: data,
        options: dio.Options(headers: {kAuthorization: '$kBearer $token'}),
      );
      return BaseResponse.fromMap(res.data);
    } on dio.DioError catch (e) {
      return BaseResponse.fromMap(e.response);
    }
  }

  Future<BaseResponse> postKycCheck(List<String> listImage) async {
    var token = Get.find<DataStorage>().getAccessToken();
    dio.FormData fromData;
    if (listImage.length == 2) {
      fromData = dio.FormData.fromMap({
        'selfieVideo': await initFile(listImage[0]),
        'docType': '${getTypeKyc(listImage[1])}',
      });
    } else if (listImage.length == 3) {
      fromData = dio.FormData.fromMap({
        'photoFront': await initFile(listImage[0]),
        'photoBack': await initFile(listImage[1]),
        'docType': '${getTypeKyc(listImage[2])}',
      });
    } else {
      fromData = dio.FormData.fromMap({
        'photoFront': await initFile(listImage[0]),
        'photoBack': await initFile(listImage[1]),
        'selfieVideo': await initFile(listImage[2]),
        'docType': '${getTypeKyc(listImage[3])}',
      });
    }
    try {
      var client =
          dio.Dio()
            ..interceptors.add(
              dio.LogInterceptor(
                responseBody: true,
                request: true,
                error: true,
                requestBody: true,
              ),
            );
      var res = await client.post(
        '${BBConfig.instance.base_url}$kApiKycSubmit',
        data: fromData,
        options: dio.Options(headers: {kAuthorization: '$kBearer $token'}),
      );
      return BaseResponse.fromMap(res.data);
    } on dio.DioError catch (e) {
      return BaseResponse.fromMap(e.response);
    }
  }
}
