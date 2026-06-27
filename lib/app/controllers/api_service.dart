import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

// Tambahkan fungsi ini di dalam class Controller kamu
Future<void> getMasjidData() async {
  try {
    // Gunakan 10.0.2.2 jika pakai Emulator Android, 
    // atau localhost jika di Web
    String url = "http://localhost:8000/api/masjid-info"; 
    
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print("Data dari API Python: ${data['nama_masjid']}");
      Get.snackbar("API Berhasil", "Terhubung dengan Server Python: ${data['nama_masjid']}");
    }
  } catch (e) {
    print("Error Koneksi API: $e");
  }
}