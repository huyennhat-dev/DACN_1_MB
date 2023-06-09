import 'package:dio/dio.dart';

import '../config/config.dart';

class ProductRepo {
  static getProduct(data) async {
    final String url = '${Configs.baseUrl}/home/product/$data';
    try {
      return await Dio().get(url);
    } catch (e) {
      throw Exception(e);
    }
  }
}
