import 'package:diyet/ui/views/diyet/veri_alma_timing_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diyet/ui/cubit/veri_alma_gun_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/veri_alma_kilo_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/veri_alma_hareket_sayfa_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VeriAlmaGunSayfa extends StatefulWidget {
  @override
  _VeriAlmaGunSayfaState createState() => _VeriAlmaGunSayfaState();
}

class _VeriAlmaGunSayfaState extends State<VeriAlmaGunSayfa> {
  int days = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 40),

          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 5),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.black, size: 32, weight: 5),
                ),
              ),
            ),
          ),

          const SizedBox(height: 80),

          RichText(
            text:  TextSpan(
              text: "Diet ",
              style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
              children: [
                TextSpan(
                  text: "duration",
                  style: GoogleFonts.poppins(color: Color(0xFFD0A890)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

           Text(
            "How many days will your diet last?",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 50),

          //  Gri kutu sadece butonları ve sayı alanını kapsar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (days > 1) days--;
                      context.read<VeriAlmaGunSayfaCubit>().setGunSayisi(days);
                    });
                  },
                  icon: const Icon(Icons.remove_circle),
                  color: Color(0xFF0C2D48),
                  iconSize: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "$days",
                    style:  GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (days < 60) days++;
                      context.read<VeriAlmaGunSayfaCubit>().setGunSayisi(days);
                    });
                  },
                  icon: const Icon(Icons.add_circle),
                  color: Color(0xFF0C2D48),
                  iconSize: 40,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text.rich(
               TextSpan(
                children: [
                  TextSpan(
                    text: "Note:  ",
                    style: GoogleFonts.poppins(
                      color: Color(0xFF8A9B0F), // Next butonunun rengi
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                    "Creating a 500 calorie deficit per day is the healthiest approach. Higher deficits can be risky. Please choose your diet duration accordingly.",
                    style: GoogleFonts.poppins(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),

          const Spacer(),

          GestureDetector(
            onTap: () async {
              final gunSayisi = context.read<VeriAlmaGunSayfaCubit>().state;
              final hedefKilo = context.read<VeriAlmaKiloSayfaCubit>().state;
              final aktivite = context.read<VeriAlmaHareketSayfaCubit>().state;

              final prefs = await SharedPreferences.getInstance();
              await prefs.setInt('meal_count', gunSayisi);
              await prefs.setInt('target_weight', hedefKilo);
              await prefs.setString('activity', aktivite);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VeriAlmaTimingSayfa(),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFF8A9B0F),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                "Next",
                style: GoogleFonts.poppins(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}







/*class VeriAlmaGunSayfa extends StatefulWidget {
  @override
  _VeriAlmaGunSayfaState createState() => _VeriAlmaGunSayfaState();
}

class _VeriAlmaGunSayfaState extends State<VeriAlmaGunSayfa> {
  int meals = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 5),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.black, size: 32, weight: 5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 80),
          RichText(
            text: const TextSpan(
              text: "Your ",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
              children: [
                TextSpan(
                  text: "meal number",
                  style: TextStyle(color: Color(0xFFD0A890)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.3,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$meals",
                  style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
              const SizedBox(width: 15),
              Column(
                children: [
                  _buildControlButton("+", () {
                    setState(() {
                      if (meals < 5) meals++;
                    });
                  }),
                  const SizedBox(height: 10),
                  _buildControlButton("-", () {
                    setState(() {
                      if (meals > 2) meals--;
                    });
                  }),
                ],
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              // 🔗 Backend için cubit'e gönderiyoruz
              context.read<VeriAlmaGunSayfaCubit>().setOgunSayisi(meals);

              // 🟢 Devam ediyoruz
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VeriAlmaTimingSayfa(mealCount: meals),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFF8A9B0F),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Next",
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildControlButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.16,
        height: MediaQuery.of(context).size.width * 0.12,
        decoration: BoxDecoration(
          color: const Color(0xFF0C2D48),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}*/
