import 'package:diyet/ui/views/veri_alma_gun_sayfa.dart';
import 'package:diyet/ui/views/veri_alma_timing_sayfa.dart';
import 'package:flutter/material.dart';

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
      body: Column(
        children: [
          const SizedBox(height: 40),

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
                    border: Border.all(color: Colors.black, width: 5), // Çerçeve rengi
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.black, size: 32,weight: 5,),
                ),
              ),
            ),
          ),

          const SizedBox(height: 60),

          /// **Başlık**
          RichText(
            text: const TextSpan(
              text: "Your ",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
              children: [
                TextSpan(
                  text: "activity plan",
                  style: TextStyle(color: Color(0xFFD0A890)), // Açık kahverengi tonu
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          /// **Seçenekler**
         _buildOption("Low", "assets/images/muz.png"),
          _buildOption("Medium", "assets/images/halter.png"),
          _buildOption("High", "assets/images/kupa.png"),

          const Spacer(),

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
                color: const Color(0xFF8A9B0F), // Yeşil tonu
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

  /// **Activity Seçenek Kartı**
  Widget _buildOption(String title, String iconPath) {
    bool isSelected = selectedPlan == title; // Seçili olup olmadığını kontrol et

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = title; // Seçilen planı güncelle
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.lightBlue.shade100 : Colors.grey.shade100, // Seçiliyse açık mavi, değilse gri
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
                color: isSelected ? Colors.black : Colors.grey.shade700, // Seçiliyse siyah, değilse gri tonu
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
