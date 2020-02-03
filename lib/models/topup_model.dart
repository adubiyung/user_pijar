class TopupModel {
  final String idTopup;
  final String nameTopup;
  final String descTopup;
  final String imgTopup;
  final String idStep;
  final String noStep;
  final String nameStep;
  final Function onChange;

  const TopupModel({
    this.idTopup,
    this.nameTopup,
    this.descTopup,
    this.imgTopup,
    this.idStep,
    this.noStep,
    this.nameStep,
    this.onChange,
  });
}

List<TopupModel> topupList = [
  const TopupModel(
    idTopup: "1",
    nameTopup: "Isi Saldo Melalui Himbara",
    descTopup:
        "Isi saldo bebas biaya admin dari Bank BTN, Bank BNI, Bank Mandiri, dan Bank BRI",
  ),
  const TopupModel(
    idTopup: "1",
    nameTopup: "Transfer Bank",
    descTopup:
        "Isi saldo melalui ATM, SMS Banking, Mobile Banking, Internet Banking melalui bank lainnya",
  ),
  const TopupModel(
    idTopup: "1",
    nameTopup: "Kartu Debit",
    descTopup:
        "Isi saldo kapanpun, dimanapun dengan kartu debit, langsung di aplikasi",
  ),
  const TopupModel(
    idTopup: "1",
    nameTopup: "Merchant & Mitra LinkAja",
    descTopup:
        "Kunjungi merchant & mitra LinkAja terdekat untuk pengisian saldo",
  ),
  const TopupModel(
    idTopup: "1",
    nameTopup: "GraPARI",
    descTopup: "Kunjungi GraPARI untuk pengisian saldo",
  ),
];

List<TopupModel> listStep = [
  const TopupModel(
    idStep: "1",
    noStep: "1",
    nameStep: "asasasad",
  ),
];
