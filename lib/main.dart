import 'package:diyet/ui/cubit/diyet_listem_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/favori_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/recipe_cubit.dart';
import 'package:diyet/ui/views/diyet/ogun_detay_sayfa.dart';
import 'package:diyet/ui/views/home/ana_sayfa.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repo/repository.dart';


import 'package:diyet/ui/cubit/ana_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/login_cubit.dart';
import 'package:diyet/ui/cubit/profile_cubit.dart';
import 'package:diyet/ui/cubit/sign_up_cubit.dart';
import 'package:diyet/ui/cubit/veri_alma_gun_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/veri_alma_hareket_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/veri_alma_kilo_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/veri_alma_timig_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/ogun_detay_cubit.dart';


//  İlk Sayfa
import 'package:diyet/ui/views/login/ilk_sayfa.dart';

import 'data/services/notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AnaSayfaCubit()),
        BlocProvider(create: (_) => VeriAlmaKiloSayfaCubit(hedefKilo: 70)),
        BlocProvider(create: (_) => VeriAlmaGunSayfaCubit()),
        BlocProvider(create: (_) => VeriAlmaHareketSayfaCubit(aktivite: 'moderate')),
        BlocProvider(create: (_) => VeriAlmaTimingSayfaCubit()),
        BlocProvider(create: (_) => SignUpCubit(UserRepository())),
        BlocProvider(create: (_) => LoginCubit(UserRepository())),
        BlocProvider(create: (_) => ProfileCubit(UserRepository())),
        BlocProvider(create: (_) => DiyetListemSayfaCubit(DietRepository())),
        BlocProvider(create: (_) => OgunDetayCubit(DietRepository())),
        BlocProvider(create: (_) => ProfileCubit(UserRepository())),
        BlocProvider(create: (_) => FavoriSayfaCubit(FavoriteRepository())),
        BlocProvider(create: (_) => RecipeCubit(UserRepository())),


      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          '/': (context) => IlkSayfa(), // Your home page
          '/ogun_detay': (context) {
            final String? payload = ModalRoute.of(context)?.settings.arguments as String?;
            final int mealId = int.tryParse(payload ?? '0') ?? 0;
            return OgunDetaySayfa(mealId: mealId);
          },
        },
        theme: ThemeData(
          colorScheme: const ColorScheme.light(onPrimary: Colors.white),
          useMaterial3: true,
        ),





      ),
    );
  }
}
