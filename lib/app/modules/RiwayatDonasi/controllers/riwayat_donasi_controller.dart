import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class RiwayatDonasiController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  // Gunakan Stream agar riwayat langsung update secara realtime
  Stream<QuerySnapshot<Map<String, dynamic>>> streamRiwayat() {
    // Ambil email user yang sedang login
    String currentUserEmail = auth.currentUser?.email ?? "";

    // Tarik data dari koleksi 'donations' khusus untuk email ini
    return firestore
        .collection('donations')
        .where('user_id', isEqualTo: currentUserEmail)
        .orderBy('timestamp', descending: true) // Urutkan dari yang terbaru
        .snapshots();
  }
}