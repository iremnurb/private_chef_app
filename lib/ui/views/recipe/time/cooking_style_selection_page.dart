import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CookingStyleSelectionPage extends StatefulWidget {
  final List<String> selectedMealTypes;
  final int totalMinutes;

  const CookingStyleSelectionPage({
    super.key,
    required this.selectedMealTypes,
    required this.totalMinutes,
  });

  @override
  State<CookingStyleSelectionPage> createState() => _CookingStyleSelectionPageState();
}

class _CookingStyleSelectionPageState extends State<CookingStyleSelectionPage> {
  final List<String> cookingStyles = ['Quick & Easy', 'One-Pot', 'Low Mess', 'Family Friendly'];
  String? selectedStyle;

  void _onNext() {
    Navigator.pushNamed(
      context,
      '/max_calories_selection',
      arguments: {
        'selectedMealTypes': widget.selectedMealTypes,
        'totalMinutes': widget.totalMinutes,
        'cookingStyle': selectedStyle ?? '',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Cooking Style", style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFFBF7E04),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
           Text("Choose a cooking style",style: GoogleFonts.poppins(),),
          Expanded(
            child: ListView.builder(
              itemCount: cookingStyles.length,
              itemBuilder: (context, index) {
                final style = cookingStyles[index];
                final isSelected = selectedStyle == style;
                return ListTile(
                  title: Text(style),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFFBF7E04)) : null,
                  onTap: () {
                    setState(() {
                      selectedStyle = style;
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _onNext,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFBF7E04)),
              child:  Text("Next", style: GoogleFonts.poppins(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
