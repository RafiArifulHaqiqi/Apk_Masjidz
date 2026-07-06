import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; 
import '../controllers/riwayat_donasi_controller.dart'; // Sesuaikan path import controller-mu

class RiwayatDonasiView extends GetView<RiwayatDonasiController> {
  const RiwayatDonasiView({super.key});

  @override
  Widget build(BuildContext context) {
    // Format mata uang Rupiah
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text("Riwayat Donasi"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.streamRiwayat(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF064635)));
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Gagal memuat data."));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.volunteer_activism, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Belum ada riwayat donasi", style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }

          var donasiList = snapshot.data!.docs;

          // --- MENGHITUNG TOTAL DONASI SECARA OTOMATIS ---
          int totalDonasi = 0;
          for (var doc in donasiList) {
            var data = doc.data();
            // Kita hitung yang statusnya success atau pending
            if (data['status'] == 'success' || data['status'] == 'pending') {
              totalDonasi += (data['amount'] as num).toInt();
            }
          }

          return Column(
            children: [
              // --- KOTAK TOTAL DONASI DI BAGIAN ATAS ---
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF064635),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Total Donasi Anda", style: TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(
                            currencyFormat.format(totalDonasi),
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // --- DAFTAR RIWAYAT DONASI ---
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: donasiList.length,
                  itemBuilder: (context, index) {
                    var donasi = donasiList[index].data();
                    
                    int amount = donasi['amount'] ?? 0;
                    String status = donasi['status'] ?? 'pending';
                    
                    // Menyesuaikan warna berdasarkan status Midtrans
                    Color statusColor = Colors.orange;
                    if (status == 'success' || status == 'settlement') statusColor = Colors.green;
                    if (status == 'cancel' || status == 'expire') statusColor = Colors.red;

                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF064635).withOpacity(0.1),
                          child: const Icon(Icons.volunteer_activism, color: Color(0xFF064635)),
                        ),
                        title: Text(currencyFormat.format(amount), style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("ID: ${donasiList[index].id.substring(0, 15)}..."),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}