import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:masjidz/app/routes/app_pages.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var emailRecovery = "".obs;
  var currentOtp = "".obs;

  // Variabel baru untuk menampung data Register Sementara (Sebelum OTP)
  var tempName = "".obs;
  var tempEmail = "".obs;
  var tempPassword = "".obs;
  var isRegisterMode =
      false.obs; // Penanda apakah sedang Register atau Lupa Pass

  final String serviceId = 'service_593d666';
  final String templateId = 'template_c3o6sl8';
  final String publicKey = '7KVuQS7v3mzh8jy0k';

  // Base URL untuk Python API (Sesuaikan jika ganti IP)
  final String apiUrl =
      GetPlatform.isAndroid ? "http://10.0.2.2:8000" : "http://localhost:8000";

  // --- 1. LOGIN ---
  void login(String email, String password) async {
    try {
      isLoading.value = true;
      DocumentSnapshot userDoc = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((value) => value.docs.first);

      if (userDoc.exists) {
        if (userDoc['password'] == password) {
          Get.offAllNamed(Routes.MAIN_WRAPPER); 
          return;
        }
      }
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAllNamed(Routes.MAIN_WRAPPER);
    } catch (e) {
      Get.snackbar("Gagal", "Email atau Sandi salah.");
    } finally {
      isLoading.value = false;
    }
  }

  // --- 2. OTP UNTUK REGISTER (Dosen Request) ---
  Future<void> sendRegisterOtp(
      String name, String email, String password) async {
    if (email.isEmpty || name.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Semua kolom harus diisi");
      return;
    }
    try {
      isLoading.value = true;
      // Simpan data pendaftar ke memori sementara
      tempName.value = name;
      tempEmail.value = email;
      tempPassword.value = password;
      emailRecovery.value = email;
      isRegisterMode.value = true; // Set mode ke Register

      String otpCode = (Random().nextInt(900000) + 100000).toString();
      currentOtp.value = otpCode;

      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': publicKey,
          'template_params': {
            'user_email': email,
            'passcode': otpCode,
            'time': '15 Menit',
          }
        }),
      );

      Get.toNamed('/verification');
      Get.snackbar("Berhasil", "OTP Pendaftaran terkirim ke Email Anda");
    } catch (e) {
      Get.snackbar("Error", "Gagal mengirim email.");
    } finally {
      isLoading.value = false;
    }
  }

  // --- 3. OTP UNTUK LUPA PASSWORD ---
  Future<void> sendRealOtp(String email) async {
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Get.snackbar("Error", "Masukkan email yang valid");
      return;
    }
    try {
      isLoading.value = true;
      emailRecovery.value = email;
      isRegisterMode.value = false; // Set mode ke Lupa Password

      String otpCode = (Random().nextInt(900000) + 100000).toString();
      currentOtp.value = otpCode;

      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': publicKey,
          'template_params': {
            'user_email': email,
            'passcode': otpCode,
            'time': '15 Menit',
          }
        }),
      );

      Get.toNamed('/verification');
      Get.snackbar("Berhasil", "Kode OTP Pemulihan terkirim ke Gmail Anda");
    } catch (e) {
      Get.snackbar("Error", "Gagal mengirim email.");
    } finally {
      isLoading.value = false;
    }
  }

  // --- 4. VERIFIKASI OTP (Mencakup Register & Lupa Pass) ---
  void verifyOtp(String inputOtp) {
    if (inputOtp.trim() == currentOtp.value.trim()) {
      if (isRegisterMode.value) {
        // Jika sedang daftar, lanjut ke fungsi simpan akun
        completeRegistration();
      } else {
        // Jika lupa password, lanjut ke halaman reset pass
        Get.toNamed('/reset-password');
      }
    } else {
      Get.snackbar("Gagal", "Kode OTP salah.",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // --- 5. FINALIZE REGISTRATION (SIMPAN KE FIREBASE & PYTHON API) ---
  void completeRegistration() async {
    try {
      isLoading.value = true;
      // Buat akun di Firebase Authentication
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: tempEmail.value, password: tempPassword.value);

      // Simpan data lengkap ke Firestore
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': tempName.value,
        'email': tempEmail.value,
        'password': tempPassword.value,
        'role': 'user',
        'createdAt': DateTime.now(),
      });

      // Sinkronkan ke REST API Python (Syarat Tambahan Dosen)
      try {
        await http.post(
          Uri.parse("$apiUrl/api/sync-google"),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"name": tempName.value, "email": tempEmail.value}),
        );
      } catch (e) {
        print("Sync API gagal tapi akun Firebase sudah dibuat");
      }

      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar("Sukses", "Pendaftaran berhasil & Email terverifikasi!");
      isRegisterMode.value = false;
    } catch (e) {
      Get.snackbar("Gagal", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // --- 6. UPDATE PASSWORD (LUPA PASS) ---
  void finalizeNewPassword(String newPass) async {
    try {
      isLoading.value = true;
      var userQuery = await firestore
          .collection('users')
          .where('email', isEqualTo: emailRecovery.value)
          .get();

      if (userQuery.docs.isNotEmpty) {
        String docId = userQuery.docs.first.id;

        // 1. Update Password di Firebase (Sudah ada)
        await firestore.collection('users').doc(docId).update({
          'password': newPass,
          'last_reset': DateTime.now(),
        });

        // 2. TAMBAHKAN INI: Lapor ke API Python untuk Log Aktivitas
        try {
          await http.post(
            Uri.parse("$apiUrl/api/log-activity"),
            headers: {"Content-Type": "application/json"},
            body: json.encode({
              "email": emailRecovery.value,
              "action":
                  "Reset Password Berhasil" // Pesan yang akan muncul di Web
            }),
          );
        } catch (e) {
          print("Gagal mengirim log ke Python: $e");
        }

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
