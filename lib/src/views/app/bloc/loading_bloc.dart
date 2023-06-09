import 'dart:async';

class LoadingBloc {
  bool _isLoading = false;

  final _isLoadingController = StreamController<bool>.broadcast();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;
  bool get isLooading => _isLoading;

  void changeLoading(bool val) {
    if (val != _isLoading) {
      _isLoading = val;
      _isLoadingController.add(val);
    }
  }

  void dispose() {
    _isLoadingController.close();
  }
}
