import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GenericLoadingScreen extends StatelessWidget {
  final double progress;
  final String title;
  final String subtitle;
  final String imageAssetPath;

  const GenericLoadingScreen({
    Key? key,
    required this.progress,
    this.title = 'Preparing your recipes',
    this.subtitle = '  Setting up your nutrition plan and  \n analyzing your goals...',
    this.imageAssetPath = 'assets/images/salad.png',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imageAssetPath, width: 120, height: 120),
        const SizedBox(height: 30),
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          subtitle,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFABD904)),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${(progress * 100).toInt()}%',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFABD904),
          ),
        ),
      ],
    );
  }
}
