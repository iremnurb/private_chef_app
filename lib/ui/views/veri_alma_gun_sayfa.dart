import 'package:diyet/ui/views/veri_alma_hareket_sayfa.dart';
import 'package:flutter/material.dart';

class VeriAlmaGunSayfa extends StatefulWidget {
  @override
  _VeriAlmaGunSayfaState createState() => _VeriAlmaGunSayfaState();
}

class _VeriAlmaGunSayfaState extends State<VeriAlmaGunSayfa> {
  int days = 0; // Gün sayısı 0'dan başlıyor.

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

          const SizedBox(height: 80),

          /// **Başlık**
          RichText(
            text: const TextSpan(
              text: "Your ",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
              children: [
                TextSpan(
                  text: "target day",
                  style: TextStyle(color: Color(0xFFD0A890)), // Açık kahverengi tonu
                ),
              ],
            ),
          ),

          const SizedBox(height: 70),

          /// **Gün Sayısı Seçici**
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Gün Sayısı
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.3,
                alignment: Alignment.center,
                padding:  EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$days",
                  style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Colors.black87),

                ),
              ),

              const SizedBox(width: 15),

              /// **+ ve - Butonları**
              Column(
                children: [
                  _buildControlButton("+", () {
                    setState(() {
                      days++; // Gün sayısını artır
                    });
                  }),
                  const SizedBox(height: 10),
                  _buildControlButton("-", () {
                    setState(() {
                      if (days > 0) days--; // Gün sayısını azalt, 0'dan küçük olamaz
                    });
                  }),
                ],
              ),
            ],
          ),

          const Spacer(),

          /// **Next Butonu**
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VeriAlmaHareketSayfa(),
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

  /// **+ ve - Butonu Tasarımı**
  Widget _buildControlButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.16,
        height: MediaQuery.of(context).size.width * 0.12,
        decoration: BoxDecoration(
          color: const Color(0xFF0C2D48), // Koyu mavi arka plan
            borderRadius: BorderRadius.circular(16)
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
