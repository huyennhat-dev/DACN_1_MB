import 'package:app_client/src/repo/home.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../model/product.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProduct extends SearchEvent {
  final String searchValue;
  final int page;
  LoadProduct({required this.searchValue, required this.page});
}

class LoadMoreProduct extends SearchEvent {
  final String searchValue;
  final int page;
  LoadMoreProduct({required this.searchValue, required this.page});
}

class SearchState extends Equatable {
  final List<Product> products;
  final bool isLoading;
  const SearchState({required this.products, required this.isLoading});

  @override
  List<Object?> get props => [products, isLoading];

  SearchState copyWith({List<Product>? products, bool? isLoading}) {
    return SearchState(
        products: products ?? this.products,
        isLoading: isLoading ?? this.isLoading);
  }
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState(products: [], isLoading: false)) {
    on<LoadProduct>((event, emit) => _loadProduct(event, emit));
    on<LoadMoreProduct>((event, emit) => _loadMoreProduct(event, emit));
  }

  _loadProduct(LoadProduct event, Emitter<SearchState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final rs = await HomeRepo.seachProduct(event.searchValue, event.page);
      final data = rs.data["products"];

      final List<Product> products = data.map<Product>((item) {
        final sale = item['sale'].toDouble();
        final star = item['star'].toDouble();

        return Product.fromJson({
          "_id": item['_id'],
          "name": item['name'],
          "photos": item['photos'],
          "author": item['author'],
          "price": item['price'],
          "quantity": item['quantity'],
          "purchases": item['purchases'],
          "sale": sale,
          "star": star,
          "description": item['description']
        });
      }).toList();
      emit(SearchState(products: products, isLoading: false));
    } catch (e) {
      throw Exception(e);
    }
  }

  _loadMoreProduct(LoadMoreProduct event, Emitter emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      final rs = await HomeRepo.seachProduct(event.searchValue, event.page);
      final data = rs.data["products"];
      print(data);
      data.forEach((item) {
        final sale = item['sale'].toDouble();
        final star = item['star'].toDouble();

        state.products.add(Product.fromJson({
          "_id": item['_id'],
          "name": item['name'],
          "photos": item['photos'],
          "author": item['author'],
          "price": item['price'],
          "quantity": item['quantity'],
          "purchases": item['purchases'],
          "sale": sale,
          "star": star,
          "description": item['description']
        }));
      });

      emit(state.copyWith(products: state.products, isLoading: false));
    } catch (e) {
      throw Exception(e);
    }
  }
}
