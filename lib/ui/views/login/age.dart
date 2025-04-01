import 'package:diyet/ui/views/login/height.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../cubit/sign_up_cubit.dart';

class Age extends StatefulWidget {
  const Age({super.key});

  @override
  _AgeState createState() => _AgeState();
}

class _AgeState extends State<Age> {
  DateTime? selectedDate;
  int? age;

  // Tarih seçme işlemi
  Future<void> _selectDate(BuildContext context) async {
    DateTime today = DateTime.now();
    DateTime initialDate = selectedDate ?? DateTime(today.year - 18, today.month, today.day);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: today,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF7C8C03),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: const ColorScheme.light(primary: Color(0xFF7C8C03)).copyWith(secondary: Colors.green),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        age = DateTime.now().year - pickedDate.year;
      });
    }
  }

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
                    child: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: const TextSpan(
                  text: "Your ",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
                  children: [
                    TextSpan(
                      text: "date of birth",
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFFD3A792)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 80),

            // Yaş kutusu
            Center(
              child: Container(
                width: 310,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  age != null ? age.toString() : "--",
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Doğum tarihi seçici
            Center(
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  width: 310,
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate != null
                            ? DateFormat("MMMM / dd / yyyy").format(selectedDate!)
                            : "Select your birth date",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const Icon(Icons.calendar_today, color: Colors.black87),
                    ],
                  ),
                ),
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
              onPressed: selectedDate == null ? null : () {
                // Kullanıcı yaşını kaydet
                context.read<SignUpCubit>().setAge(age!);

                // Sonraki sayfaya geç
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Height(),
                  ),
                );
                print("Doğum Tarihi: $selectedDate");
                print("Yaş: $age");
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
