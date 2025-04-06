import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/entity/user_model.dart';
import '../../cubit/login_cubit.dart';

import '../diyet/veri_alma_kilo_sayfa.dart';
import '../recipe/recipe_mode_ana_sayfa.dart';

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.6;

    return Scaffold(
      body: BlocBuilder<LoginCubit, UserModel?>(
        builder: (context, user) {
          final currentUser = user;
          final username = currentUser?.username;

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
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.account_circle, size: 40, color: Colors.black),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
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
                      text: "        Track your ",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "diyet",
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
                SizedBox(
                  height: 400,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
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
                        right: 0,
                        top: 180,
                        child: _buildModeButton(
                          context,
                          "Diet Mode",
                          buttonWidth,
                          const Color(0xFFABD904),
                              () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VeriAlmaKiloSayfa()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildModeButton(
      BuildContext context, String text, double width, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
