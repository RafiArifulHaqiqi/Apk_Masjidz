import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:masjidz/app/modules/profile/controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  var isLoading = false.obs;
  var photoUrl = ''.obs; // Tambahkan ini
  File? pickedImage;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var query = await FirebaseFirestore.instance.collection('users')
          .where('email', isEqualTo: user.email).get();
      if (query.docs.isNotEmpty) {
        var data = query.docs.first.data();
        nameController.text = data['name'] ?? "";
        phoneController.text = data['phone'] ?? "";
        photoUrl.value = data['photoUrl'] ?? "";
      }
    }
  }

  Future<void> updateProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    isLoading.value = true;
    try {
      var query = await FirebaseFirestore.instance.collection('users')
          .where('email', isEqualTo: user.email).get();
      if (query.docs.isNotEmpty) {
        await query.docs.first.reference.update({
          "name": nameController.text,
          "phone": phoneController.text,
          // Tambahkan photoUrl di sini nanti jika sudah integrasi Firebase Storage
        });
        Get.snackbar("Sukses", "Profil diperbarui");
        // Update data di ProfileView
        Get.find<ProfileController>().loadUserData(); 
        Get.back();
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal menyimpan");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage = File(image.path);
      update();
    }
  }
}