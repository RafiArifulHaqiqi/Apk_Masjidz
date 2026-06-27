import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailC = TextEditingController();
    final passC = TextEditingController();
    // Inisialisasi controller agar tidak null
    final authC = Get.put(AuthController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LOGO & NAMA
                Row(
                  children: [
                    const Icon(Icons.mosque, color: Color(0xFF064635), size: 30),
                    const SizedBox(width: 10),
                    const Text("Al-Nur", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 32),
                const Text("Assalamu Alaikum", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF064635))),
                const Text("Please sign in to your community account.", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),

                // EMAIL FIELD
                const Text("Email Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                TextField(
                  controller: emailC,
                  decoration: InputDecoration(
                    hintText: "name@example.com",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), // MEMBUAT KOTAK
                  ),
                ),
                const SizedBox(height: 16),

                // PASSWORD FIELD
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    GestureDetector(
                      onTap: () => authC.sendRealOtp(emailC.text),
                      child: const Text("Forgot Password?", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(() => TextField(
                  controller: passC,
                  obscureText: !authC.isPasswordVisible.value,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    // TOMBOL MATA
                    suffixIcon: IconButton(
                      icon: Icon(authC.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => authC.isPasswordVisible.toggle(),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), // MEMBUAT KOTAK
                  ),
                )),

                const SizedBox(height: 30),
                
                // BUTTON SIGN IN
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF064635),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: authC.isLoading.value ? null : () => authC.login(emailC.text, passC.text),
                    child: authC.isLoading.value 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text("Sign In", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )),
                ),
                
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () => Get.toNamed('/register'),
                      child: const Text("Sign up", style: TextStyle(color: Color(0xFF064635), fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}