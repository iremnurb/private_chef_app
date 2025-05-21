import 'package:diyet/ui/views/diyet/diyet_intro_sayfa.dart';
import 'package:diyet/ui/views/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../data/entity/user_model.dart';
import '../../cubit/login_cubit.dart';
import '../diyet/diyet_listem_sayfa.dart';
import '../diyet/veri_alma_kilo_sayfa.dart';
import '../recipe/recipe_mode_ana_sayfa.dart';
import '../favori_sayfa.dart';
import '../profile/profile_page.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({Key? key}) : super(key: key);

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _currentIndex = 1; // Başlangıçta Ana Sayfa seçili

  final List<Widget> _pages = [
    const FavoriSayfa(),
    const AnaSayfaContent(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25,
        backgroundColor: Colors.white70,
        unselectedFontSize: 12,
        selectedFontSize: 14,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.shade500,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home Page",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class AnaSayfaContent extends StatelessWidget {
  const AnaSayfaContent({Key? key}) : super(key: key);

  Future<void> _handleDietMode(BuildContext context) async {
    final user = context.read<LoginCubit>().state;
    if (user == null) return;

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5002/api/diet-status?userId=${user.id!}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['status'];

        if (status == 'active') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DiyetListem(userId: user.id!)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DiyetIntroSayfa()),
          );
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DiyetIntroSayfa()),
        );
      }
    } catch (e) {
      debugPrint('Diet plan kontrol edilirken hata: $e');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VeriAlmaKiloSayfa()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.6;

    return BlocBuilder<LoginCubit, UserModel?>(
      builder: (context, user) {
        final currentUser = user;
        final username = currentUser?.username ?? "Guest";

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hello $username!",
                      style:  GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.power_settings_new_rounded, size: 32, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Login()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
               Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Choose a mode to start your journey!",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                  text:  TextSpan(
                    text: "   Track your ",
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                    children: [
                      TextSpan(
                        text: "diet",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Color(0xFFABD904)),
                      ),
                      TextSpan(
                        text: " or explore delicious ",
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                      TextSpan(
                        text: "recipes.",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Color(0xFFF2B33D)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 400,
                child: Stack(
                  children: [
                    Positioned(
                      left: -40,
                      top: 60,
                      child: _buildModeButton(
                        context,
                        "Recipe Mode",
                        buttonWidth,
                        const Color(0xFFF2B33D),
                            () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RecipeModeAnaSayfa()),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -30,
                      top: 200,
                      child: _buildModeButton(
                        context,
                        "Diet Mode",
                        buttonWidth,
                        const Color(0xFFABD904),
                            () => _handleDietMode(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModeButton(
      BuildContext context, String text, double width, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 14),
        child: Container(
          width: width,
          height: 200,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style:  GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}