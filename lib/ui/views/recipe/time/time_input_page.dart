import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ingridients_filter.dart';

class TimeInputPage extends StatefulWidget {
  const TimeInputPage({super.key});

  @override
  State<TimeInputPage> createState() => _TimeInputPageState();
}

class _TimeInputPageState extends State<TimeInputPage> {
  int _cookHours = 0, _cookMinutes = 0;
  int _prepHours = 0, _prepMinutes = 0;

  int get totalMinutes => (_cookHours + _prepHours) * 60 + _cookMinutes + _prepMinutes;

  void _navigateToNext() {
    final cook = (_cookHours * 60) + _cookMinutes;
    final prep = (_prepHours * 60) + _prepMinutes;

    if (cook == 0 && prep == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter at least one time limit.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => IngredientFilterPage(
          cookMinutes: cook,
          prepMinutes: prep,
          totalMinutes: totalMinutes,
        ),
      ),
    );
  }

  void _showTimePicker(String title, Function(int, int) onSelected) {
    int tempHours = 0;
    int tempMinutes = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Select $title'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text("Hours"),
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_up),
                        onPressed: () => setDialogState(() => tempHours = (tempHours + 1) % 24),
                      ),
                      Text(tempHours.toString().padLeft(2, '0')),
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_down),
                        onPressed: () => setDialogState(() => tempHours = (tempHours - 1 + 24) % 24),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      const Text("Minutes"),
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_up),
                        onPressed: () => setDialogState(() => tempMinutes = (tempMinutes + 1) % 60),
                      ),
                      Text(tempMinutes.toString().padLeft(2, '0')),
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_down),
                        onPressed: () => setDialogState(() => tempMinutes = (tempMinutes - 1 + 60) % 60),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onSelected(tempHours, tempMinutes);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTimeInput(color,String label, int h, int m, Function(int, int) onSet, String infoText, {bool isReadOnly = false}) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => _showInfoDialog(label, infoText),
              child: const Icon(Icons.info_outline, size: 18, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: isReadOnly ? null : () => _showTimePicker(label, onSet),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('${h.toString().padLeft(2, '0')} : ${m.toString().padLeft(2, '0')}',
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600)),
          ),
        )
      ],
    );
  }

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('$title Info'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalH = totalMinutes ~/ 60;
    final totalM = totalMinutes % 60;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black, size: 24, weight: 3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            RichText(
                text: TextSpan(
                  text: 'Enter your time ',
                    style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.black87),
                  children: [
                    TextSpan(
                      text: 'limits',
                       style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFD3A792)),
                    ),
                  ]
                ),
            ),


            //const Spacer(),
            SizedBox(height: 70,),
            Image.asset('assets/images/Clock.png'),
            SizedBox(height: 40,),
            Row(
              children: [
                SizedBox(width: 20,),
                _buildTimeInput(Colors.grey.shade300,"Cook Time", _cookHours, _cookMinutes, (h, m) => setState(() {
                  _cookHours = h;
                  _cookMinutes = m;
                }), "Time spent actively cooking (e.g. baking, frying, boiling)."),
                SizedBox(width: 65,),
                _buildTimeInput(Colors.grey.shade300,"Prep Time", _prepHours, _prepMinutes, (h, m) => setState(() {
                  _prepHours = h;
                  _prepMinutes = m;
                }), "Time spent preparing ingredients (e.g. chopping, marinating)."),
                const SizedBox(height: 40),
              ],
            ),
            const SizedBox(height: 40),
            _buildTimeInput(Colors.blueGrey.shade300,"Total Time", totalH, totalM, (_, __) {},
              "Automatically calculated sum of cook and prep time.",
              isReadOnly: true,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: _navigateToNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBF7E04),
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text("Next", style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
