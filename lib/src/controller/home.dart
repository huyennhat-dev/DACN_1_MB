import 'dart:convert';

import '../repo/home.dart';

class HomeController {
  getRecommendProduct() async {
    try {
      return await HomeRepo.getRecommendProduct();
    } catch (e) {
      throw Exception(e);
    }
  }
}
