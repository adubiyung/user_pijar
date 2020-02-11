import 'package:flutter/material.dart';
import 'package:user_pijar/models/getTransaction.dart';
import 'package:user_pijar/views/pages/checkin_ticket_page.dart';
import 'package:user_pijar/views/pages/checkout_ticket_page.dart';
import 'package:user_pijar/views/pages/detail_ticket_page.dart';
import 'package:user_pijar/views/widget/color_library.dart';

class TicketRow extends StatelessWidget {
  final DataTransaction model;
  final int selectedType;
  TicketRow(this.model, this.selectedType);

  @override
  Widget build(BuildContext context) {
    _navigateDetailTicket(BuildContext context) async {
      if (model.transactionStatus < 4) {
        if(selectedType == 1) {
          await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => new CheckoutTicketPage(
              modelTrans: model,
            ),
          ),
        );
        } else {
          await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => new CheckinTicketPage(
              modelTrans: model,
            ),
          ),
        );
        }
      } else {
        //history page
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => new DetailTicketPage(
              modelTrans: model, selectedType: selectedType,
            ),
            fullscreenDialog: true,
          ),
        );
      }
    }

    final _ticketDot = new ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 30.0),
      leading: new Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: ColorLibrary.backgroundDark),
      ),
      trailing: new Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorLibrary.backgroundDark,
          boxShadow: <BoxShadow>[new BoxShadow(color: Colors.transparent)],
        ),
      ),
      onTap: () {
        _navigateDetailTicket(context);
      },
    );

    final _ticketThumbnailIcon = new ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 22.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
          border: Border(
              right:
                  BorderSide(width: 2.0, color: ColorLibrary.backgroundDark)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.drive_eta,
              color: Colors.white,
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              model.vehicle.vehicleLicense,
              style: TextStyle(color: Colors.white, fontSize: 10),
            )
          ],
        ),
      ),
    );

    final baseTextStyle = const TextStyle(fontFamily: 'Work Sans');
    final regularTextStyle = baseTextStyle.copyWith(
        color: const Color(0xffb6b2df),
        fontSize: 9.0,
        fontWeight: FontWeight.w400);
    final subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 10.0);
    final headerTextStyle = baseTextStyle.copyWith(
        color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w600);

    final _ticketCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(90.0, 16.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(model.location.locationName, style: headerTextStyle),
          new Container(height: 10.0),
          new Text(
              model.location.locationAddress +
                  " " +
                  model.location.locationCity,
              style: subHeaderTextStyle,
              overflow: TextOverflow.ellipsis,),
          new Container(
              margin: new EdgeInsets.symmetric(vertical: 8.0),
              height: 2.0,
              width: MediaQuery.of(context).size.width - 170.0,
              color: new Color(0xff00c6ff)),
          new Row(
            children: <Widget>[
              Container(
                width: 8.0,
              ),
              Expanded(
                child: (model.transactionStatus == 1)
                    ? Text(
                        model.startTime.substring(0, 10),
                        style: regularTextStyle,
                      )
                    : Text(
                        model.checkinTime.substring(0, 10),
                        style: regularTextStyle,
                      ),
              ),
              Container(
                width: 8.0,
              ),
              Expanded(
                child: Text(
                  model.featureType.featureName,
                  style: regularTextStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final _ticketCard = new Container(
      child: _ticketCardContent,
      height: 124.0,
      margin: new EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: new BoxDecoration(
        color: ColorLibrary.primary,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.transparent,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    return new Container(
        height: 120.0,
        margin: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 14.0,
        ),
        child: new Stack(
          children: <Widget>[_ticketCard, _ticketThumbnailIcon, _ticketDot],
        ));
  }
}
