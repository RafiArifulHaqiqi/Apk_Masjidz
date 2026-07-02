import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/donasi_controller.dart';

class DonasiView extends GetView<DonasiController> {
  const DonasiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

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
            // Banner/Card Informasi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Mari Berinfaq", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                  const SizedBox(height: 5),
                  const Text(
                    "Infaq dan sedekah Anda akan dialokasikan langsung untuk kemakmuran dan operasional kegiatan masjid.",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            const Text("Pilih Nominal Donasi Cepat", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Pilihan Nominal Instan
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

            // Input TextField
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

            // Tombol Kirim / Bayar
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 50,
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