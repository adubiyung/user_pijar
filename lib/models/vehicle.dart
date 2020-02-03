class Vehicle {
  final int vehicleID;
  final int userID;
  final int vehicleTypeID;
  final VehicleModel vehicleModelID;
  final VehicleBrand vehicleBrandID;
  final String vehicleName;
  final int vehicleYear;
  final String vehicleLicense;
  final bool vehicleStatus;

  Vehicle({
      this.vehicleID,
      this.userID,
      this.vehicleTypeID,
      this.vehicleModelID,
      this.vehicleBrandID,
      this.vehicleName,
      this.vehicleYear,
      this.vehicleLicense,
      this.vehicleStatus
  });

  factory Vehicle.fromJson(Map<String, dynamic> parsedJson) {
    return Vehicle(
      vehicleID: parsedJson['vehicle_id'],
      userID: parsedJson['user_id'],
      vehicleTypeID: parsedJson['vehicle_type_id'],
      vehicleModelID: VehicleModel.fromJson(parsedJson['vehicle_model_id']),
      vehicleBrandID: VehicleBrand.fromJson(parsedJson['vehicle_brand_id']),
      vehicleName: parsedJson['vehicle_name'],
      vehicleYear: parsedJson['vehicle_year'],
      vehicleLicense: parsedJson['vehicle_license'],
      vehicleStatus: parsedJson['vehicle_status'],
    );
  }
}

class VehicleBrand {
  final int vehicleBrandID;
  final String vehicleBrandName;

  VehicleBrand({this.vehicleBrandID, this.vehicleBrandName});

  factory VehicleBrand.fromJson(Map<String, dynamic> json) {
    return VehicleBrand(
      vehicleBrandID: json['vehicle_brand_id'],
      vehicleBrandName: json['vehicle_brand_name'],
    );
  }
}

class VehicleModel {
  final int vehicleModelID;
  final String vehicleModelName;

  VehicleModel({this.vehicleModelID, this.vehicleModelName});

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      vehicleModelID: json['vehicle_model_id'],
      vehicleModelName: json['vehicle_model_name'],
    );
  }
}
