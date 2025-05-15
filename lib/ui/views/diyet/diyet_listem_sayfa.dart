import 'package:diyet/ui/views/diyet/diyet_intro_sayfa.dart';
import 'package:diyet/ui/views/diyet/veri_alma_kilo_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repo/repository.dart';
import '../../cubit/diyet_listem_sayfa_cubit.dart';
import 'package:diyet/ui/views/diyet/gun_detay_sayfa.dart';
import 'package:diyet/ui/views/home/ana_sayfa.dart';

class DiyetListem extends StatelessWidget {
  final int userId;

  const DiyetListem({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiyetListemSayfaCubit(DietRepository())..fetchDietList(userId),
      child: DiyetListemUI(userId: userId),
    );
  }
}

class DiyetListemUI extends StatelessWidget {
  final int userId;

  const DiyetListemUI({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.4),
                  BlendMode.srcATop,
                ),
                child: Container(
                  height: 230,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/diyet_list.jpg'),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: const Text(
                  "Diet List",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8A9B0F),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => AnaSayfa()),
                          (route) => false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Expanded(
            child: BlocBuilder<DiyetListemSayfaCubit, DiyetListemSayfaState>(
              builder: (context, state) {
                if (state.status == DiyetListemSayfaStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == DiyetListemSayfaStatus.success) {
                  final dietList = state.dietList;

                  if (dietList.isEmpty) {
                    // Diyet süresi tamamlanmış olabilir
                    Future.microtask(() {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Diyet Tamamlandı"),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Diyet süreniz sona erdi. Yeni bir diyet listesi oluşturmak ister misiniz?"),
                                SizedBox(height: 12),
                                Text(
                                  "Lütfen profilinizdeki kilonuzu güncellemeyi unutmayın.",
                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("İptal"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DiyetIntroSayfa(),
                                    ),
                                  );
                                },
                                child: const Text("Yeni Diyet Oluştur"),
                              ),
                            ],
                          );
                        },
                      );
                    });

                    return const Center(child: Text("Diyet listesi bulunamadı."));
                  }

                  return ListView.builder(
                    itemCount: dietList.length,
                    itemBuilder: (context, index) {
                      final gun = dietList[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GunDetaySayfa(
                                gunNo: gun.day,
                                userId: userId,
                                meals: gun.meals ?? {},
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F4FB),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Day ${gun.day}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${gun.dailyCalories} kcal",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.chevron_right, color: Color(0xFF8A9B0F)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state.status == DiyetListemSayfaStatus.failure) {
                  return Center(child: Text('Error: ${state.errorMessage}'));
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
