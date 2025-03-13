import 'dart:io';

import 'package:bitnan/@core/data/api/upload.api.dart';
import 'package:bitnan/@core/data/api/user.api.dart';
import 'package:bitnan/@core/data/repo/model/token.model.dart';
import 'package:bitnan/@core/data/repo/request/pass_code.request.dart';
import 'package:bitnan/@core/data/repo/response/base.response.dart';
import 'package:bitnan/@share/constants/value.constant.dart';

class UserRepo {
  final UserApi userApi;
  final UploadApi uploadApi;

  UserRepo(this.userApi, this.uploadApi);

  Future<BaseResponse> verifyPassCode(PassCodeRequest request) async {
    var res = await userApi.verifyPassCode(request);
    return res
      ..data =
          res.status == kSuccessApi
              ? res.data is bool
                  ? res.data
                  : TokenModel.fromMap(res.data)
              : null;
  }
}
