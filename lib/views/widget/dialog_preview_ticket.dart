import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

import 'color_library.dart';

class DialogPreviewTicket extends StatefulWidget {
  final String transCode;
  final String locationName;
  final String locationAddress;
  final String locationCity;
  final String startTime;
  final String endTime;
  final int duration;
  final String voucherName;
  final int voucherNominal;
  final int parkingFare;
  final int totalBilling;

  const DialogPreviewTicket(
      {Key key,
      this.transCode,
      this.locationName,
      this.locationAddress,
      this.locationCity,
      this.startTime,
      this.endTime,
      this.duration,
      this.voucherName,
      this.voucherNominal,
      this.parkingFare,
      this.totalBilling})
      : super(key: key);

  @override
  _DialogPreviewTicketState createState() => _DialogPreviewTicketState();
}

class _DialogPreviewTicketState extends State<DialogPreviewTicket> {
  @override
  Widget build(BuildContext context) {
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: 12345678.9012345);
    MoneyFormatterOutput fo = fmf.output;

    Widget _locationContent = new Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.locationName,
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 18),
          ),
          Text(
            widget.locationAddress,
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 12),
          ),
          Text(
            widget.locationCity,
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 12),
          ),
        ],
      ),
    );

    List<String> splitIn = [];
    var datein = widget.startTime;
    print("nah ini " + datein);
    splitIn = datein.split(" ");
    String tglin = splitIn[0];
    String combineIn = splitIn[0] + " " + splitIn[1];
    var parseCombineIn = DateFormat("yyyy-MM-dd hh:mm:ss").parse(combineIn);
    var parseDateIn = DateFormat("yyyy-MM-dd").parse(tglin);
    final formatDateIn = DateFormat("EEE, MMM d").format(parseDateIn);

    String waktuIn = splitIn[1];
    var parseTimeIn = DateFormat("hh:mm:ss").parse(waktuIn);
    var formatTimeIn = DateFormat("hh:mm a").format(parseTimeIn);

    List<String> splitOut = [];
    var datetimeOut = widget.endTime;
    splitOut = datetimeOut.split(" ");
    String tglOut = splitOut[0];
    String combineOut = splitOut[0] + " " + splitOut[1];
    var parseCombineOut = DateFormat("yyyy-MM-dd H:m:s").parse(combineOut);
    var parseDateOut = DateFormat("yyyy-MM-dd").parse(tglOut);
    final formatDateOut = DateFormat("EEE, MMM d").format(parseDateOut);

    String waktuOut = splitOut[1];
    var parseTimeOut = DateFormat("h:m:s").parse(waktuOut);
    var formatTimeOut = DateFormat("hh:mm a").format(parseTimeOut);

    String convertDuration = (widget.duration/60).toString();
    String jam = convertDuration.split('.')[0];
    String menit = (widget.duration % 60).toString();
    String duration = "${jam}h ${menit}m";

    Widget _durationContent = new Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(20.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                formatDateIn.toString(),
                style: TextStyle(fontFamily: 'Work Sans', fontSize: 10),
              ),
              Text(
                formatTimeIn.toString(),
                style: TextStyle(fontFamily: 'Work Sans', fontSize: 15),
              ),
            ],
          ),
          new Center(
            child: Container(
              height: 25.0,
              width: 90.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(14.0),
                color: ColorLibrary.background,
                border: Border.all(color: ColorLibrary.backgroundDark),
              ),
              child: Center(
                child: Text(
                  "$duration",
                  style: TextStyle(
                      fontFamily: 'Work Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                formatDateOut.toString(),
                style: TextStyle(fontFamily: 'Work Sans', fontSize: 10),
              ),
              Text(
                formatTimeOut.toString(),
                style: TextStyle(fontFamily: 'Work Sans', fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );

    Widget _voucherContent = new Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          Icons.local_play,
          color: ColorLibrary.primary,
        ),
        title: Text(
          (widget.voucherName.isEmpty) ? " - " : widget.voucherName,
          style:
              TextStyle(fontFamily: 'Work Sans', color: ColorLibrary.primary),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              fmf
                  .copyWith(
                      amount: widget.voucherNominal.toDouble(),
                      symbol: 'Rp',
                      thousandSeparator: '.',
                      decimalSeparator: ',',
                      fractionDigits: 0)
                  .output
                  .symbolOnLeft,
              style: TextStyle(
                  fontFamily: 'Work Sans', color: ColorLibrary.primary),
            ),
          ],
        ),
      ),
    );

    Widget _paymentTypeContent = new Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      color: Colors.white,
      child: ListTile(
          leading: Icon(
            Icons.account_balance_wallet,
            color: ColorLibrary.primary,
          ),
          title: Text(
            "Link Aja",
            style:
                TextStyle(fontFamily: 'Work Sans', color: ColorLibrary.primary),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                fmf
                    .copyWith(
                        amount: widget.totalBilling.toDouble(),
                        symbol: 'Rp',
                        thousandSeparator: '.',
                        decimalSeparator: ',',
                        fractionDigits: 0)
                    .output
                    .symbolOnLeft,
                style: TextStyle(
                    fontFamily: 'Work Sans', color: ColorLibrary.primary),
              ),
              Icon(Icons.more_vert)
            ],
          )),
    );

    Widget _paymentDetailContent = new Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20.0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Detail Payment",
              style: TextStyle(fontFamily: 'Work Sans', fontSize: 10),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 13.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Parking Fare',
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Voucher Discount',
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Total',
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      fmf
                          .copyWith(
                              amount: widget.parkingFare.toDouble(),
                              symbol: 'Rp',
                              thousandSeparator: '.',
                              decimalSeparator: ',',
                              fractionDigits: 0)
                          .output
                          .symbolOnLeft,
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 5.0,
                    ),
                    Text(
                      fmf
                          .copyWith(
                              amount: widget.voucherNominal.toDouble(),
                              symbol: '-Rp',
                              thousandSeparator: '.',
                              decimalSeparator: ',',
                              fractionDigits: 0)
                          .output
                          .symbolOnLeft,
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 5.0,
                    ),
                    Text(
                      fmf
                          .copyWith(
                              amount: widget.totalBilling.toDouble(),
                              symbol: 'Rp',
                              thousandSeparator: '.',
                              decimalSeparator: ',',
                              fractionDigits: 0)
                          .output
                          .symbolOnLeft,
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 5.0,
                    ),
                  ],
                ),
              ),
              Container(
                width: 15.0,
              )
            ],
          ),
        ],
      ),
    );

    // Widget _checkOutContent = new Container(
    //   color: Colors.white,
    //   child: Padding(
    //     padding: EdgeInsets.all(15.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.end,
    //       children: <Widget>[
    //         new Text(
    //           fmf
    //               .copyWith(
    //                   amount: billing.toDouble(),
    //                   symbol: 'Rp',
    //                   thousandSeparator: '.',
    //                   decimalSeparator: ',',
    //                   fractionDigits: 0)
    //               .output
    //               .symbolOnLeft,
    //           style: TextStyle(fontFamily: 'Work Sans'),
    //         ),
    //         new SizedBox(
    //           height: 15.0,
    //         ),
    //         new Center(
    //           child: ButtonTheme(
    //             minWidth: MediaQuery.of(context).size.width / 2,
    //             child: RaisedButton(
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadiusDirectional.circular(18.0),
    //                 side: BorderSide(color: ColorLibrary.secondary),
    //               ),
    //               color: ColorLibrary.secondary,
    //               child: Text(
    //                 (widget.selectedType == 1) ? "Check Out" : "Check in",
    //                 style: TextStyle(fontFamily: 'Work Sans'),
    //               ),
    //               onPressed: () {
    //                 (widget.selectedType == 1)
    //                     ? _checkData()
    //                     : _showModalQR(context);
    //               },
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    Widget _titleContent = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          "Detail Ticket",
          style: TextStyle(
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: ColorLibrary.thinFontWhite),
        ),
        Text(
          "Ticket NO. ${widget.transCode}",
          style: TextStyle(
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w300,
              fontSize: 16,
              color: ColorLibrary.thinFontWhite),
        ),
      ],
    );

    Widget _circularProgress() {
      return CircularProgressIndicator(
        backgroundColor: ColorLibrary.primary,
        valueColor: AlwaysStoppedAnimation<Color>(ColorLibrary.secondary),
        strokeWidth: 2.0,
      );
    }

    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          title: _titleContent,
          backgroundColor: ColorLibrary.primary,
        ),
      ),
      body: SingleChildScrollView(
        child: new Container(
          color: ColorLibrary.thinFontWhite,
          height: MediaQuery.of(context).size.height,
          child: new Column(
            children: <Widget>[
              _locationContent,
              SizedBox(
                height: 3.0,
              ),
              _durationContent,
              SizedBox(
                height: 3.0,
              ),
              _voucherContent,
              SizedBox(
                height: 3.0,
              ),
              _paymentTypeContent,
              SizedBox(
                height: 3.0,
              ),
              _paymentDetailContent,
              SizedBox(
                height: 3.0,
              ),
            ],
          ),
        ),
      ),
      // bottomSheet: Container(
      //   child: _checkOutContent,
      //   height: MediaQuery.of(context).size.height / 5,
      //   decoration: BoxDecoration(boxShadow: [
      //     BoxShadow(
      //       color: Colors.black45,
      //       spreadRadius: 3.0,
      //       blurRadius: 2.0,
      //     ),
      //   ]),
      // ),
    );
  }
}
