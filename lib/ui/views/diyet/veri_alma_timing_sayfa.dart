import 'dart:async';
import 'package:flutter/material.dart';

import '../home/ana_sayfa.dart';

class VeriAlmaTimingSayfa extends StatefulWidget {
  final int mealCount;

  VeriAlmaTimingSayfa({required this.mealCount});

  @override
  _VeriAlmaTimingSayfaState createState() => _VeriAlmaTimingSayfaState();
}

class _VeriAlmaTimingSayfaState extends State<VeriAlmaTimingSayfa> {
  List<TimeOfDay?> mealTimes = [];
  bool _isLoading = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    mealTimes = List.filled(widget.mealCount, null);
  }

  //Saat Seçici Fonksiyonu
  Future<void> _selectTime(BuildContext context, int index) async {
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
        mealTimes[index] = picked;
      });
    }
  }

  //YES Butonuna Basıldığında Loading Ekranını Aç
  void _startLoading() {
    setState(() {
      _isLoading = true;
      _progress = 0.0;
    });

    Timer.periodic(Duration(milliseconds: 300), (timer) {
      if (_progress >= 1.0) {
        timer.cancel();
        setState(() {
          _isLoading = false;
        });

        // Yükleme tamamlandığında yeni sayfaya yönlendir
        //sonradan değiştirilecek
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AnaSayfa()),
        );
      } else {
        setState(() {
          _progress += 0.1;
        });
      }
    });
  }

  //Onay Diyaloğu Açma
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation", style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text("Are you sure you want to create your diyet list?",
              style: TextStyle(fontSize: 18)),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("NO", style: TextStyle(color: Color(0xFF8A9B0F))),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dialogu kapat
                _startLoading(); // Yükleme ekranını başlat
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
      body: _isLoading ? buildLoadingScreen() : buildMainScreen(),
    );
  }

  //Ana İçerik Ekranı
  Widget buildMainScreen() {
    return Column(
      children: [
        const SizedBox(height: 40),
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
        const SizedBox(height: 60),


        RichText(
          text: const TextSpan(
            text: "Enter your ",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
            children: [
              TextSpan(
                text: "meal times",
                style: TextStyle(color: Color(0xFFD0A890)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 50),

        /// **Saat Seçenekleri**
        Column(
          children: List.generate(widget.mealCount, (index) {
            return _buildMealTimeCard("Meal ${index + 1}", index);
          }),
        ),

        const Spacer(),

        //reate Butonu
        GestureDetector(
          onTap: _showConfirmationDialog,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFF8A9B0F),
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
    );
  }

  /// **Loading Ekranı**
  Widget buildLoadingScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/salad.png',
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 30),
        const Text(
          'Preparing your recipes',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text(
          '  Setting up your nutrition plan and  \n analyzing your goals...',
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFABD904)),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${(_progress * 100).toInt()}%',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFABD904)),
        ),
      ],
    );
  }

  //Yemek Zamanı Seçenek Kartı
  Widget _buildMealTimeCard(String mealType, int index) {
    return GestureDetector(
      onTap: () => _selectTime(context, index),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
            ),

            /// **Seçili Saat**
            Text(
              mealTimes[index] != null
                  ? "${mealTimes[index]!.hour}:${mealTimes[index]!.minute.toString().padLeft(2, '0')}"
                  : "X:X",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
/*
import 'package:diyet/ui/views/diyet/diyet_listem_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import '../../cubit/diyet_listem_sayfa_cubit.dart';
//import '../../cubit/veri_alma_gun_sayfa_cubit.dart';
//import '../../cubit/veri_alma_hareket_sayfa_cubit.dart';
//import '../../cubit/veri_alma_kilo_sayfa_cubit.dart';

class VeriAlmaTimingSayfa extends StatefulWidget {
  final int mealCount;

  VeriAlmaTimingSayfa({required this.mealCount});

  @override
  _VeriAlmaTimingSayfaState createState() => _VeriAlmaTimingSayfaState();
}

class _VeriAlmaTimingSayfaState extends State<VeriAlmaTimingSayfa> {
  List<TimeOfDay?> mealTimes = [];

  @override
  void initState() {
    super.initState();
    mealTimes = List.filled(widget.mealCount, null);
  }

  /// **Saat Seçici Fonksiyonu**
  Future<void> _selectTime(BuildContext context, int index) async {
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
        mealTimes[index] = picked;
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
          content: const Text("Are you sure you want to create your diyet list?",
            style: TextStyle(fontSize: 18),),
          actions: [
            /// **No Butonu**
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("NO", style: TextStyle(color: Color(0xFF8A9B0F))),
            ),
            /// **Yes Butonu**
            TextButton(
              onPressed: () {



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
                    border: Border.all(color: Colors.black, width: 5),
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
                  style: TextStyle(color: Color(0xFFD0A890)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          /// **Saat Seçenekleri**
          Column(
            children: List.generate(widget.mealCount, (index) {
              return _buildMealTimeCard("Meal ${index + 1}", index);
            }),
          ),

          const Spacer(),

          /// **Create Butonu**
          GestureDetector(
            onTap: () {
              _showConfirmationDialog();
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
  Widget _buildMealTimeCard(String mealType, int index) {
    return GestureDetector(
      onTap: () => _selectTime(context, index),
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
              mealTimes[index] != null
                  ? "${mealTimes[index]!.hour}:${mealTimes[index]!.minute.toString().padLeft(2, '0')}"
                  : "X:X",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: mealTimes[index] != null ? Colors.black : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 */