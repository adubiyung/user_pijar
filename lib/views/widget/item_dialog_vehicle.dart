import 'package:flutter/material.dart';
import 'package:user_pijar/models/vehicle.dart';

class ItemDialogVehicle extends StatelessWidget {
  final Vehicle _vehicle;
  final bool isSelected;
  ItemDialogVehicle(this._vehicle, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new ListTile(
        leading: new Container(
          height: 50.0,
          padding: EdgeInsets.only(right: 12.0),
          child: Center(
            child: (_vehicle.vehicleTypeID == 1)
                ? Icon(Icons.directions_car)
                : Icon(Icons.directions_bike),
          ),
        ),
        title: new Column(
          children: <Widget>[
            Text(_vehicle.vehicleLicense),
            Text(_vehicle.vehicleBrandID.vehicleBrandName +
                " " +
                _vehicle.vehicleModelID.vehicleModelName)
          ],
        ),
        selected: isSelected,
      ),
    );
  }
}
