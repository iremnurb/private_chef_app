import 'package:diyet/ui/views/diyet/veri_alma_gun_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diyet/ui/cubit/veri_alma_hareket_sayfa_cubit.dart';

class VeriAlmaHareketSayfa extends StatefulWidget {
  @override
  _VeriAlmaHareketSayfaState createState() => _VeriAlmaHareketSayfaState();
}

class _VeriAlmaHareketSayfaState extends State<VeriAlmaHareketSayfa> {
  String selectedPlan = ""; // Seçili plan başlangıçta boş

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),

              /// **Geri Butonu**
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

              const SizedBox(height: 30),

              /// **Başlık**
              RichText(
                text: const TextSpan(
                  text: "Your ",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
                  children: [
                    TextSpan(
                      text: "activity plan",
                      style: TextStyle(color: Color(0xFFD0A890)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              //Seçenekler
              _buildOption("Sedentary", "assets/images/muz.png"),
              _buildOption("Light", "assets/images/yoga.png"),
              _buildOption("Moderate", "assets/images/halter.png"),
              _buildOption("Active", "assets/images/halter_kaldir.png"),
              _buildOption("Very Active", "assets/images/kupa.png"),

              const SizedBox(height: 40),

              /// **Next Butonu**
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VeriAlmaGunSayfa(),
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
        ),
      ),
    );
  }

  //Activity Seçenek Kartı
  Widget _buildOption(String title, String iconPath) {
    bool isSelected = selectedPlan == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = title;

          //Backend'e veri aktarımı için Cubit'e kaydet
          context.read<VeriAlmaHareketSayfaCubit>().setAktivite(title);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.lightBlue.shade100 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// **Seçenek Metni**
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black : Colors.grey.shade700,
              ),
            ),

            /// **Seçenek İkonu**
            Image.asset(
              iconPath,
              width: 40,
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
