import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';

class ResetPasswordView extends GetView<AuthController> {
  // PINDAHKAN KE SINI (DI LUAR BUILD)
  final newPassC = TextEditingController();
  final confirmNewPassC = TextEditingController();

  ResetPasswordView({super.key}); // Ubah const jadi biasa karena ada controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Reset Password"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Buat Kata Sandi Baru",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() => Text(
                  "Untuk email: ${controller.emailRecovery.value}",
                  style: const TextStyle(color: Colors.grey),
                )),
            const SizedBox(height: 32),

            const Text("Sandi Baru", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: newPassC,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "••••••••",
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),

            const Text("Konfirmasi Sandi Baru", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: confirmNewPassC,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "••••••••",
                prefixIcon: const Icon(Icons.history),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (newPassC.text.isEmpty || confirmNewPassC.text.isEmpty) {
                              Get.snackbar("Peringatan", "Kolom tidak boleh kosong");
                            } else if (newPassC.text == confirmNewPassC.text) {
                              controller.finalizeNewPassword(newPassC.text);
                            } else {
                              Get.snackbar("Error", "Sandi tidak cocok");
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF064635),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("SIMPAN & MASUK",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}