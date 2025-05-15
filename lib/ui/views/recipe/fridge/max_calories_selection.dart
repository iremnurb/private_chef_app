import 'package:flutter/material.dart';

import 'macros_selection.dart';


class MaxCaloriesSelectionPage extends StatefulWidget {
  final List<String> selectedIngredients;
  final List<String> selectedMealTypes;

  const MaxCaloriesSelectionPage({
    super.key,
    required this.selectedIngredients,
    required this.selectedMealTypes,
  });

  @override
  State<MaxCaloriesSelectionPage> createState() => _MaxCaloriesSelectionPageState();
}

class _MaxCaloriesSelectionPageState extends State<MaxCaloriesSelectionPage> {
  double _calories = 300;
  final TextEditingController _controller = TextEditingController();

  void _submit({bool isSkip = false}) {
    final int finalCalories = isSkip ? 13500 : _calories.toInt();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MacrosSelectionPage(
          selectedIngredients: widget.selectedIngredients,
          selectedMealTypes: widget.selectedMealTypes,
          maxCalories: finalCalories,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.text = _calories.toInt().toString();
  }

  void _onTextChanged(String value) {
    final newValue = int.tryParse(value);
    if (newValue != null && newValue >= 100 && newValue <= 13500) {
      setState(() {
        _calories = newValue.toDouble();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Max Calories"),
        backgroundColor: const Color(0xFFBF7E04),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Set your maximum calorie limit:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter calories manually",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _onTextChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "${_calories.toInt()} cal",
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                trackHeight: 6,
                activeTrackColor: const Color(0xFFBF7E04),
                inactiveTrackColor: Colors.grey.shade300,
                thumbColor: const Color(0xFFBF7E04),
                overlayColor: const Color(0x30BF7E04), // yarı saydam overlay
              ),
              child: Slider(
                value: _calories,
                min: 100,
                max: 13500,
                divisions: 134,
                label: _calories.toInt().toString(),
                onChanged: (value) {
                  setState(() {
                    _calories = value;
                    _controller.text = value.toInt().toString();
                  });
                },
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _submit(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBF7E04),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text("Next", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => _submit(isSkip: true),
              child: const Text("Skip", style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}
