class LotModel {
  final int lotID;
  final String lotLocationUUID;
  int detailLotID;
  final int detailLocationID;
  final String detailLocationName;
  final int wayType;
  final int locationID;
  final int sideID;
  final bool isBooking;
  int isAvailable;
  final Function onChange;

  LotModel({
    this.lotID,
    this.lotLocationUUID,
    this.detailLotID,
    this.detailLocationID,
    this.detailLocationName,
    this.wayType,
    this.locationID,
    this.sideID,
    this.isBooking,
    this.isAvailable,
    this.onChange,
  });

  factory LotModel.fromJson(Map<String, dynamic> parsedJson) {
    return LotModel(
      lotID: parsedJson['lot_id'],
      lotLocationUUID: parsedJson['lot_location_uuid'],
      detailLotID: parsedJson['detail_lot_id'],
      detailLocationID: parsedJson['detail_location_id'],
      detailLocationName: parsedJson['detail_location_name'],
      wayType: parsedJson['way_type'],
      locationID: parsedJson['location_id'],
      sideID: parsedJson['side_id'],
      isBooking: parsedJson['is_booking'],
      isAvailable: parsedJson['is_available'],
    );
  }
}
