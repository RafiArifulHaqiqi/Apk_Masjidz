import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart'; // Untuk membuka halaman Midtrans di browser/webview

class DonasiController extends GetxController {
  final nominalController = TextEditingController();
  var isLoading = false.obs;

  // URL Backend FastAPI kamu (sesuaikan port-nya jika bukan 8000)
  final String baseUrl = "http://127.0.0.1:8000";

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

    try {
      isLoading.value = true;

      // 1. Hit endpoint backend untuk membuat transaksi Midtrans
      final response = await http.post(
        Uri.parse(
            "$baseUrl/api/donasi"), // <-- Pastikan jalurnya adalah /api/donasi
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "amount": amount,
          "user_id":
              "albarabdullah99@gmail.com", // <-- Sementara pakai email dummy/sesuai yang terdaftar di log kamu tadi
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String snapUrl =
            data['snap_url']; // URL pembayaran dari Midtrans via Backend

        // 2. Buka snapUrl di Browser/Webview
        if (await canLaunchUrl(Uri.parse(snapUrl))) {
          await launchUrl(Uri.parse(snapUrl),
              mode: LaunchMode.externalApplication);
          nominalController.clear();
          Get.snackbar("Sukses", "Silahkan selesaikan pembayaran Anda",
              backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          throw "Tidak dapat membuka halaman pembayaran.";
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
    super.dispose();
  }
}
