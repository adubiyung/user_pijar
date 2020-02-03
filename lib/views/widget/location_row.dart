import 'package:flutter/material.dart';
import 'package:user_pijar/models/Location.dart';
import 'package:user_pijar/views/pages/booking_page.dart';
import 'package:user_pijar/views/widget/color_library.dart';

class LocationRow extends StatelessWidget {
  final Location _location;
  LocationRow(this._location);

  @override
  Widget build(BuildContext context) {
    final _mobilLotIcon = new Container(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.drive_eta,
            size: 13.0,
            color: ColorLibrary.thinFontWhite,
          ),
          SizedBox(width: 6.0,),
          Text(
            _location.lotCar.toString(),
            style: TextStyle(
                fontSize: 10.0,
                color: ColorLibrary.thinFontWhite,
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );

    final _motorLotIcon = new Container(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.motorcycle,
            size: 13.0,
            color: ColorLibrary.thinFontWhite,
          ),
          SizedBox(
            width: 6.0,
          ),
          Text(
            _location.lotMotor.toString(),
            style: TextStyle(
                fontSize: 10.0,
                color: ColorLibrary.thinFontWhite,
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );

    final _locationRangeIcon = new Container(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.near_me,
            size: 13.0,
            color: ColorLibrary.thinFontWhite,
          ),
          Text(
            "  " + "0.6 km",
            style: TextStyle(
                fontSize: 10.0,
                color: ColorLibrary.thinFontWhite,
                fontFamily: 'Work Sans'),
          ),
        ],
      ),
    );

    final _ratingIcon = new Container(
      child: Row(
        children: <Widget>[
          Icon(
                Icons.star,
                size: 12.0,
                color: ColorLibrary.thinFontWhite,
              ),
              Text(
                " 4.8" /**rating */,
                style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w300,
                color: ColorLibrary.thinFontWhite),
              ),
        ],
      ),
    );

    final _locationCardContent = new Container(
      margin: EdgeInsets.fromLTRB(90.0, 6.0, 60.0, 6.0),
      constraints: BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 4.0,
          ),
          Text(
            _location.locationName,
            style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w500,
                color: ColorLibrary.regularFontWhite),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            _location.locationCity,
            style: TextStyle(
                fontSize: 10.0,
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w500,
                color: ColorLibrary.regularFontWhite),
          ),
          SizedBox(
            height: 6.0,
          ),
          Row(
            children: <Widget>[
              _mobilLotIcon,
              Container(
                width: 15.0,
                child: Icon(
                  Icons.lens,
                  size: 3.0,
                  color: ColorLibrary.thinFontWhite,
                ),
              ),
              _motorLotIcon
            ],
          ),
          SizedBox(
            height: 6.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _ratingIcon,
              _locationRangeIcon,
            ],
          ),
        ],
      ),
    );

    final _locationCard = new Container(
      child: _locationCardContent,
      height: 100.0,
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        color: ColorLibrary.primary,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.transparent,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0)),
        ],
      ),
    );

    final _locationCardIcon = new ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0),
      leading: Container(
        padding: EdgeInsets.only(right: 15.0),
        decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 1.0, color: Colors.grey)),
        ),
        child: Icon(Icons.local_parking,
        color: ColorLibrary.thinFontWhite,),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 15.0,
        color: ColorLibrary.thinFontWhite,
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => new BookingPage(model: _location)));
      },
    );

    Widget _compileWidget = Container(
      height: 100.0,
      margin: const EdgeInsets.symmetric(
        vertical: 6.0,
        horizontal: 10.0,
      ),
      child: new Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            _locationCard,
            _locationCardIcon,
          ],
        ),
      ),
    );

    return _compileWidget;
  }
}
