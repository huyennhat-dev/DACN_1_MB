import 'package:app_client/src/repo/cart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../helper/toast.dart';
import '../../../model/cart.dart';
import '../../../model/product.dart';

abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final Product product;
  final int? quantity;

  AddToCartEvent({required this.product, this.quantity});
}

class UpdateCartItemEvent extends CartEvent {
  final Product product;
  final int number;

  UpdateCartItemEvent({required this.product, required this.number});
}

class RemoveFromCartEvent extends CartEvent {
  final Product product;

  RemoveFromCartEvent(this.product);
}

class FetchCartEvent extends CartEvent {}

class ClearCartEvent extends CartEvent {}

class CartState {
  final List<Cart> carts;
  final double totalPrice;
  CartState({required this.carts, required this.totalPrice});
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(carts: [], totalPrice: 0)) {
    on<FetchCartEvent>((event, emit) => _fetchCart(emit));
    on<UpdateCartItemEvent>(
        (event, emit) => _update(event.product, event.number, emit));
    on<RemoveFromCartEvent>((event, emit) => _delToCart(event.product, emit));
    on<ClearCartEvent>(
        (event, emit) => emit(CartState(carts: [], totalPrice: 0)));
    on<AddToCartEvent>(
        (event, emit) => _addToCart(emit, event.product, event.quantity ?? 1));
  }

  _delToCart(Product product, Emitter<CartState> emit) async {
    final existingCartIndex =
        state.carts.indexWhere((item) => item.product!.sId == product.sId);
    final carts = List<Cart>.from(state.carts);

    if (existingCartIndex != -1) {
      carts.removeAt(existingCartIndex);
      await CartRepo.delCart(product.sId);
      ToastMsg.toast("Xoá thành công");
    }

    emit(CartState(carts: carts, totalPrice: _totalPrice(carts)));
  }

  _addToCart(Emitter<CartState> emit, Product product, int quantity) async {
    final existingCartIndex =
        state.carts.indexWhere((item) => item.product!.sId == product.sId);
    final carts = List<Cart>.from(state.carts);

    if (existingCartIndex != -1) {
      final existingCart = carts[existingCartIndex];
      final updatedQuantity = existingCart.quantity! + quantity;
      carts[existingCartIndex] =
          existingCart.copyWith(quantity: updatedQuantity);
    } else {
      await CartRepo.addToCart({"id": product.sId, "quantity": quantity});
      carts.add(Cart(product: product, quantity: quantity));
    }

    ToastMsg.toast("Thêm thành công");
    emit(CartState(carts: carts, totalPrice: _totalPrice(carts)));
  }

  _update(Product product, int number, Emitter<CartState> emit) async {
    final carts = List<Cart>.from(state.carts);
    final existingCartIndex =
        carts.indexWhere((cart) => cart.product!.sId == product.sId);
    if (existingCartIndex != -1) {
      final existingCart = carts[existingCartIndex];
      final updatedQuantity = existingCart.quantity! + number;
      if (updatedQuantity <= 0) {
        carts.removeAt(existingCartIndex);
        await CartRepo.delCart(product.sId);
        ToastMsg.toast("Xoá thành công");
      } else {
        carts[existingCartIndex] =
            existingCart.copyWith(quantity: updatedQuantity);
        await CartRepo.updateQuantity(product.sId, updatedQuantity);
      }

      emit(CartState(carts: carts, totalPrice: _totalPrice(carts)));
    }
  }

  Future<void> _fetchCart(Emitter<CartState> emit) async {
    try {
      final response = await CartRepo.fetchCart();
      final cartsData = response.data["carts"];

      final List<Cart> carts = cartsData.map<Cart>((item) {
        final data = item['product'];
        final sale = data['sale'].toDouble();
        final star = data['star'].toDouble();
        final photos = List<String>.from(
            data['photos']?.map((photo) => photo.toString()) ?? []);
        final product = Product(
            sId: data['_id'],
            name: data['name'],
            photos: photos,
            author: data['author'],
            price: data['price'],
            quantity: data['quantity'],
            purchases: data['purchases'],
            sale: sale,
            star: star,
            description: data['description']);
        final quantity = item['quantity'];

        return Cart(product: product, quantity: quantity);
      }).toList();

      emit(CartState(carts: carts, totalPrice: _totalPrice(carts)));
    } catch (e) {
      throw Exception(e);
    }
  }

  double _totalPrice(List<Cart> carts) {
    double price = 0;

    for (int i = 0; i < carts.length; i++) {
      price += carts[i].quantity! *
          (carts[i].product!.price! -
              (carts[i].product!.price! * carts[i].product!.sale!));
    }
    return price;
  }
}
