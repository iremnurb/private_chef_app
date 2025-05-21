

import 'package:diyet/ui/views/recipe/time/time_input_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fridge/fridge.dart';


class RecipeModeAnaSayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Butonları sola hizalamak için
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 3), // Dış çerçeve rengi
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.black, size: 24, weight: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              RichText(
                text:  TextSpan(
                  text: "   Discover the Recipe Mode: Get personalized recipe\n suggestions based on ",
                  style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey),
                  children: [
                    TextSpan(
                      text: "What’s in  your fridge",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Color(0xFFF2B33D)),
                    ),
                    TextSpan(
                      text: " and \n ",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                    TextSpan(
                      text: "Time limits !",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Color(0xFFF2B33D)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 70),

              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Butonları sola hizalamak için
                  children: [
                    _buildFridgeButton(
                      context: context,
                      text: "What’s in My Fridge?",
                      iconAsset: 'assets/images/refrigerator.png', // Assets'teki yeni ikon
                      width: screenWidth * 0.75,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DolabimdaNeVar()), // Fridge sayfasına yönlendirme
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    _buildTimeLimitButton(
                      context: context,
                      text: "Time Limits",
                      iconAsset: 'assets/images/alarm.png', // Assets'teki yeni ikon
                      width: screenWidth * 0.6,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TimeInputPage()), // Fridge sayfasına yönlendirme
                        );

                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFridgeButton({
    required BuildContext context,
    required String text,
    required String iconAsset, // İkon artık bir asset dosyası
    required double width,
    required VoidCallback onTap, // Butona tıklandığında çalışacak fonksiyon
  }) {
    return GestureDetector(
      onTap: onTap, // Butona tıklandığında yönlendirme
      child: Container(
        width: width,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFF2B33D),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30), // Sağ üst köşe yuvarlak
            bottomRight: Radius.circular(30), // Sağ alt köşe yuvarlak
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Image.asset(
                iconAsset, // Assets'teki resim dosyası
                width: 28,
                height: 28,
                color: Colors.black, // İkon rengi
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeLimitButton({
    required BuildContext context,
    required String text,
    required String iconAsset, // İkon artık bir asset dosyası
    required double width,
    required VoidCallback onTap, // Butona tıklandığında çalışacak fonksiyon
  }) {
    return GestureDetector(
      onTap: onTap, // Butona tıklandığında yönlendirme
      child: Container(
        width: width,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFF2B33D),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30), // Sağ üst köşe yuvarlak
            bottomRight: Radius.circular(30), // Sağ alt köşe yuvarlak
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Image.asset(
                iconAsset, // Assets'teki resim dosyası
                width: 28,
                height: 28,
                color: Colors.black, // İkon rengi
              ),
            ),
          ],
        ),
      ),
    );
  }
}