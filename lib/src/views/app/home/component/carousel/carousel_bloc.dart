import 'dart:async';

class CarouselBloc {
  final _indexController = StreamController<int>();

  Stream<int> get indexStream => _indexController.stream;

  void changeIndex(int index) {
    _indexController.sink.add(index);
  }

  void dispose() {
    _indexController.close();
  }
}
