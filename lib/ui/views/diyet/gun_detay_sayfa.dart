import 'package:flutter/material.dart';
import 'package:diyet/ui/views/diyet/ogun_detay_sayfa.dart';
import 'package:google_fonts/google_fonts.dart';

class GunDetaySayfa extends StatelessWidget {
  final int gunNo;
  final int userId;
  final Map<String, dynamic> meals;

  const GunDetaySayfa({
    Key? key,
    required this.gunNo,
    required this.userId,
    required this.meals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mealOrder = ['breakfast', 'snack', 'lunch', 'dinner'];
    final mealImages = {
      'breakfast': 'assets/images/Breakfast.png',
      'snack': 'assets/images/Snack.png',
      'lunch': 'assets/images/Lunch.png',
      'dinner': 'assets/images/Dinner.png',
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text(
          'Diet List',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Day $gunNo",
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8A9B0F),
              ),
            ),
          ),
          const SizedBox(height: 50),
          Expanded(
            child: ListView.builder(
              itemCount: mealOrder.length,
              itemBuilder: (context, index) {
                final mealKey = mealOrder[index];
                final mealData = meals[mealKey];

                if (mealData == null || mealData is! Map) return const SizedBox();

                final totalTime = mealData['totalTime']?.toString() ?? "0M";
                final calories = mealData['calories'] ?? 0;
                final mealName = mealKey[0].toUpperCase() + mealKey.substring(1);

                return GestureDetector(
                  onTap: () {
                    final mealId = mealData['id'];
                    if (mealId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OgunDetaySayfa(mealId: mealId,themeColor:  Color(0xFFABD904)),
                        ),
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4FB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          mealImages[mealKey]!,
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mealName,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _infoBadge(Icons.access_time, totalTime),
                                  const SizedBox(width: 8),
                                  _infoBadge(Icons.local_fire_department, "$calories kcal"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Color(0xFF8A9B0F)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.orange),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.orange),
          ),
        ],
      ),
    );
  }
}
