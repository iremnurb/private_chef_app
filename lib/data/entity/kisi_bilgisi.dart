class KisiBilgisi {
  final double kilo;
  final double boy;
  final int yas;
  final String cinsiyet;
  final String aktiviteSeviyesi;
  final double hedefKilo;
  final int yemekSayisi;

  KisiBilgisi({
    required this.kilo,
    required this.boy,
    required this.yas,
    required this.cinsiyet,
    required this.aktiviteSeviyesi,
    required this.hedefKilo,
    required this.yemekSayisi,
  });

  KisiBilgisi copyWith({
    double? kilo,
    double? boy,
    int? yas,
    String? cinsiyet,
    String? aktiviteSeviyesi,
    double? hedefKilo,
    int? yemekSayisi,
  }) {
    return KisiBilgisi(
      kilo: kilo ?? this.kilo,
      boy: boy ?? this.boy,
      yas: yas ?? this.yas,
      cinsiyet: cinsiyet ?? this.cinsiyet,
      aktiviteSeviyesi: aktiviteSeviyesi ?? this.aktiviteSeviyesi,
      hedefKilo: hedefKilo ?? this.hedefKilo,
      yemekSayisi: yemekSayisi ?? this.yemekSayisi,
    );
  }
}
