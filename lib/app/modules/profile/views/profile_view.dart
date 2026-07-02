import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

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
            // --- HEADER PROFIL ---
            Container(
              width: double.infinity,
              color: const Color(0xFF064635),
              padding: const EdgeInsets.only(bottom: 30, top: 20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=Albar+Abdullah&background=random&size=200'),
                  ),
                  const SizedBox(height: 15),
                  Obx(() => Text(
                        controller.userName.value,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )),
                  const SizedBox(height: 5),
                  Obx(() => Text(
                        controller.userEmail.value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      )),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // --- MENU LIST ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.history,
                    title: 'Riwayat Donasi',
                    onTap: () {
                      Get.toNamed('/riwayat-donasi');
                    },
                  ),
                  const Divider(height: 1, color: Colors.black12),
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'Edit Profil',
                    onTap: () {},
                  ),
                  const Divider(height: 1, color: Colors.black12),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Pusat Bantuan',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- TOMBOL LOGOUT ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.defaultDialog(
                      title: "Konfirmasi Logout",
                      middleText: "Apakah Anda yakin ingin keluar?",
                      textConfirm: "Ya, Keluar",
                      textCancel: "Batal",
                      confirmTextColor: Colors.white,
                      buttonColor: Colors.red,
                      onConfirm: () {
                        controller.logout();
                      },
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    "Keluar Akun",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
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