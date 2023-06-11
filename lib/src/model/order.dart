import 'orderStatus.dart';
import 'product.dart';

class Order {
  String? sId;
  String? user;
  List<Products>? products;
  int? totalPrice;
  String? paymentMethod;
  OrderStatus? orderStatus;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Order(
      {this.sId,
      this.user,
      this.products,
      this.totalPrice,
      this.paymentMethod,
      this.orderStatus,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Order.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    totalPrice = json['totalPrice'];
    paymentMethod = json['paymentMethod'];
    orderStatus = json['orderStatus'] != null
        ? OrderStatus.fromJson(json['orderStatus'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['totalPrice'] = totalPrice;
    data['paymentMethod'] = paymentMethod;
    if (orderStatus != null) {
      data['orderStatus'] = orderStatus!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Products {
  Product? product;
  int? quantity;
  int? price;
  String? sId;

  Products({this.product, this.quantity, this.price, this.sId});

  Products.fromJson(Map<String, dynamic> json) {
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    quantity = json['quantity'];
    price = json['price'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['quantity'] = quantity;
    data['price'] = price;
    data['_id'] = sId;
    return data;
  }
}
