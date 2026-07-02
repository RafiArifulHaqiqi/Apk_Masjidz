import 'package:get/get.dart';
import '../controllers/main_wrapper_controller.dart';
import '../../home/controllers/home_controller.dart';
// 1. TAMBAHKAN IMPORT DONASI CONTROLLER
import '../../donasi/controllers/donasi_controller.dart'; // Sesuaikan jika struktur folder berbeda

// --- TAMBAHAN: Import Profile Controller ---
import '../../profile/controllers/profile_controller.dart'; 

class MainWrapperBinding extends Bindings {
  // Di MainWrapperBinding
@override
void dependencies() {
  Get.lazyPut<MainWrapperController>(() => MainWrapperController());
  Get.lazyPut<HomeController>(() => HomeController()); 
  Get.lazyPut<DonasiController>(() => DonasiController()); 

  // GANTI INI:
  Get.put(ProfileController(), permanent: false);
  }
}