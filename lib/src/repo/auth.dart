import 'package:dio/dio.dart';

import '../config/config.dart';
import '../helper/shared_pref.dart';

class AuthRepo {
  static Future<String?> token() async => await SharedPref().read("uToken");

  static googleSignIn(data) async {
    final String url = '${Configs.baseUrl}/home/auth/login-google';
    try {
      return await Dio().post(url, data: data);
    } catch (e) {
      throw Exception(e);
    }
  }

  static update(data) async {
    final String url = '${Configs.baseUrl}/home/auth/update';
    try {
      return await Dio().put(
        url,
        data: data,
        options: Options(headers: {"x-auth-token": await token()}),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  static getInfo() async {
    final String url = '${Configs.baseUrl}/home/auth/get-info';
    try {
      return await Dio().get(
        url,
        options: Options(headers: {"x-auth-token": await token()}),
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
