import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DialogPaymentQR extends StatefulWidget {
  final String methodCode;
  final String userID;
  final String transCode;

  const DialogPaymentQR(this.methodCode, this.userID, this.transCode);

  @override
  _DialogPaymentQRState createState() => _DialogPaymentQRState();
}

class _DialogPaymentQRState extends State<DialogPaymentQR> {
  @override
  Widget build(BuildContext context) {
    int nol = 0;
    String nolUser = '';
    String nolTrans = '';

    for (var i = widget.userID.length; i < 7; i++) {
      nolUser += nol.toString();
    }

    for (var i = widget.transCode.length; i < 7; i++) {
      nolTrans += nol.toString();
    }

    Widget _qrcode = new Container(
      width: 230.0,
      height: 230.0,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: QrImage(
          data:
              "${widget.methodCode}${nolUser + widget.userID}${nolTrans + widget.transCode}",
          version: QrVersions.auto,
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.all(10.0),
      child: new Column(
        children: <Widget>[
          _qrcode,
          SizedBox(height: 30.0),
          Text(
            (widget.methodCode == '2')
                ? "Your Check-In Ticket"
                : "Your Check-Out Ticket",
            style:
                TextStyle(fontFamily: 'Work Sans', fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10.0),
          Text(
            (widget.methodCode == '2')
                ? "Show this code to the Warden to make payment and check in"
                : "Show this code to the Warden to make payment and check out",
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 10),
          )
        ],
      ),
    );
  }
}
