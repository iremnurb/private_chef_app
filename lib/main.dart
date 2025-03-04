import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diyet/ui/cubit/ana_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/veri_alma_kilo_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/veri_alma_gun_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/veri_alma_hareket_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/veri_alma_timig_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/diyet_listem_sayfa_cubit.dart';
import 'package:diyet/data/repo/repository.dart';

import 'package:diyet/ui/views/bottom_navigation.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      //kullandığımız cubitleri altta ekliyoruz.
      providers: [
        BlocProvider(create: (context) => AnaSayfaCubit()),
       // BlocProvider(create: (context) => DiyetListemSayfaCubit(Repository())),
        BlocProvider(create: (context) => VeriAlmaKiloSayfaCubit()),
        BlocProvider(create: (context) => VeriAlmaGunSayfaCubit()),
        BlocProvider(create: (context) => VeriAlmaHareketSayfaCubit()),
        BlocProvider(create: (context) => VeriAlmaTimigSayfaCubit()),


      ],

      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.light(onPrimary: Colors.white),
          useMaterial3: true,
        ),
        home:  BottomNavigation(),
      ),
    );
  }
}


