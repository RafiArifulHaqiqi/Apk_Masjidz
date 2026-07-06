import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // PENTING: Tambahan untuk baca database
import 'package:url_launcher/url_launcher.dart';

class DonasiController extends GetxController {
  final nominalController = TextEditingController();
  var isLoading = false.obs;
  
  // Variabel penampung total donasi dari semua jamaah
  var totalDonasiGlobal = 0.obs; 

  final String baseUrl = GetPlatform.isAndroid ? "http://10.0.2.2:8000" : "http://localhost:8000";

  @override
  void onInit() {
    super.onInit();
    _hitungTotalDonasiGlobal(); // Mulai menghitung saat halaman donasi dibuka
  }

  // --- FUNGSI MENGHITUNG TOTAL DONASI KESELURUHAN ---
  void _hitungTotalDonasiGlobal() {
    FirebaseFirestore.instance
        .collection('donations')
        .snapshots() // Ambil semua data tanpa filter user
        .listen((snapshot) {
      int total = 0;
      for (var doc in snapshot.docs) {
        var data = doc.data();
        String status = data['status'] ?? '';
        // Hanya hitung yang transaksinya sudah berhasil/sukses
        if (status == 'success' || status == 'settlement') {
          total += (data['amount'] as num).toInt();
        }
      }
      totalDonasiGlobal.value = total;
    });
  }

  // --- FUNGSI PROSES PEMBAYARAN MIDTRANS (Tetap sama seperti sebelumnya) ---
  Future<void> prosesDonasi() async {
    final nominalText = nominalController.text.trim();
    if (nominalText.isEmpty) {
      Get.snackbar("Error", "Masukkan nominal donasi terlebih dahulu",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    int? amount = int.tryParse(nominalText);
    if (amount == null || amount < 10000) {
      Get.snackbar("Error", "Minimal donasi adalah Rp 10.000",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      Get.snackbar("Peringatan", "Anda harus login terlebih dahulu untuk berdonasi",
          backgroundColor: Colors.orangeAccent, colorText: Colors.white);
      return;
    }
    
    String activeUserId = currentUser.email ?? "anonymous@masjid.com"; 

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse("$baseUrl/api/donasi"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "amount": amount,
          "user_id": activeUserId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['status'] == 'success') {
          String redirectUrl = data['redirect_url']; 
          final Uri url = Uri.parse(redirectUrl);
          
          await launchUrl(url, mode: LaunchMode.externalApplication);
          
          nominalController.clear();
          Get.snackbar("Sukses", "Silahkan selesaikan pembayaran Anda",
              backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          Get.snackbar("Gagal", data['message'] ?? "Gagal memproses pembayaran",
              backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      } else {
        Get.snackbar("Gagal", "Gagal membuat transaksi ke server",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nominalController.dispose();
    super.onClose();
  }
}