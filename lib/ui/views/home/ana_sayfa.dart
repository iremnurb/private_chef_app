import 'package:diyet/ui/views/diyet/veri_alma_kilo_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:diyet/ui/views/recipe/recipe_mode_ana_sayfa.dart';



class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.6;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  icon: const Icon(Icons.account_circle,
                      size: 40, color: Colors.black),
                  onPressed: () {

                  },
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
                    text: "diet",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFFABD904)),
                  ),
                  TextSpan(
                    text: " or explore delicious ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextSpan(
                    text: "recipes.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFFF2B33D)),
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
                    color: const Color(0xFFF2B33D),
                    text: "Recipe Mode",
                    width: buttonWidth,
                    height: 200,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  RecipeModeAnaSayfa(),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 180,
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
                          builder: (context) =>  VeriAlmaKiloSayfa(),
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
    );
  }

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
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
