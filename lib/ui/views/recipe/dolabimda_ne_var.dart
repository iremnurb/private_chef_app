import 'dart:async';

import 'package:flutter/material.dart';

class DolabimdaNeVar extends StatefulWidget {
  @override
  _DolabimdaNeVarState createState() => _DolabimdaNeVarState();
}

class _DolabimdaNeVarState extends State<DolabimdaNeVar> {
  bool _isLoading = false;
  double _progress = 0.0;

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
        // Navigate to the next screen or process data
      } else {
        setState(() {
          _progress += 0.1;
        });
      }
    });
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
        SizedBox(height: 4.0),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 18,
              childAspectRatio: 3,
              children: [
                _buildCategoryButton('Vegetables', 'vegetables.png'),
                _buildCategoryButton('Fruits', 'fruits.png'),
                _buildCategoryButton('Meat & Poultry', 'meatandpoultry.png'),
                _buildCategoryButton('Dairy & Eggs', 'dairyandeggs.png'),
                _buildCategoryButton('Organ Meats & Offal', 'organmeatsandoffal.png'),
                _buildCategoryButton('Seafood', 'seafood.png'),
                _buildCategoryButton('Grains & Pasta', 'grainandpasta.png'),
                _buildCategoryButton('Bread & Baked Goods', 'breadandbakedgoods.png'),
                _buildCategoryButton('Nuts & Seeds', 'nutsandseeds.png'),
                _buildCategoryButton('Herbs & Spices', 'herbsandspices.png'),
                _buildCategoryButton('Canned & Jarred', 'cannedandjarred.png'),
                _buildCategoryButton('Oils & Sauces', 'oilsandsauces.png'),
                _buildCategoryButton('Sweets & Snacks', 'sweetsandsnacks.png'),
                _buildCategoryButton('Beverages', 'bevereges.png'),
                _buildCategoryButton('Additives & Preservatives', 'additivitesandpreservatives.png'),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.0),
        _buildSubmitButton(),
        SizedBox(height: 16.0),
      ],
    );
  }

  /*Widget _buildHeader() {
    return SizedBox(
      height: 110,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Image.asset(
            'assets/images/Rectangle.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 10,
            left: 44,
            child: const Text(
              'What is in your  \n                fridge today ?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //Geri Butonu
          Positioned(child:
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 14,top: 6),
              child: GestureDetector(
                onTap: () => Navigator.pop,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2), // Dış çerçeve rengi
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.black, size:16,weight: 2,),
                ),
              ),
            ),
          ),)
        ],
      ),
    );
  }*/
  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Image.asset(
            'assets/images/Rectangle.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 10,
            left: 44,
            child: const Text(
              'What is in your  \n                fridge today ?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Geri Butonu
          Positioned(
            top: 8,
            left: 14,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 16,
                  weight: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category, String iconAsset) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/$iconAsset',
            width: 32,
            height: 32,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, color: Colors.red);
            },
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              category,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
  Widget buildLoadingScreen() {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
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
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Choose the ingredients you have for cooking and \n select your recipe..',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF2B33D)),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${(_progress * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF2B33D),
          ),
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
          backgroundColor: Color(0xFFBF7E04),
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Submit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}