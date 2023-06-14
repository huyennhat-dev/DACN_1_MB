import 'package:dio/dio.dart';

import '../config/config.dart';

class HomeRepo {
  static getRecommendProduct() async {
    final String url = '${Configs.baseUrl}/home/index/recommend-product';
    try {
      return await Dio().get(url);
    } catch (e) {
      throw Exception(e);
    }
  }

  static seachProduct(searchValue, page) async {
    final String url =
        '${Configs.baseUrl}/home/product/search/search?key=$searchValue&page=$page';
    try {
      return await Dio().get(url);
    } catch (e) {
      throw Exception(e);
    }
  }
}
