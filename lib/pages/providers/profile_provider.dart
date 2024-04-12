import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ProfileProvider with ChangeNotifier {
  int currentImageIndex = 0;
  String token = '';

  void initImageConfig() {
    final box = GetStorage();
    if (box.read('image') != null) {
      currentImageIndex = box.read('image');
    } else {
      currentImageIndex = 0;
    }
    notifyListeners();
  }

  void updateImage(int index) async {
    currentImageIndex = index;
    final box = GetStorage();
    await box.write('image', index);
    await box.save();
    notifyListeners();
  }
}
