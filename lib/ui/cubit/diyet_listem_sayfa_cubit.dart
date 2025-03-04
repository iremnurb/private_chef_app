import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diyet/data/entity/kisi_bilgisi.dart';
import 'package:diyet/data/repo/repository.dart';
import 'package:diyet/ui/views/diyet/veri_alma_kilo_sayfa.dart';

/*class DietState {
  final int days;
  final int dailyCalories;
  final bool loading;

  DietState({this.days = 0, this.dailyCalories = 0, this.loading = true});
}

class DiyetListemSayfaCubit extends Cubit<DietState> {
  final Repository repository;

  DiyetListemSayfaCubit(this.repository) : super(DietState());

  void loadDietPlan({
    required String aktiviteSeviyesi,
    required double hedefKilo,
    required int yemekSayisi,
  }) {
    emit(DietState(loading: true));

    // Kullanıcının sabit şimdilik belirlenen bilgileri
    double kilo = 60;
    double boy = 176;
    int yas = 25;
    String cinsiyet = "male";

    KisiBilgisi kisi = KisiBilgisi(
      kilo: kilo,
      boy: boy,
      yas: yas,
      cinsiyet: cinsiyet,
      aktiviteSeviyesi: aktiviteSeviyesi,
      hedefKilo: hedefKilo,
      yemekSayisi: yemekSayisi,
    );

    double tdee = repository.calculateTDEE(kisi);
    int days = repository.calculateDietDays(kisi);


    // Gün sayısı çok büyükse, sınır koy
    if (days > 365) {
      days = 365; // Maksimum 1 yıl sınırı koy
    }

    emit(DietState(days: days, dailyCalories: (tdee - 700).round(), loading: false));
  }

}
*/