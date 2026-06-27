import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../main_wrapper/controllers/main_wrapper_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final navC = Get.find<MainWrapperController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("Masjid Al-Noor", 
          style: TextStyle(color: Color(0xFF064635), fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Color(0xFF064635)))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            
            // --- BANNER SHOLAT (SESUAI GAMBAR 2) ---
            Obx(() => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: const DecorationImage(
                  image: NetworkImage("https://www.transparenttextures.com/patterns/carbon-fibre.png"), // Efek pattern halus
                  opacity: 0.1,
                  repeat: ImageRepeat.repeat
                ),
                gradient: const LinearGradient(
                  colors: [Color(0xFF064635), Color(0xFF0A5C44)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(controller.activePrayerName.value, 
                    style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w400)),
                  Text("Starts in ${controller.countdown.value}", 
                    style: const TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 20),
                  
                  // --- GLASSMORHPIC IQAMAH BAR (EFEK GAMBAR 2) ---
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_alarm, color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          "Iqamah: ${controller.iqamahTime.value}",
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),

            const SizedBox(height: 25),

            // --- MENU LAYANAN ---
            const Text("Layanan Masjid", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _featureIcon("Event", Icons.event, () => navC.tabIndex.value = 1),
                _featureIcon("Laporan", Icons.analytics, () => navC.changeTabIndex(2)),
                _featureIcon("Donasi", Icons.volunteer_activism, () => navC.changeTabIndex(3)),
                _featureIcon("Al-Qur'an", Icons.menu_book, () => Get.toNamed('/quran')), 
              ],
            ),

            const SizedBox(height: 35),

            // --- ACTIVITIES SECTION (DARI FIREBASE) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Activities", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                TextButton(onPressed: () {}, child: const Text("View All", style: TextStyle(color: Color(0xFF064635)))),
              ],
            ),
            Obx(() => controller.activities.isEmpty 
              ? const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Center(child: Text("Belum ada kegiatan terbaru")))
              : Column(
                  children: controller.activities.map((act) => _activityCard(act)).toList(),
                )),

            const SizedBox(height: 30),

            // --- ANNOUNCEMENTS SECTION (PETUGAS JUM'AT) ---
            const Text("Announcements", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 15),
            _buildAnnouncementBox(),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _featureIcon(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 75, height: 75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
            ),
            child: Icon(icon, color: const Color(0xFF064635), size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _activityCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              data['imageUrl'] ?? "https://via.placeholder.com/400", 
              height: 180, width: double.infinity, fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(height: 180, color: Colors.grey[200], child: const Icon(Icons.image_not_supported)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['title'] ?? "No Title", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(data['time'] ?? "TBA", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAnnouncementBox() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Petugas Jum'at", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF064635))),
              Icon(Icons.campaign, color: Colors.green.withOpacity(0.2), size: 50),
            ],
          ),
          const SizedBox(height: 15),
          Obx(() => Column(
            children: controller.announcements.map((ann) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ann['date'] ?? "", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      Text("Khatib: ${ann['khatib'] ?? ""}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF064635))),
                    ],
                  ),
                  const Spacer(),
                  const CircleAvatar(radius: 18, backgroundColor: Color(0xFFF1F8E9), child: Icon(Icons.person, size: 20, color: Color(0xFF064635))),
                ],
              ),
            )).toList(),
          )),
        ],
      ),
    );
  }
}