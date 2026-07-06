import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  var userName = '...'.obs;
  var userEmail = '...'.obs;
  var photoUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData(); 
  }

  void loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userEmail.value = user.email ?? '';
      var query = await FirebaseFirestore.instance.collection('users')
          .where('email', isEqualTo: user.email).get();
      if (query.docs.isNotEmpty) {
        var data = query.docs.first.data();
        userName.value = data['name'] ?? 'Jamaah Masjid';
        photoUrl.value = data['photoUrl'] ?? '';
      }
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/login');
    Get.snackbar('Logout', 'Anda telah keluar.');
  }
}