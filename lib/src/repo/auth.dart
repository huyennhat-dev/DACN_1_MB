import 'package:dio/dio.dart';

import '../config/config.dart';

class AuthRepo {
  static googleSignIn(data) async {
    final String url = '${Configs.baseUrl}/home/auth/login-google';
    try {
      return await Dio().post(url, data: data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
