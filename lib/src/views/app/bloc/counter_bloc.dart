import 'dart:async';

class CounterBloc {
  int _quantity = 1;
  final _quantityController = StreamController<int>();
  Stream<int> get quantityStream => _quantityController.stream;
  int get quantity => _quantity;
  void increase(int val) {
    _quantity += 1;
    _quantityController.add(val + 1);
  }

  void decrease(int val) {
    if (val > 1) {
      _quantity = _quantity - 1;
      _quantityController.add(val - 1);
    }
  }

  void dispose() {
    _quantityController.close();
  }
}
