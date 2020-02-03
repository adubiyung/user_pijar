class Location {
  final int locationID;
  final String locationName;
  final String locationAddress;
  final String locationDistrict;
  final String locationCity;
  final String locationProvince;
  final int locationArea;
  final String locationLatitude;
  final String locationLongitude;
  final int lotCar;
  final int lotMotor;

  Location({
    this.locationID,
    this.locationName,
    this.locationAddress,
    this.locationDistrict,
    this.locationCity,
    this.locationProvince,
    this.locationArea,
    this.locationLatitude,
    this.locationLongitude,
    this.lotCar,
    this.lotMotor,
  });

  factory Location.fromJson(Map<String, dynamic> parsedJson) {
    return Location(
      locationID: parsedJson['location_id'],
      locationName: parsedJson['location_name'],
      locationAddress: parsedJson['location_address'],
      locationDistrict: parsedJson['district_name'],
      locationCity: parsedJson['city_name'],
      locationProvince: parsedJson['province_name'],
      locationArea: parsedJson['area_id'],
      locationLatitude: parsedJson['location_latitude'],
      locationLongitude: parsedJson['location_longitude'],
      lotCar: parsedJson['max_lot_mobil'],
      lotMotor: parsedJson['max_lot_motor'],
    );
  }
}

class LocationDetail {
  final int locationID;
  final int detailLocID;
  final String detailLocName;
  final int wayType;
  final int totalSide;

  LocationDetail({
    this.locationID,
    this.detailLocID,
    this.detailLocName,
    this.wayType,
    this.totalSide,
  });

  factory LocationDetail.fromJson(Map<String, dynamic> parsedJson) {
    return LocationDetail(
      locationID: parsedJson['location_id'],
      detailLocID: parsedJson['detail_location_id'],
      detailLocName: parsedJson['detail_location_name'],
      wayType: parsedJson['way_type'],
      totalSide: parsedJson['total_side'],
    );
  }
}

class LocationFeature {
  final int featureID;
  final int featureTypeID;
  final int locationID;
  final int vehicleTypeID;
  final int startPrice;
  final int nextPrice;

  LocationFeature({
    this.featureID,
    this.featureTypeID,
    this.locationID,
    this.vehicleTypeID,
    this.startPrice,
    this.nextPrice,
  });

  factory LocationFeature.fromJson(Map<String, dynamic> parsedJson) {
    return LocationFeature(
      featureID: parsedJson['feature_id'],
      featureTypeID: parsedJson['feature_type_id'],
      locationID: parsedJson['location_id'],
      vehicleTypeID: parsedJson['vehicle_type_id'],
      startPrice: parsedJson['feature_startprice'],
      nextPrice: parsedJson['feature_nextprice'],
    );
  }
}

class LocationLot {
  final int lotID;
  final String lotLocationUUID;
  int detailLotID;
  final int detailLocationID;
  final String detailLocationName;
  final int wayType;
  final int locationID;
  final int sideID;
  final bool isBooking;
  bool isAvailable;
  final Function onChange;

  LocationLot({
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

  factory LocationLot.fromJson(Map<String, dynamic> parsedJson) {
    return LocationLot(
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
