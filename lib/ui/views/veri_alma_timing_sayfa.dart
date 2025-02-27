import 'package:flutter/material.dart';

class VeriAlmaTimingSayfa extends StatefulWidget {
  @override
  _VeriAlmaTimingSayfaState createState() => _VeriAlmaTimingSayfaState();
}

class _VeriAlmaTimingSayfaState extends State<VeriAlmaTimingSayfa> {
  TimeOfDay? breakfastTime;
  TimeOfDay? lunchTime;
  TimeOfDay? dinnerTime;

  /// **Saat Seçici Fonksiyonu**
  Future<void> _selectTime(BuildContext context, String mealType) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white, // Arka plan
              hourMinuteColor: Colors.grey.shade200, // Saat ve dakika kutusunun arka planı
              hourMinuteTextColor: Colors.black, // Saat ve dakika yazı rengi
              dialHandColor: const Color(0xFF8A9B0F), // Saat seçim ibresi rengi
              dialBackgroundColor: Colors.grey.shade100, // Saat çemberinin rengi
              entryModeIconColor: const Color(0xFF8A9B0F), // Saat giriş ikonu rengi

              // **AM / PM Seçili Arka Plan Rengi**
              dayPeriodColor: const Color(0xFF8A9B0F), // AM/PM seçildiğinde arka plan rengi
              dayPeriodTextColor: Colors.black, // AM/PM seçili yazı rengi


              // **OK ve CANCEL Butonları**
              confirmButtonStyle: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey.shade200), // OK butonu rengi
                foregroundColor: MaterialStateProperty.all(Colors.black), // OK butonu yazı rengi
              ),
              cancelButtonStyle: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey.shade200), // Cancel butonu rengi
                foregroundColor: MaterialStateProperty.all(Colors.black), // Cancel butonu yazı rengi
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (mealType == "Breakfast") {
          breakfastTime = picked;
        } else if (mealType == "Lunch") {
          lunchTime = picked;
        } else if (mealType == "Dinner") {
          dinnerTime = picked;
        }
      });
    }
  }

  /// **Onay Diyaloğu Açma**
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Confirmation",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure you want to create your diet list?",
            style:TextStyle(fontSize: 18),),
          actions: [
            /// **No Butonu**
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dialog'u kapat
              },
              child: const Text("NO", style: TextStyle(color: Color(0xFF8A9B0F))),
            ),

            /// **Yes Butonu**
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dialog'u kapat
                // TODO: Diyet listesini oluştur ve yönlendir
              },
              child: const Text("YES", style: TextStyle(color: Color(0xFF8A9B0F), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

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
                  child: const Icon(Icons.arrow_back, color: Colors.black, size: 32, weight: 5),
                ),
              ),
            ),
          ),

          const SizedBox(height: 60),

          /// **Başlık**
          RichText(
            text: const TextSpan(
              text: "Enter your ",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
              children: [
                TextSpan(
                  text: "meal times",
                  style: TextStyle(color: Color(0xFFD0A890)), // Açık kahverengi tonu
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          /// **Saat Seçenekleri**
          _buildMealTimeCard("Breakfast", breakfastTime),
          _buildMealTimeCard("Lunch", lunchTime),
          _buildMealTimeCard("Dinner", dinnerTime),

          const Spacer(),

          /// **Create Butonu**
          GestureDetector(
            onTap: () {
              _showConfirmationDialog(); // Onay penceresini aç
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
                "Create",
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// **Yemek Zamanı Seçenek Kartı**
  Widget _buildMealTimeCard(String mealType, TimeOfDay? selectedTime) {
    return GestureDetector(
      onTap: () => _selectTime(context, mealType), // Zaman seçici açılır
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// **Yemek İsmi**
            Text(
              mealType,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),

            /// **Seçili Saat**
            Text(
              selectedTime != null
                  ? "${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}" // Saat biçimi HH:mm
                  : "X:X",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: selectedTime != null ? Colors.black : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
