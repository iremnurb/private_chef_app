
import 'package:diyet/ui/views/profile/profile_page.dart';
import 'package:flutter/material.dart';

import 'favori_sayfa.dart';
import 'home/ana_sayfa.dart';


class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 1; // Başlangıçta seçili olan index (Ana Sayfa)

  final List<Widget> _pages = [
    // Ana Sayfa Widget'ı
     FavoriSayfa(),
     AnaSayfa(),// Favoriler Sayfası Widget'ı
     ProfilePage(), // Profil Sayfası Widget'ı
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Seçilen sayfayı göster
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25,
        backgroundColor:Colors.grey,
        //showSelectedLabels: false,
        unselectedFontSize: 12,
        selectedFontSize: 14,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black, // Seçilen öğenin rengi
        unselectedItemColor: Colors.white, // Seçilmeyen öğelerin rengi
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Seçilen öğeyi değiştir
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoriler",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Ana Sayfa",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),

        ],
      ),
    );
  }
}
