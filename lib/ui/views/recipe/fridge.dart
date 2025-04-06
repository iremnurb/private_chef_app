import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DolabimdaNeVar extends StatefulWidget {
  const DolabimdaNeVar({super.key});

  @override
  _DolabimdaNeVarState createState() => _DolabimdaNeVarState();
}

class _DolabimdaNeVarState extends State<DolabimdaNeVar> {
  bool _isLoading = false;
  double _progress = 0.0;
  Map<String, List<String>> categorizedIngredients = {};

  @override
  void initState() {
    super.initState();
    loadIngredients();
  }

  Future<void> loadIngredients() async {
    try {
      final String response = await rootBundle.loadString("assets/categorized_ingredients2.json");
      if (response.isEmpty) {
        print("Error: JSON file is empty.");
        return;
      }

      final Map<String, dynamic> data = json.decode(response);

      Map<String, List<String>> groupedData = {};
      data.forEach((ingredient, category) {
        if (!groupedData.containsKey(category)) {
          groupedData[category] = [];
        }
        groupedData[category]!.add(ingredient);
      });

      setState(() {
        categorizedIngredients = groupedData;
      });
    } catch (e) {
      print("Error loading ingredients: $e");
    }
  }


  void _startLoading() {
    setState(() {
      _isLoading = true;
      _progress = 0.0;
    });

    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (_progress >= 1.0) {
        timer.cancel();
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _progress += 0.1;
        });
      }
    });
  }

  void showIngredientsPopup(String category) {
    final ingredients = categorizedIngredients[category] ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$category Ingredients'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: ListView.builder(
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(ingredients[index]),
                  leading: const Icon(Icons.food_bank, color: Colors.green),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading ? buildLoadingScreen() : buildMainScreen(),
      ),
    );
  }

  Widget buildMainScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 4.0),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.builder(
              itemCount: categorizedIngredients.keys.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 18,
                childAspectRatio: 3,
              ),
              itemBuilder: (context, index) {
                String category = categorizedIngredients.keys.elementAt(index);
                return GestureDetector(
                  onTap: () => showIngredientsPopup(category),
                  child: _buildCategoryButton(category),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        _buildSubmitButton(),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildCategoryButton(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          category,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildLoadingScreen() {
    return Column(
      children: [
        const SizedBox(height: 150),
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
        LinearProgressIndicator(
          value: _progress,
          backgroundColor: Colors.grey.shade300,
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF2B33D)),
        ),
        const SizedBox(height: 10),
        Text(
          '${(_progress * 100).toInt()}%',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFF2B33D)),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton(
        onPressed: _startLoading,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFBF7E04),
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Submit',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'What is in your fridge today?',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }
}
