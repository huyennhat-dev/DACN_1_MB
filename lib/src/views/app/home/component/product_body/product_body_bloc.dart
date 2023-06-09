import 'dart:async';

class ProductBodyBloc {
  int _currentIndex = 0;

  final _imageIndexController = StreamController<int>.broadcast();
  Stream<int> get imageIndexStream => _imageIndexController.stream;
  int get currentIndex => _currentIndex;

  void changeImageIndex(int nIndex) {
    if (nIndex != _currentIndex) {
      _currentIndex = nIndex;
      _imageIndexController.add(nIndex);
    }
  }

  void dispose() {
    _imageIndexController.close();
  }
}
