import 'package:get/get.dart';

class MainWrapperController extends GetxController {
  var tabIndex = 0.obs; // Index halaman aktif

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }
}