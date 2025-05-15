import 'package:flutter/material.dart';
import 'veri_alma_kilo_sayfa.dart'; // yönlendirilecek hedef sayfa

class DiyetIntroSayfa extends StatelessWidget {
  const DiyetIntroSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true, // geri butonunu göster
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black), // geri oku siyah yap
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome to Diet Mode!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "This is not a strict or restrictive diet program. Instead, it’s a flexible and supportive approach that helps you track your meals, build healthier eating habits, and gradually move towards your weight goals.\n\n"
                    "Think of it as a guide to understand your eating patterns and make more conscious food choices — without the pressure. Whether your goal is to lose weight or simply eat better, this process will help you stay consistent and feel in control of your journey.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFABD904), // yeşil tonu
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => VeriAlmaKiloSayfa()),
                    );
                  },
                  child: const Text(
                    "Got it!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
