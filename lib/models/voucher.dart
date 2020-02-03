class Voucher {
  final int voucherID;
  final String voucherCode;
  final String voucherName;
  final String voucherDesc;
  final int voucherPercent;
  final int voucherMax;
  final String validDate;

  Voucher({
    this.voucherID,
    this.voucherCode,
    this.voucherName,
    this.voucherDesc,
    this.voucherPercent,
    this.voucherMax,
    this.validDate,
  });

  factory Voucher.fromJson(Map<String, dynamic> parsedJson) {
    return Voucher(
      voucherID: parsedJson['voucher_id'],
      voucherCode: parsedJson['voucher_code'],
      voucherName: parsedJson['voucher_name'],
      voucherDesc: parsedJson['voucher_description'],
      voucherPercent: parsedJson['voucher_percent'],
      voucherMax: parsedJson['voucher_max_nominal'],
      validDate: parsedJson['voucher_valid_date'],
    );
  }
}
