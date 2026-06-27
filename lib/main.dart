import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/controllers/auth_controller.dart';
import 'app/modules/main_wrapper/controllers/main_wrapper_controller.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // INJEKSI GLOBAL (PENTING AGAR TIDAK ERROR MERAH)
  Get.put(MainWrapperController(), permanent: true); 
  Get.put(AuthController(), permanent: true);

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Masjidku Pro",
      initialRoute: AppPages.INITIAL, // Akan mulai dari LOGIN
      getPages: AppPages.routes,
      theme: ThemeData(
        primaryColor: const Color(0xFF064635),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF064635)),
        useMaterial3: true,
      ),
    ),
  );
}