import 'package:flutter/material.dart';
import 'package:diyet/ui/views/ana_sayfa.dart';

class Kilo extends StatefulWidget {
  const Kilo({super.key});

  @override
  _KiloState createState() => _KiloState();
}

class _KiloState extends State<Kilo> {
  double selectedWeight = 72; // Varsayılan kilo
  bool isKg = true; // KG - LB seçimi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black, size: 24, weight: 3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Başlık
             Align(
               alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  text: "Your ",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
                  children: [
                    TextSpan(
                      text: "current weight",
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFFD3A792)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 70),

            // Birim Seçme Butonu (KG - LB)
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildUnitButton("kg", isKg),
                  const SizedBox(width: 10),
                  _buildUnitButton("lb", !isKg),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Seçili Kilo Göstergesi
            Center(
              child: Container(
                width: 120,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  selectedWeight.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                activeTrackColor: Colors.green[700],
                inactiveTrackColor: Colors.grey[300],
                thumbColor: Colors.amber,
                overlayColor: Colors.amber.withOpacity(0.2),
                valueIndicatorColor: Colors.green[700],
                showValueIndicator: ShowValueIndicator.always,
              ),
              child: Slider(
                min: isKg ? 30 : 66, // 30 kg - 150 kg || 66 lb - 330 lb
                max: isKg ? 150 : 330,
                divisions: 120,
                value: selectedWeight,
                onChanged: (double value) {
                  setState(() {
                    selectedWeight = value;
                  });
                },
              ),
            ),

            const Spacer(),

            // Kaydol Butonu
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C8C03),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // Kayıt işlemi tamamlandı mesajı
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Kayıt oluşturuldu"),
                    duration: Duration(seconds: 2),
                  ),
                );

                // 2 saniye sonra AnaSayfa'ya yönlendir
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AnaSayfa()),
                  );
                });
              },
              child: const Text(
                "Kaydol",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // KG / LB Seçme Butonu
  Widget _buildUnitButton(String unit, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isKg = (unit == "kg");
          selectedWeight = isKg ? 72 : 158;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF0C2D48) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          unit,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}

