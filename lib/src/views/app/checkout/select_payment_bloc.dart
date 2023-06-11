import 'dart:async';

class SelectPaymentBloc {
  String _key = "";
  final _selectPaymentController = StreamController<String>();
  Stream<String> get selectPaymentStream => _selectPaymentController.stream;
  String get key => _key;
  void select(String val) {
    if (_key != val) {
      _selectPaymentController.add(val);
      _key = val;
    }
  }

  void dispose() {
    _selectPaymentController.close();
  }
}
