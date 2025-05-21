import 'package:diyet/ui/cubit/diyet_listem_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/favori_sayfa_cubit.dart';
import 'package:diyet/ui/cubit/recipe_cubit.dart';
import 'package:diyet/ui/views/diyet/ogun_detay_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
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
import 'package:diyet/ui/views/login/ilk_sayfa.dart';
import 'data/services/notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  final userRepository = UserRepository(); // UserRepository instance’ını burada oluştur
  runApp(MyApp(userRepository: userRepository));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  const MyApp({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserRepository>.value(value: userRepository),
        BlocProvider(create: (_) => AnaSayfaCubit()),
        BlocProvider(create: (_) => VeriAlmaKiloSayfaCubit(hedefKilo: 70)),
        BlocProvider(create: (_) => VeriAlmaGunSayfaCubit()),
        BlocProvider(create: (_) => VeriAlmaHareketSayfaCubit(aktivite: 'moderate')),
        BlocProvider(create: (_) => VeriAlmaTimingSayfaCubit()),
        BlocProvider(create: (_) => SignUpCubit(userRepository)),
        BlocProvider(create: (_) => LoginCubit(userRepository)),
        BlocProvider(create: (_) => ProfileCubit(userRepository)),
        BlocProvider(create: (_) => DiyetListemSayfaCubit(DietRepository())),
        BlocProvider(create: (_) => OgunDetayCubit(DietRepository())),
        BlocProvider(create: (_) => FavoriSayfaCubit(FavoriteRepository())),
        BlocProvider(create: (_) => RecipeCubit(userRepository)),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) => const IlkSayfa(),
        ),
        onGenerateRoute: (settings) {
          if (settings.name == '/ogun_detay') {
            final mealId = settings.arguments as int? ?? 0;
            return MaterialPageRoute(
              builder: (context) => OgunDetaySayfa(mealId: mealId),
            );
          }
          return null;
        },
        theme: ThemeData(
          colorScheme: const ColorScheme.light(onPrimary: Colors.white),
          useMaterial3: true,
        ),
      ),
    );
  }
}