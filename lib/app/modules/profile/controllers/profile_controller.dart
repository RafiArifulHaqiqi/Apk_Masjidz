import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Variabel reaktif untuk data profil
  var userName = 'Hamba Allah'.obs;
  var userEmail = 'memuat...'.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    // Nanti kamu bisa mengganti bagian ini dengan fungsi untuk
    // mengambil data asli dari Firebase Auth / Google Sign-In
    // Contoh dummy sementara:
    userName.value = 'Albar Abdullah';
    userEmail.value = 'albarabdullah99@gmail.com';
  }

  void logout() {
    // Logika untuk logout (misal: hapus token, sign out firebase)
    // FirebaseAuth.instance.signOut();
    
    // Kembali ke halaman Login (sesuaikan nama rute login kamu)
    Get.offAllNamed('/login'); 
    Get.snackbar(
      'Logout Sukses', 
      'Anda telah keluar dari akun.',
      snackPosition: SnackPosition.TOP,
    );
  }
}