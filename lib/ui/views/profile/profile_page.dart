import 'package:diyet/ui/views/profile/editProfile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../cubit/login_cubit.dart';
import '../../cubit/profile_cubit.dart';
import '../../views/login/login.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  double calculateBMR({required String gender, required int weight, required int height, required int age}) {
    if (gender.toLowerCase() == 'male') {
      return 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      return 10 * weight + 6.25 * height - 5 * age - 161;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<ProfileCubit>().state;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final String username = user.username;
    final int age = user.age;
    final int height = user.height;
    final int weight = user.weight;
    final String gender = user.gender;
    final double bmr = calculateBMR(gender: gender, weight: weight, height: height, age: age);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text("Profile", style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              Text("Hello $username, you look fit!",
                  style: GoogleFonts.poppins(color: Colors.grey[600])),
              const SizedBox(height: 40),

              // Bilgi Kartları
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  runSpacing: 12,
                  spacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _infoBox("Age", "$age", "Year"),
                    _infoBox("Height", "$height", "cm"),
                    _infoBox("weight", "$weight", "kg"),
                    _infoBox("BMR", bmr.toStringAsFixed(0), "kcal"),
                  ],
                ),
              ),

              const SizedBox(height: 70),

              // Düzenle Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push( // pushReplacement yerine push kullanıldı
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9BBA9),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    "Edit Profile",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Çıkış Yap Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await context.read<LoginCubit>().logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const Login()),
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9BBA9),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    "Log Out",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBox(String title, String value, String unit) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 140, maxWidth: 160),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value,
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFD9BBA9))),
            Text(unit, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 4),
            Text(title, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[800])),
          ],
        ),
      ),
    );
  }
}