import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RiwayatDonasiController extends GetxController {
  // Gunakan email user yang login (sesuaikan dengan cara kamu menyimpan user login)
  final String userEmail = "albarabdullah99@gmail.com"; 
  var riwayatList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRiwayat();
  }

  void fetchRiwayat() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('donasi')
          .where('email', isEqualTo: userEmail) // Filter by email user
          .orderBy('timestamp', descending: true)
          .get();

      riwayatList.value = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat riwayat: $e");
    }
  }
}