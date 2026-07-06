import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'edit_profile_view.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        title: const Text('Profil Akun', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF064635),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFF064635),
              padding: const EdgeInsets.only(bottom: 30, top: 20),
              child: Column(
                children: [
                  Obx(() => CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: controller.photoUrl.value.isNotEmpty
                        ? NetworkImage(controller.photoUrl.value)
                        : const NetworkImage('https://ui-avatars.com/api/?name=User&background=random&size=200'),
                  )),
                  const SizedBox(height: 15),
                  Obx(() => Text(controller.userName.value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white))),
                  const SizedBox(height: 5),
                  Obx(() => Text(controller.userEmail.value, style: const TextStyle(fontSize: 14, color: Colors.white70))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))]),
              child: Column(
                children: [
                  _buildMenuItem(icon: Icons.history, title: 'Riwayat Donasi', onTap: () => Get.toNamed('/riwayat-donasi')),
                  const Divider(height: 1, color: Colors.black12),
                  _buildMenuItem(icon: Icons.person_outline, title: 'Edit Profil', onTap: () => Get.to(() => const EditProfileView())),
                  const Divider(height: 1, color: Colors.black12),
                  _buildMenuItem(icon: Icons.help_outline, title: 'Pusat Bantuan', onTap: () {}),
                  
                  // ================= TAMBAHAN MENU LOGOUT =================
                  const Divider(height: 1, color: Colors.black12),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.redAccent)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.redAccent),
                    onTap: () {
                      Get.defaultDialog(
                        title: "Konfirmasi",
                        middleText: "Apakah Anda yakin ingin keluar?",
                        textConfirm: "Ya, Keluar",
                        textCancel: "Batal",
                        confirmTextColor: Colors.white,
                        buttonColor: Colors.redAccent,
                        cancelTextColor: Colors.redAccent,
                        onConfirm: () => controller.logout(),
                      );
                    },
                  ),
                  // ========================================================
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF064635)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}