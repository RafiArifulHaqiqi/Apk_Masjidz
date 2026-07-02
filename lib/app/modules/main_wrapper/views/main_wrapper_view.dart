import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_wrapper_controller.dart';
import '../../home/views/home_view.dart';
// 1. TAMBAHKAN IMPORT DONASI VIEW
import '../../donasi/views/donasi_view.dart'; 

// --- TAMBAHAN: Import Profile View ---
import '../../profile/views/profile_view.dart'; 

class MainWrapperView extends GetView<MainWrapperController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: [
              HomeView(),                             // Index 0
              Center(child: Text("Halaman Event")),    // Index 1
              Center(child: Text("Halaman Laporan")),  // Index 2
              DonasiView(),                            // Index 3
              
              // --- TAMBAHAN: GANTI TEKS LAMA MENJADI WIDGET ASLI ---
              const ProfileView(),                     // Index 4
            ],
          )),
      bottomNavigationBar: Obx(() => Container(
            // ... (Kode BottomNavigationBar tidak perlu diubah)
            padding: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: BottomNavigationBar(
              currentIndex: controller.tabIndex.value,
              onTap: (index) => controller.tabIndex.value = index,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFF064635),
              unselectedItemColor: Colors.grey,
              items: [
                _navItem(Icons.home_filled, "Beranda", 0),
                _navItem(Icons.event_note, "Event", 1),
                _navItem(Icons.analytics_outlined, "Laporan", 2),
                _navItem(Icons.volunteer_activism, "Donasi", 3),
                _navItem(Icons.person_outline, "Akun", 4),
              ],
            ),
          )),
    );
  }

  // ... (Fungsi _navItem tetap sama)
  BottomNavigationBarItem _navItem(IconData icon, String label, int index) {
    bool isActive = controller.tabIndex.value == index;
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE8F5E9) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon),
      ),
      label: label,
    );
  }
}