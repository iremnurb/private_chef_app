import 'package:diyet/ui/views/diyet/veri_alma_hareket_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diyet/ui/cubit/veri_alma_kilo_sayfa_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

class VeriAlmaKiloSayfa extends StatefulWidget {
  @override
  _VeriAlmaKiloSayfaState createState() => _VeriAlmaKiloSayfaState();
}

class _VeriAlmaKiloSayfaState extends State<VeriAlmaKiloSayfa> {
  int weight = 60; // Varsayılan ağırlık (kg)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),

          // Geri Butonu
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
                  child: const Icon(Icons.arrow_back, color: Colors.black, size: 32),
                ),
              ),
            ),
          ),

          const SizedBox(height: 75),

          // Başlık
          RichText(
            text:  TextSpan(
              text: "Your ",
              style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
              children: [
                TextSpan(
                  text: "target weight",
                  style: GoogleFonts.poppins(color: Color(0xFFD0A890)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Sadece "kg" yazısı
           Text(
            "kg",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 10),
          const Icon(Icons.arrow_drop_down, size: 30, color: Color(0xFFF2B33D)),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "$weight",
              style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),

          const SizedBox(height: 10),

          // Sürüklenebilir Ağırlık Ölçeği
          SizedBox(
            height: 150,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 50,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  weight = 30 + index;
                  context.read<VeriAlmaKiloSayfaCubit>().setKilo(weight);
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  return Text(
                    "${30 + index}",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: weight == (30 + index) ? FontWeight.bold : FontWeight.normal,
                      color: weight == (30 + index) ? Colors.black87 : Colors.grey,
                    ),
                  );
                },
                childCount: 71,
              ),
              controller: FixedExtentScrollController(
                initialItem: weight - 30,
              ),
            ),
          ),

          const Spacer(),

          // Next Butonu
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
                color: const Color(0xFF8A9B0F),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child:  Text(
                "Next",
                style: GoogleFonts.poppins(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
