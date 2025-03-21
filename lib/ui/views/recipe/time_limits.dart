import 'dart:async';

import 'package:flutter/material.dart';

class TimeLimits extends StatefulWidget {
  @override
  _TimeLimitsState createState() => _TimeLimitsState();
}

class _TimeLimitsState extends State<TimeLimits> {
  int _hours = 0;
  int _minutes = 0;
  bool _isLoading = false;
  double _progress = 0.0;

  void _increaseHours() {
    setState(() {
      _hours = (_hours + 1) % 24;
    });
  }

  void _decreaseHours() {
    setState(() {
      _hours = (_hours - 1 + 24) % 24;
    });
  }

  void _increaseMinutes() {
    setState(() {
      _minutes = (_minutes + 1) % 60;
    });
  }

  void _decreaseMinutes() {
    setState(() {
      _minutes = (_minutes - 1 + 60) % 60;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading ? buildLoadingScreen() : buildMainScreen(),
      ),
    );
  }

  @override
  Widget buildMainScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
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
            const SizedBox(height: 50),
            _buildHeaderText(),
            const SizedBox(height: 40),
            _buildClockImage(),
            const SizedBox(height: 40),
            _buildTimeBox(),
            const SizedBox(height: 160),
            _buildSearchButton(),
          ],
        ),
      ),
    );
  }


  Widget _buildHeaderText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Enter your ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'time limit',
              style: TextStyle(
                color: Color(0xFFC9A18A),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClockImage() {
    return Image.asset(
      'assets/images/Clock.png',
      width: 120,
      height: 120,
      fit: BoxFit.contain,
    );
  }

  Widget _buildTimeBox() {
    return GestureDetector(
      onTap: () => _showTimePicker(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '${_hours.toString().padLeft(2, '0')} : ${_minutes.toString().padLeft(2, '0')}',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showTimePicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Select Time Limit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_up),
                        onPressed: () {
                          setDialogState(() => _increaseHours());
                        },
                      ),
                      Text(
                        _hours.toString().padLeft(2, '0'),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_down),
                        onPressed: () {
                          setDialogState(() => _decreaseHours());
                        },
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Text( ":",
                    style:  TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_up),
                        onPressed: () {
                          setDialogState(() => _increaseMinutes());
                        },
                      ),
                      Text(
                        _minutes.toString().padLeft(2, '0'),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_down),
                        onPressed: () {
                          setDialogState(() => _decreaseMinutes());
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  child: const Text('OK', style: TextStyle(color: Color(0xFFBF7E04)),),
                ),
              ],
            );
          },
        );
      },
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
          'Enter the time you have for cooking and choose  \n your recipe..',
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

  Widget _buildSearchButton() {
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
          'Search',
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