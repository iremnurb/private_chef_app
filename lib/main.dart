import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diyet/ui/cubit/ana_sayfa_cubit.dart';

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


