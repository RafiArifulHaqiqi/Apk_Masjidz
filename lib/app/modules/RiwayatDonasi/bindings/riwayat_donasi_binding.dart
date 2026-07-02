import 'package:get/get.dart';

import '../controllers/riwayat_donasi_controller.dart';

class RiwayatDonasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiwayatDonasiController>(
      () => RiwayatDonasiController(),
    );
  }
}
