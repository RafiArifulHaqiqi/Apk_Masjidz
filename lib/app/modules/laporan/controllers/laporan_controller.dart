import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LaporanController extends GetxController {
  // Variabel observable untuk menampung data list laporan secara dinamis
  var listLaporan = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLaporanDinamis();
  }

  void fetchLaporanDinamis() {
    try {
      isLoading.value = true;
      
      // Mengambil data secara real-time (Stream) dari koleksi 'laporan'
      FirebaseFirestore.instance
          .collection('laporan')
          .orderBy('tanggal', descending: true) // Mengurutkan dari yang terbaru
          .snapshots()
          .listen((snapshot) {
            listLaporan.value = snapshot.docs.map((doc) {
              var data = doc.data();
              // Ambil id dokumen jika nanti dibutuhkan untuk edit/hapus
              data['id'] = doc.id; 
              return data;
            }).toList();
            
            isLoading.value = false;
          }, onError: (error) {
            isLoading.value = false;
            Get.snackbar("Error", "Gagal mengambil data: $error");
          });
    } catch (e) {
      isLoading.value = false;
      print("Error Firestore Laporan: $e");
    }
  }
}