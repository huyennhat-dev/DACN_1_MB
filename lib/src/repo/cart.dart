import 'package:app_client/src/helper/shared_pref.dart';
import 'package:dio/dio.dart';

import '../config/config.dart';

class CartRepo {
  static Future<String?> token() async => await SharedPref().read("uToken");

  static fetchCart() async {
    final String url = '${Configs.baseUrl}/home/cart/show';
    try {
      return await Dio().get(
        url,
        options: Options(headers: {"x-auth-token": await token()}),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  static addToCart(data) async {
    final String url = '${Configs.baseUrl}/home/cart/create';
    try {
      return await Dio().post(url,
          data: data,
          options: Options(headers: {"x-auth-token": await token()}));
    } catch (e) {
      throw Exception(e);
    }
  }

  static updateQuantity(id, quantity) async {
    final String url = '${Configs.baseUrl}/home/cart/update-quantity';
    try {
      return await Dio().put(url,
          data: {"id": id, "quantity": quantity},
          options: Options(headers: {"x-auth-token": await token()}));
    } catch (e) {
      throw Exception(e);
    }
  }

  static delCart(id) async {
    final String url = '${Configs.baseUrl}/home/cart/delete/$id';
    try {
      return await Dio().delete(url,
          options: Options(headers: {"x-auth-token": await token()}));
    } catch (e) {
      throw Exception(e);
    }
  }

  static vnpayMethod(data) async {
    final String url = '${Configs.baseUrl}/home/order/create-url';
    try {
      return await Dio().post(url,
          data: data,
          options: Options(headers: {"x-auth-token": await token()}));
    } catch (e) {
      throw Exception(e);
    }
  }

  static getOrderData() async {
    final String url = '${Configs.baseUrl}/home/order/user-order';
    try {
      return await Dio()
          .get(url, options: Options(headers: {"x-auth-token": await token()}));
    } catch (e) {
      throw Exception(e);
    }
  }
}
