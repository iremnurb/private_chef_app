
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../cubit/sign_up_cubit.dart';
import 'age.dart';

class Gender extends StatefulWidget {
  const Gender({super.key});

  @override
  _GenderState createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 70),
            // Başlık
            RichText(
              text: TextSpan(
                text: "  What is your ",
                style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  TextSpan(
                    text: "gender?",
                    style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFD3A792)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 70),

            // Erkek ve Kadın Seçenekleri
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGenderCard("Male", "assets/images/erkek.png"),
                const SizedBox(width: 20),
                _buildGenderCard("Female", "assets/images/kadın.png"),
              ],
            ),

            const Spacer(),

            // Next Butonu
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C8C03),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: selectedGender == null ? null : () {
                // Cinsiyeti kaydet
                context.read<SignUpCubit>().setGender(selectedGender!);

                // Sonraki sayfaya geç
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Age(),
                  ),
                );
              },
              child:  Text(
                "Next",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Cinsiyet seçim kartı
  Widget _buildGenderCard(String gender, String imagePath) {
    bool isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: Container(
        width: 140,
        height: 160,
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[300] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: const Color(0xFF7C8C03), width: 2) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 80),
            const SizedBox(height: 10),
            Text(
              gender,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
