import 'package:diyet/ui/views/diyet/veri_alma_timing_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diyet/ui/cubit/veri_alma_gun_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/veri_alma_kilo_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/veri_alma_hareket_sayfa_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class VeriAlmaGunSayfa extends StatefulWidget {
  @override
  _VeriAlmaGunSayfaState createState() => _VeriAlmaGunSayfaState();
}

class _VeriAlmaGunSayfaState extends State<VeriAlmaGunSayfa> {
  int days = 7;
  final TextEditingController _daysController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _daysController.text = days.toString();
    _daysController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final value = int.tryParse(_daysController.text);
    if (value != null && value >= 1 && value <= 60) {
      setState(() {
        days = value;
      });
      context.read<VeriAlmaGunSayfaCubit>().setGunSayisi(days);
    }
  }

  @override
  void dispose() {
    _daysController.dispose();
    super.dispose();
  }

  void _showWarningSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent resizing when keyboard appears
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(height: 30),
          RichText(
            text: TextSpan(
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

          // Gri kutu butonları ve sayı alanını kapsar
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
                      if (days > 1) {
                        days--;
                        _daysController.text = days.toString();
                      }
                    });
                    context.read<VeriAlmaGunSayfaCubit>().setGunSayisi(days);
                  },
                  icon: const Icon(Icons.remove_circle),
                  color: Color(0xFF0C2D48),
                  iconSize: 40,
                ),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _daysController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Only allow digits
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "7",
                      hintStyle: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                    onSubmitted: (value) {
                      final parsedValue = int.tryParse(value);
                      if (parsedValue != null) {
                        if (parsedValue < 1) {
                          setState(() {
                            days = 1;
                            _daysController.text = "1";
                          });
                        } else if (parsedValue > 60) {
                          setState(() {
                            days = 60;
                            _daysController.text = "60";
                          });
                        }
                        context.read<VeriAlmaGunSayfaCubit>().setGunSayisi(days);
                      } else {
                        setState(() {
                          _daysController.text = days.toString();
                        });
                      }
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (days < 60) {
                        days++;
                        _daysController.text = days.toString();
                      }
                    });
                    context.read<VeriAlmaGunSayfaCubit>().setGunSayisi(days);
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
                      color: Color(0xFF8A9B0F),
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
              final parsedValue = int.tryParse(_daysController.text);
              if (parsedValue == null || parsedValue < 1 || parsedValue > 60) {
                _showWarningSnackBar("Please enter a valid number between 1 and 60.");
                return;
              }

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