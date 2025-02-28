import 'package:diyet/ui/views/veri_alma_gun_sayfa.dart';
import 'package:diyet/ui/views/veri_alma_hareket_sayfa.dart';
import 'package:flutter/material.dart';

class VeriAlmaKiloSayfa extends StatefulWidget {
  @override
  _VeriAlmaKiloSayfaState createState() => _VeriAlmaKiloSayfaState();
}

class _VeriAlmaKiloSayfaState extends State<VeriAlmaKiloSayfa> {
  bool isKgSelected = true; // Varsayılan olarak kg seçili
  int weight = 60; // Varsayılan ağırlık

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40), // Üst boşluk ekleyerek ikonun ekranın tepesine yapışmasını engelliyoruz.

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
                    border: Border.all(color: Colors.black, width: 5), // Dış çerçeve rengi
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.black, size:32,weight: 5,),
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
                  text: "target weight",
                  style: TextStyle(color: Color(0xFFD0A890)), // Açık kahverengi tonu
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          /// **Kg / Lb Toggle**
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUnitButton("kg", isKgSelected),
              const SizedBox(width: 10),
              _buildUnitButton("lb", !isKgSelected),
            ],
          ),
          const SizedBox(height: 10),

          /// **Ağırlık Seçici (Wheel Picker)**
          const Icon(Icons.arrow_drop_down, size: 30, color: Color(0xFFF2B33D)), // Sarı ok
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "$weight",
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 10),

          /// **Sürüklenebilir Ağırlık Ölçeği**
          SizedBox(
            height: 150,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 50, // Her elemanın yüksekliği
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  weight = isKgSelected ? (30 + index) : ((30 + index) * 2.2).toInt(); // lb dönüşümü
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  return Text(
                    "${30 + index}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: weight == (30 + index) ? FontWeight.bold : FontWeight.normal,
                      color: weight == (30 + index) ? Colors.black87 : Colors.grey,
                    ),
                  );
                },
                childCount: 71, // 30-100 arasında değerler
              ),
              controller: FixedExtentScrollController(
                initialItem: weight - 30, // Varsayılan ağırlık seçili başlasın
              ),
            ),
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

  /// **Kg / Lb Seçenek Butonu**
  Widget _buildUnitButton(String unit, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isKgSelected = unit == "kg";
          weight = isKgSelected ? weight : (weight * 2.2).toInt(); // lb'ye çevir
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0C2D48) : Colors.transparent, // Koyu mavi veya transparan
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          unit,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
