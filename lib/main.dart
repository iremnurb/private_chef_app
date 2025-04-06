import 'package:diyet/ui/cubit/ana_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/login_cubit.dart';
import 'package:diyet/ui/cubit/profile_cubit.dart';
import 'package:diyet/ui/cubit/sign_up_cubit.dart';
import 'package:diyet/ui/cubit/veri_alma_gun_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/veri_alma_hareket_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/veri_alma_kilo_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/veri_alma_timig_sayfa_cubit.dart';
import 'package:diyet/ui/views/login/ilk_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repo/repository.dart';




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
        BlocProvider(create: (context) => SignUpCubit(UserRepository())),
        BlocProvider(create: (context) => LoginCubit(UserRepository()) ),
        BlocProvider(create: (context) => ProfileCubit(UserRepository())),
      ],

      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.light(onPrimary: Colors.white),
          useMaterial3: true,
        ),
        home: IlkSayfa(),
        //BottomNavigation(),
      ),
    );
  }
}


