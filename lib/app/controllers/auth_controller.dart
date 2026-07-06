import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:masjidz/app/routes/app_pages.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var emailRecovery = "".obs;
  var currentOtp = "".obs;

  var tempName = "".obs;
  var tempEmail = "".obs;
  var tempPassword = "".obs;
  var isRegisterMode = false.obs;

  final String serviceId = 'service_593d666';
  final String templateId = 'template_c3o6sl8';
  final String publicKey = '7KVuQS7v3mzh8jy0k';

  final String apiUrl = GetPlatform.isAndroid ? "http://10.0.2.2:8000" : "http://localhost:8000";

  // FUNGSI LOG KE BACKEND PYTHON
  Future<void> sendActivityLog(String email, String action) async {
    try {
      await http.post(
        Uri.parse("$apiUrl/log-activity"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email, "action": action}),
      );
    } catch (e) {
      print("Gagal kirim log: $e");
    }
  }

  // LOGIN
  void login(String email, String password) async {
    try {
      isLoading.value = true;
      await auth.signInWithEmailAndPassword(email: email, password: password);
      await sendActivityLog(email, "Login Berhasil");
      Get.offAllNamed(Routes.MAIN_WRAPPER);
    } catch (e) {
      Get.snackbar("Gagal", "Email atau Sandi salah.");
    } finally {
      isLoading.value = false;
    }
  }

  // KIRIM OTP (Sama untuk Register & Lupa Pass)
  Future<void> sendOtp(String email, String? name, String? password, bool isRegister) async {
    isLoading.value = true;
    tempName.value = name ?? "";
    tempEmail.value = email;
    tempPassword.value = password ?? "";
    emailRecovery.value = email;
    isRegisterMode.value = isRegister;

    String otpCode = (Random().nextInt(900000) + 100000).toString();
    currentOtp.value = otpCode;
    print("DEBUG: Kode OTP: $otpCode"); // Lihat ini di terminal untuk tes

    try {
      await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': publicKey,
          'template_params': {'user_email': email, 'passcode': otpCode, 'time': '15 Menit'}
        }),
      );
      Get.toNamed('/verification');
    } catch (e) {
      Get.snackbar("Error", "Gagal kirim email");
    } finally {
      isLoading.value = false;
    }
  }

  // VERIFIKASI OTP
  void verifyOtp(String inputOtp) {
    if (inputOtp.trim() == currentOtp.value.trim()) {
      isRegisterMode.value ? completeRegistration() : Get.toNamed('/reset-password');
    } else {
      Get.snackbar("Gagal", "OTP Salah", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // FINALISASI REGISTER
  void completeRegistration() async {
    try {
      isLoading.value = true;
      UserCredential uc = await auth.createUserWithEmailAndPassword(
          email: tempEmail.value, password: tempPassword.value);

      await firestore.collection('users').doc(uc.user!.uid).set({
        'name': tempName.value, 'email': tempEmail.value, 'createdAt': DateTime.now()
      });

      // Sinkron Python API
      await http.post(Uri.parse("$apiUrl/sync-google"), 
        headers: {"Content-Type": "application/json"},
        body: json.encode({"name": tempName.value, "email": tempEmail.value}));

      await sendActivityLog(tempEmail.value, "Registrasi Berhasil");
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar("Sukses", "Akun dibuat!");
    } catch (e) {
      Get.snackbar("Gagal", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
// --- RESET PASSWORD ---
  void finalizeNewPassword(String newPass) async {
    try {
      isLoading.value = true;
      var userQuery = await firestore.collection('users').where('email', isEqualTo: emailRecovery.value).get();

      if (userQuery.docs.isNotEmpty) {
        String docId = userQuery.docs.first.id;
        
        // Update password di Firebase
        await firestore.collection('users').doc(docId).update({'password': newPass});

        // Kirim Log Reset Password ke Python
        await sendActivityLog(emailRecovery.value, "Reset Password Berhasil");

        Get.snackbar("Sukses", "Sandi berhasil diperbarui!");
        Get.offAllNamed('/login');
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan.");
    } finally {
      isLoading.value = false;
    }
  }
}