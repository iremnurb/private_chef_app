import 'package:diyet/ui/views/login/kilo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Boy extends StatefulWidget {
  const Boy({super.key});

  @override
  _BoyState createState() => _BoyState();
}

class _BoyState extends State<Boy> {
  int selectedHeight = 175; // Varsayılan boy değeri

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
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
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    text: "How ",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
                    children: [
                      TextSpan(
                        text: "tall",
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFFD3A792)),
                      ),
                      TextSpan(
                        text: " are you?",
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),


            const SizedBox(height: 80),

            // Seçili boy göstergesi (Merkezde büyük değer)
            Center(
              child: Container(
                width: 140,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  selectedHeight.toString(),
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Cupertino Picker (Boy kaydırmalı seçim)
            SizedBox(
              height: 150,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: selectedHeight - 100),
                itemExtent: 50, // Yükseklik
                onSelectedItemChanged: (int index) {
                  setState(() {
                    selectedHeight = 100 + index; // 100 cm'den başlatıyoruz
                  });
                },
                children: List<Widget>.generate(101, (int index) {
                  int heightValue = 100 + index; // 100 - 200 arası değerler
                  return Center(
                    child: Text(
                      heightValue.toString(),
                      style: TextStyle(
                        fontSize: heightValue == selectedHeight ? 24 : 18,
                        fontWeight: heightValue == selectedHeight ? FontWeight.bold : FontWeight.normal,
                        color: heightValue == selectedHeight ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  );
                }),
              ),
            ),

            const Spacer(),

            // Next Butonu
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Kilo() ,
                  ),
                );
                print("Seçilen Boy: $selectedHeight cm");
              },
              child: const Text(
                "Next",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
