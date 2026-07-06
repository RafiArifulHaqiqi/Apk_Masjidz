import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confirmC = TextEditingController();

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.mosque, color: Color(0xFF064635), size: 60),
            const Text(
              "Al-Hidayah",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF064635)),
            ),
            const SizedBox(height: 10),
            const Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text("Verify your email to join the community", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Full Name"),
                  _input(nameC, "John Doe", Icons.person_outline),
                  const SizedBox(height: 16),
                  
                  _label("Email Address"),
                  _input(emailC, "email@example.com", Icons.email_outlined),
                  const SizedBox(height: 16),
                  
                  _label("Password"),
                  Obx(() => _input(
                    passC, "••••••••", Icons.lock_outline, 
                    isPass: true,
                    isVisible: authC.isPasswordVisible.value,
                    onToggle: () => authC.isPasswordVisible.value = !authC.isPasswordVisible.value,
                  )),
                  const SizedBox(height: 30),
                  
                  // --- TOMBOL SIGN UP (PANGGIL OTP) ---
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: Obx(() => ElevatedButton(
                      onPressed: authC.isLoading.value 
                        ? null 
                        : () => authC.sendOtp(emailC.text.trim(), nameC.text, passC.text, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF064635),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: authC.isLoading.value 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Sign Up & Verify →", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: () => Get.toNamed('/login'),
                  child: const Text("Sign In", style: TextStyle(color: Color(0xFF064635), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String txt) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(txt, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
  );

  Widget _input(TextEditingController c, String h, IconData i, {bool isPass = false, bool? isVisible, VoidCallback? onToggle}) {
    return TextField(
      controller: c,
      obscureText: isPass ? !(isVisible ?? false) : false,
      decoration: InputDecoration(
        hintText: h,
        prefixIcon: Icon(i),
        suffixIcon: isPass ? IconButton(
          icon: Icon(isVisible! ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggle,
        ) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
      ),
    );
  }
}