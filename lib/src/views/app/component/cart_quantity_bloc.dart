import 'dart:async';

class QuantityBloc {
  final _quantityController = StreamController<int>();
  Stream<int> get quantityStream => _quantityController.stream;

  void increase(int val) {
    _quantityController.add(val + 1);
  }

  void decrease(int val) {
    if (val > 0) _quantityController.add(val - 1);
  }

  void dispose() {
    _quantityController.close();
  }
}
