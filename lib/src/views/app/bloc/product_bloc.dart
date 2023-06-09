import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/product.dart';
import '../../../repo/product.dart';

abstract class ProductEvent {}

class GetProduct extends ProductEvent {
  final String pId;

  GetProduct({required this.pId});
}

class ProductState {
  final Product product;
  ProductState({required this.product});
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductState(product: Product())) {
    on<GetProduct>((event, emit) => _getProduct(emit, event));
  }

  Future<void> _getProduct(Emitter<ProductState> emit, GetProduct event) async {
    try {
      final rs = await ProductRepo.getProduct(event.pId);
      final data = rs.data["product"];
      final sale = data['sale'].toDouble();
      final star = data['star'].toDouble();
      final photos = List<String>.from(
          data['photos']?.map((photo) => photo.toString()) ?? []);

      emit(ProductState(
          product: Product(
              sId: data['_id'],
              name: data['name'],
              photos: photos,
              author: data['author'],
              price: data['price'],
              quantity: data['quantity'],
              purchases: data['purchases'],
              sale: sale,
              star: star,
              description: data['description'])));
    } catch (e) {
      throw Exception(e);
    }
  }
}
