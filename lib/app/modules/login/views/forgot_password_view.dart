import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';

class ForgotPasswordView extends GetView<AuthController> {
  final emailC = TextEditingController();
  ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Lupa Kata Sandi"), backgroundColor: Colors.white, elevation: 0, foregroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text("Kami akan mengirimkan kode OTP ke Gmail Anda untuk mereset kata sandi.", textAlign: TextAlign.center),
            const SizedBox(height: 30),
            TextField(
              controller: emailC,
              decoration: const InputDecoration(labelText: "Email Gmail", border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
            ),
            const SizedBox(height: 30),
            Obx(() => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.isLoading.value ? null : () => controller.sendOtp(emailC.text.trim(), null, null, false),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF064635)),
                child: controller.isLoading.value ? const CircularProgressIndicator(color: Colors.white) : const Text("KIRIM KODE OTP", style: TextStyle(color: Colors.white)),
              ),
            ))
          ],
        ),
      ),
    );
  }
}