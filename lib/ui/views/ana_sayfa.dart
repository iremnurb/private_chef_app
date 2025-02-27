import 'package:diyet/ui/views/veri_alma_gun_sayfa.dart';
import 'package:diyet/ui/views/veri_alma_kilo_sayfa.dart';
import 'package:flutter/material.dart';

class AnaSayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Ekran genişliği
    double buttonWidth = screenWidth * 0.6; // Buton genişliği (Ekranın %60'ı)

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Hello İrem !",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.account_circle, size: 40, color: Colors.black),
                onPressed: () {
                  // TODO: Profil sayfasına git
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0), // Kenarlara tam dayalı
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20), // Yazılar hizalı olsun diye
              child: Text(
                "Choose a mode to start your journey!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                text: const TextSpan(
                  text: "Track your ",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  children: [
                    TextSpan(
                      text: "diet",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFABD904)),
                    ),
                    TextSpan(
                      text: " or explore delicious ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: "recipes.",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF2B33D)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            /// **Mode Seçenekleri (Tam Kenara Dayalı)**
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    left: 0, // **Ekranın soluna tamamen dayalı**
                    top: 60,
                    child: _buildModeButton(
                      color: const Color(0xFFF2B33D),
                      text: "Recipe Mode",
                      width: buttonWidth,
                      height: 200,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      onTap: () {
                        // TODO: Tarif sayfasına git
                      },
                    ),
                  ),
                  Positioned(
                    right: 0, // **Ekranın sağına tamamen dayalı**
                    top: 180, // Hafif aşağı kaydırılmış
                    child: _buildModeButton(
                      color: const Color(0xFFABD904),
                      text: "Diet Mode",
                      width: buttonWidth,
                      height: 200,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VeriAlmaKiloSayfa(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **Mode Butonu Tasarımı**
  Widget _buildModeButton({
    required Color color,
    required String text,
    required double width,
    required double height,
    required BorderRadius borderRadius,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
