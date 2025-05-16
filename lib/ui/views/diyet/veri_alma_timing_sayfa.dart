import 'dart:async';
import 'package:diyet/data/entity/diet_model.dart';
import 'package:diyet/data/repo/repository.dart';
import 'package:diyet/ui/views/diyet/diyet_listem_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diyet/data/services/notification_service.dart';
import 'package:diyet/data/entity/diyet_list_model.dart';

class VeriAlmaTimingSayfa extends StatefulWidget {
  @override
  _VeriAlmaTimingSayfaState createState() => _VeriAlmaTimingSayfaState();
}

class _VeriAlmaTimingSayfaState extends State<VeriAlmaTimingSayfa> {
  final List<String> mealLabels = ["Breakfast", "Lunch", "Snack", "Dinner"];
  late List<TimeOfDay?> mealTimes;
  DietModel? _createdDietPlan; // Oluşturulan diyet planını sakla

  bool _isLoading = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    mealTimes = List.filled(mealLabels.length, null);
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteColor: Colors.grey.shade200,
              hourMinuteTextColor: Colors.black,
              dialHandColor: const Color(0xFF8A9B0F),
              dialBackgroundColor: Colors.grey.shade100,
              entryModeIconColor: const Color(0xFF8A9B0F),
              dayPeriodColor: const Color(0xFF8A9B0F),
              dayPeriodTextColor: Colors.black,
              confirmButtonStyle: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey.shade200),
                foregroundColor: MaterialStateProperty.all(Colors.black),
              ),
              cancelButtonStyle: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey.shade200),
                foregroundColor: MaterialStateProperty.all(Colors.black),
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

  void _startLoading() {
    setState(() {
      _isLoading = true;
      _progress = 0.0;
    });

    Timer.periodic(const Duration(milliseconds: 300), (timer) async {
      if (_progress >= 1.0) {
        timer.cancel();
        setState(() {
          _isLoading = false;
        });

        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('userId');

        if (userId == null || userId == 0) {
          print("SharedPreferences'tan geçerli userId alınamadı");
        } else {
          print("Navigating with userId: $userId");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DiyetListem(userId: userId),
            ),
          );
        }
      } else {
        setState(() {
          _progress += 0.1;
        });
      }
    });
  }

  Future<void> _scheduleMealNotifications(DietModel dietPlan, List<DietListDay> dietList) async {
    // Önceki bildirimleri iptal et
    await NotificationService().cancelAll();

    // Öğün zamanlarını bir haritaya eşle (kullanıcının girdiği zamanlar)
    final mealTimeMap = {
      'breakfast': formatTime(mealTimes[0]!),
      'lunch': formatTime(mealTimes[1]!),
      'snack': formatTime(mealTimes[2]!),
      'dinner': formatTime(mealTimes[3]!),
    };

    // start_date ile end_date arasındaki gün sayısını hesapla
    DateTime currentDay = dietPlan.startDate;
    int? dayCount = dietPlan.mealCount; // meal_count, gün sayısını temsil eder
    int notificationCounter = 0; // Benzersiz ID’ler için bir sayaç

    while (dayCount! > 0) {
      // dietList’ten günün öğünlerini bul
      final dayData = dietList.firstWhere(
            (day) => day.day == (dietPlan.mealCount! - dayCount! + 1),
        orElse: () => DietListDay(day: dietPlan.mealCount! - dayCount! + 1, dailyCalories: 0, meals: {}),
      );

      for (final mealType in mealTimeMap.keys) {
        final mealTimeStr = mealTimeMap[mealType];
        if (mealTimeStr == null) continue;

        final timeParts = mealTimeStr.split(':');
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);

        // Günün ilgili öğününü al
        final meal = dayData.meals?[mealType];
        if (meal == null) continue;

        final scheduledDateTime = DateTime(
          currentDay.year,
          currentDay.month,
          currentDay.day,
          hour,
          minute,
        );

        if (scheduledDateTime.isAfter(DateTime.now())) {
          final mealId = meal['id'] as int?;
          if (mealId == null) continue; // Eğer id yoksa, bu öğünü atla

          // Benzersiz bir ID oluştur, 32-bit sınırları içinde kal
          notificationCounter++;
          final notificationId = (mealId % 1000 + notificationCounter) % 2147483647; // 2^31 - 1

          await NotificationService().scheduleNotification(
            id: notificationId,
            title: '$mealType Time',
            body: 'It\'s time for your $mealType! Tap to see the recipe.',
            scheduledDateTime: scheduledDateTime,
            payload: mealId.toString(),
          );
        }
      }

      currentDay = currentDay.add(const Duration(days: 1));
      dayCount--;
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text("Confirmation", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content:  Text("Are you sure you want to create your diyet list?",
              style: GoogleFonts.poppins(fontSize: 18)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:  Text("NO", style: GoogleFonts.poppins(color: Color(0xFF8A9B0F))),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final prefs = await SharedPreferences.getInstance();

                final userId = prefs.getInt('userId');
                final targetWeight = prefs.getInt('target_weight');
                final mealCount = prefs.getInt('meal_count');
                final activity = prefs.getString('activity');

                if (userId == null || targetWeight == null || mealCount == null || activity == null || mealTimes.contains(null)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Missing data. Please complete all fields.")),
                  );
                  return;
                }

                final now = DateTime.now();

                final dietPlan = DietModel(
                  id: null,
                  userId: userId,
                  startDate: now,
                  endDate: now.add(Duration(days: mealCount)),
                  targetWeight: targetWeight,
                  mealCount: mealCount,
                  status: 'active',
                  activity: activity.toLowerCase(),
                  breakfastTime: formatTime(mealTimes[0]!),
                  lunchTime: formatTime(mealTimes[1]!),
                  snackTime: formatTime(mealTimes[2]!),
                  dinnerTime: formatTime(mealTimes[3]!),
                );

                final repo = DietRepository();
                final created = await repo.createDietPlan(dietPlan);
                if (created == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to create diet plan.")),
                  );
                  return;
                }

                _createdDietPlan = created; // Oluşturulan diyet planını sakla
                final listSuccess = await repo.createDietList(userId);

                if (listSuccess) {
                  print("DietMeals oluşturuldu");
                  final dietList = await repo.fetchDietList(userId);
                  if (_createdDietPlan != null && dietList.isNotEmpty) {
                    await _scheduleMealNotifications(_createdDietPlan!, dietList);
                  } else {
                    print("Diyet planı veya liste alınamadı.");
                  }
                } else {
                  print("DietMeals oluşturulamadı");
                }

                _startLoading();
              },
              child:  Text("YES", style: GoogleFonts.poppins(color: Color(0xFF8A9B0F), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  String formatTime(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading ? buildLoadingScreen() : buildMainScreen(),
    );
  }

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
          text:  TextSpan(
            text: "Enter your ",
            style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
            children: [
              TextSpan(
                text: "meal times",
                style: GoogleFonts.poppins(color: Color(0xFFD0A890)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
        Column(
          children: List.generate(mealLabels.length, (index) {
            return _buildMealTimeCard(mealLabels[index], index);
          }),
        ),
        const Spacer(),
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
            child:  Text(
              "Create",
              style: GoogleFonts.poppins(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget buildLoadingScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/salad.png', width: 120, height: 120),
        const SizedBox(height: 30),
         Text('Preparing your recipes', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
         Text(
          '  Setting up your nutrition plan and  \n analyzing your goals...',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
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
        Text('${(_progress * 100).toInt()}%',
            style:  GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFABD904))),
      ],
    );
  }

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
            Text(mealType,
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
            Text(
              mealTimes[index] != null
                  ? "${mealTimes[index]!.hour.toString().padLeft(2, '0')}:${mealTimes[index]!.minute.toString().padLeft(2, '0')}"
                  : "--:--",
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
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