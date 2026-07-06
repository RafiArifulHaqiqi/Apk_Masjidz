import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Pastikan sudah menambahkan intl di pubspec.yaml untuk format tanggal & uang
import '../controllers/laporan_controller.dart';

class LaporanView extends GetView<LaporanController> {
  const LaporanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Memasukkan/Inisialisasi controller secara aman jika dipanggil dari MainWrapper
    final controller = Get.put(LaporanController());
    const primaryColor = Color(0xFF064635);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Laporan Keuangan Donasi", 
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        automaticallyImplyLeading: false, // Menghilangkan tombol back karena ini Tab MainWrapper
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Obx(() {
        // Tampilan loading jika data sedang diambil
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        // Tampilan jika data di Firestore kosong
        if (controller.listLaporan.isEmpty) {
          return const Center(
            child: Text(
              "Belum ada data laporan keuangan.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          );
        }

        // Tampilan list data dinamis dari Firestore
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.listLaporan.length,
          itemBuilder: (context, index) {
            var data = controller.listLaporan[index];
            
            // Mengecek apakah tipenya pemasukan atau pengeluaran
            String kategori = data['kategori'] ?? 'Pengeluaran';
            bool isPemasukan = kategori.toLowerCase() == 'pemasukan';

            // Ambil data teks dari firestore
            String keterangan = data['keterangan'] ?? data['judul'] ?? '-';
            
            // Format jumlah uang dinamis
            var jumlahData = data['jumlah'] ?? 0;
            String jumlahFormatted = jumlahData.toString();
            try {
              final numberFormat = NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);
              jumlahFormatted = numberFormat.format(int.parse(jumlahData.toString()));
            } catch (_) {}

            // Format tanggal timestamp Firestore ke String rapi
            String tanggalFormatted = "-";
            if (data['tanggal'] != null) {
              try {
                var timestamp = data['tanggal'] as FirebaseFirestore; // jika timestamp
                DateTime dateTime = data['tanggal'].toDate();
                tanggalFormatted = DateFormat('dd MMM yyyy').format(dateTime);
              } catch (_) {
                tanggalFormatted = data['tanggal'].toString();
              }
            }

            return Card(
              elevation: 0.5,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: isPemasukan ? Colors.green.shade50 : Colors.red.shade50,
                  child: Icon(
                    isPemasukan ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isPemasukan ? Colors.green : Colors.red,
                  ),
                ),
                title: Text(
                  keterangan, 
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(tanggalFormatted, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ),
                trailing: Text(
                  "${isPemasukan ? '+' : '-'} Rp $jumlahFormatted",
                  style: TextStyle(
                    color: isPemasukan ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}