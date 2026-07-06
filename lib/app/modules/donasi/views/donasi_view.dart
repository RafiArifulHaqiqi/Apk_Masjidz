import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/donasi_controller.dart';

class DonasiView extends GetView<DonasiController> {
  const DonasiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    
    // Format uang untuk menampilkan Rp
    final formatUang = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donasi Masjidku', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // KARTU BESAR: TOTAL DANA TERKUMPUL
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                // Menggunakan gradien warna agar terlihat lebih premium
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.75)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.4), 
                    blurRadius: 12, 
                    offset: const Offset(0, 6)
                  )
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Total Dana Terkumpul", 
                    style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500)
                  ),
                  const SizedBox(height: 8),
                  Obx(() => Text(
                    formatUang.format(controller.totalDonasiGlobal.value),
                    style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // ==========================================
            // KARTU KECIL: INFO INFAQ
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.volunteer_activism, color: primaryColor, size: 22),
                      const SizedBox(width: 8),
                      Text("Mari Berinfaq", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Infaq dan sedekah Anda akan dialokasikan langsung untuk kemakmuran dan operasional kegiatan masjid.",
                    style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ==========================================
            // INPUT NOMINAL
            // ==========================================
            const Text("Pilih Nominal Donasi Cepat", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.2,
              children: [25000, 50000, 100000, 200000, 500000, 1000000].map((nominal) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: primaryColor,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    controller.nominalController.text = nominal.toString();
                  },
                  child: Text("Rp ${nominal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}"),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),

            const Text("Atau Masukkan Nominal Manual (Rp)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            TextField(
              controller: controller.nominalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Contoh: 50000",
                prefixText: "Rp ",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 35),

            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: controller.isLoading.value ? null : () => controller.prosesDonasi(),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Lanjutkan Pembayaran", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}