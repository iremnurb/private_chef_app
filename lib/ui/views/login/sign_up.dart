import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../cubit/sign_up_cubit.dart';
import 'gender.dart';
import 'login.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Üst Kısım (Arka plan resmi ve başlık)
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/login_ust.png"),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 75),
              child:  Text(
                "Sign Up",
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Form Alanı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextField("Username", "Enter your username", usernameController),
                  buildTextField("Email", "Enter your email", emailController),
                  buildTextField("Password", "Enter your password", passwordController, obscure: true),
                  const SizedBox(height: 14),

                  // Terms and Privacy
                   Text.rich(
                    TextSpan(
                      text: "By continuing you agree to our ",
                      style: GoogleFonts.poppins(fontSize: 13, color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Terms of Service",
                          style: GoogleFonts.poppins(color: Color(0xFF7C8C03), fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: " and ",style: GoogleFonts.poppins()),
                        TextSpan(
                          text: "Privacy Policy.",
                          style: GoogleFonts.poppins(color: Color(0xFF7C8C03), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Sign Up Butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C8C03),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  context.read<SignUpCubit>().setUsername(usernameController.text);
                  context.read<SignUpCubit>().setEmail(emailController.text);
                  context.read<SignUpCubit>().setPassword(passwordController.text);


                  // Gender sayfasına yönlendir
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Gender(),
                    ),
                  );
                },
                child:  Text(
                  "Sign Up",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Login Link
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              child: RichText(
                text:  TextSpan(
                  text: "Already have an account? ",
                  style: GoogleFonts.poppins(color: Colors.black, fontSize: 14),
                  children: [
                    TextSpan(
                      text: "Log in",
                      style: GoogleFonts.poppins(
                        color: Color(0xFF7C8C03),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Ortak TextField Yapısı
  Widget buildTextField(String label, String hint, TextEditingController controller, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              border: const UnderlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
