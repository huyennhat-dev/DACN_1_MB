import 'dart:async';

class BottomTabBloc {
  final StreamController<int> _tabController =
      StreamController<int>.broadcast();
  int _currentIndex = 0;

  Stream<int> get currentIndexStream => _tabController.stream;
  int get currentIndex => _currentIndex;

  void updateCurrentIndex(int newIndex) {
    if (newIndex != _currentIndex) {
      _currentIndex = newIndex;
      _tabController.sink.add(_currentIndex);
    }
  }

  void dispose() {
    _tabController.close();
  }
}
