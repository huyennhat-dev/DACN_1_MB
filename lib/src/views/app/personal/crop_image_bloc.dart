import 'dart:async';
import 'dart:io';

class CropperBloc {
  File? _photo;
  final _cropperController = StreamController<File>.broadcast();
  Stream<File> get cropperStream => _cropperController.stream;
  File get photo => _photo!;

  void add(File val) {
    if (val != _photo) {
      _photo = val;
      _cropperController.add(val);
    }
  }

  void dispose() {
    _cropperController.close();
  }
}
