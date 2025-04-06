
import 'package:flutter/material.dart';

import 'login.dart';


class IlkSayfa extends StatelessWidget {
  const IlkSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/onboarding.png', // Arka plan görseli
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.3), // Karanlık katman efekti
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to\nPrivate Chef",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 245),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7C8C03),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 90),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    );                  },
                  child: const Text("Get Started",
                  style: TextStyle(color: Colors.white , fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 14),
                Row(
                  children: const [
                    Expanded(child: Divider(color: Colors.white54, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "or use social sign up",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.white54, thickness: 1)),
                  ],
                ),
                const SizedBox(height: 14),
                _buildSocialButton(
                  imagePath: "assets/images/google.png",
                  text: "Continue with Google",
                ),
                const SizedBox(height: 10),
                _buildSocialButton(
                  imagePath: "assets/images/apple.png",
                  text: "Continue with Apple",
                ),
                const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              },
              child: RichText(
                text: const TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: "Log In",
                      style: TextStyle(

                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline, // Altı çizili

                      ),
                    ),
                  ],
                ),
              ),
            ),
            ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({required String imagePath, required String text}) {
    return Container(
      width: 280,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

