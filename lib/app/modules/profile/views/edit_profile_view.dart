import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Memastikan controller tersedia
    final controller = Get.put(EditProfileController());

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.nameController, 
            decoration: const InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: controller.phoneController, 
            decoration: const InputDecoration(labelText: "Nomor HP", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 30),
          Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value ? null : () => controller.updateProfile(),
            child: controller.isLoading.value 
                ? const CircularProgressIndicator() 
                : const Text("Simpan Perubahan"),
          ))
        ],
      ),
    );
  }
}