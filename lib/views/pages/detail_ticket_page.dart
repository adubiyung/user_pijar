import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:user_pijar/models/getTransaction.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:intl/intl.dart';

class DetailTicketPage extends StatefulWidget {
  final DataTransaction modelTrans;
  final int selectedType;

  const DetailTicketPage({Key key, this.modelTrans, this.selectedType})
      : super(key: key);

  @override
  _DetailTicketPageState createState() => _DetailTicketPageState();
}

class _DetailTicketPageState extends State<DetailTicketPage> {
  var dateout;
  String datetimeOut = '9999-12-31T00:00:00';
  var loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: 12345678.9012345);

    Widget _locationContent = new Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.modelTrans.location.locationName,
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 18),
          ),
          Text(
            widget.modelTrans.location.locationAddress,
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 12),
          ),
          Text(
            widget.modelTrans.location.locationCity,
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 12),
          ),
        ],
      ),
    );

    List<String> splitIn = [];
    var datein;
    if (widget.selectedType == 1) {
      datein = widget.modelTrans.checkinTime;
    } else {
      datein = widget.modelTrans.startTime;
    }
    splitIn = datein.split("T");
    String tglin = splitIn[0];
    String combineIn = splitIn[0] + " " + splitIn[1];
    var parseCombineIn = DateFormat("yyyy-MM-dd hh:mm:ss").parse(combineIn);
    var parseDateIn = DateFormat("yyyy-MM-dd").parse(tglin);
    final formatDateIn = DateFormat("EEE, MMM d").format(parseDateIn);

    String waktuIn = splitIn[1];
    var parseTimeIn = DateFormat("hh:mm:ss").parse(waktuIn);
    var formatTimeIn = DateFormat("hh:mm a").format(parseTimeIn);

    List<String> splitOut = [];
    splitOut = datetimeOut.split("T");
    String tglOut = splitOut[0];
    String combineOut = splitOut[0] + " " + splitOut[1];
    var parseCombineOut = DateFormat("yyyy-MM-dd H:m:s").parse(combineOut);
    var parseDateOut = DateFormat("yyyy-MM-dd").parse(tglOut);
    final formatDateOut = DateFormat("EEE, MMM d").format(parseDateOut);

    String waktuOut = splitOut[1];
    var parseTimeOut = DateFormat("h:m:s").parse(waktuOut);
    var formatTimeOut = DateFormat("hh:mm a").format(parseTimeOut);

    DateTime checkout = DateTime.parse(widget.modelTrans.checkoutTime);
    DateTime endTime = DateTime.parse(widget.modelTrans.endTime);
    int inMinutes = endTime.difference(checkout).inMinutes.abs();
    String convertJam = (inMinutes / 60).toString();
    String jamPenalty = convertJam.split('.')[0];
    String menitPenalty = (inMinutes % (60)).toString();
    String penaltyDuration = "${jamPenalty}h ${menitPenalty}m";

    String convertDuration = (widget.modelTrans.totalDuration / 60).toString();
    String jamDuration = convertDuration.split('.')[0];
    String menitDuration = (widget.modelTrans.totalDuration % 60).toString();
    String duration = "${jamDuration}h ${menitDuration}m";

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
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 25.0),
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          Icons.local_play,
          color: ColorLibrary.primary,
        ),
        title: Text(
          "${widget.modelTrans.voucher.voucherCode}",
          style:
              TextStyle(fontFamily: 'Work Sans', color: ColorLibrary.primary),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              fmf
                  .copyWith(
                      amount: widget.modelTrans.voucherNominal.toDouble(),
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
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 25),
      color: Colors.white,
      child: ListTile(
          leading: Icon(
            Icons.account_balance_wallet,
            color: ColorLibrary.primary,
          ),
          title: Text(
            "Cash",
            style:
                TextStyle(fontFamily: 'Work Sans', color: ColorLibrary.primary),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                fmf
                    .copyWith(
                        amount: widget.modelTrans.parkingBilling.toDouble(),
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
          )),
    );

    Widget _penaltyInfo = new Container(
      padding: EdgeInsets.all(20.0),
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Detail Penalty",
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
                      "Penalty Time",
                      style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "$penaltyDuration",
                      style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
            ],
          ),
        ],
      ),
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
                    Visibility(
                      visible:
                          (widget.modelTrans.featureType.featureTypeID == 2)
                              ? true
                              : false,
                      child: Text(
                        'Penalty',
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
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
                              amount:
                                  widget.modelTrans.parkingBilling.toDouble(),
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
                    Visibility(
                      visible:
                          (widget.modelTrans.featureType.featureTypeID == 2)
                              ? true
                              : false,
                      child: Text(
                        fmf
                            .copyWith(
                                amount:
                                    widget.modelTrans.penaltyBilling.toDouble(),
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
                    ),
                    Container(
                      height: 5.0,
                    ),
                    Text(
                      fmf
                          .copyWith(
                              amount:
                                  widget.modelTrans.voucherNominal.toDouble(),
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
                              amount: widget.modelTrans.totalBilling.toDouble(),
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

    Widget _checkOutContent = new Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(
              fmf
                  .copyWith(
                      amount: widget.modelTrans.totalBilling.toDouble(),
                      symbol: 'Rp',
                      thousandSeparator: '.',
                      decimalSeparator: ',',
                      fractionDigits: 0)
                  .output
                  .symbolOnLeft,
              style: TextStyle(fontFamily: 'Work Sans'),
            ),
            new SizedBox(
              height: 15.0,
            ),
            new Center(
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width / 2,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(18.0),
                    side: BorderSide(color: Colors.grey),
                  ),
                  child: Text(
                    "Finish",
                    style: TextStyle(fontFamily: 'Work Sans'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

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
          "Ticket NO. ${widget.modelTrans.transactionCode}",
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
      body: loading
          ? Center(
              child: _circularProgress(),
            )
          : SingleChildScrollView(
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
                      height: 2.0,
                    ),
                    Visibility(
                      visible: widget.modelTrans.featureType.featureTypeID == 2,
                      child: _penaltyInfo,
                    ),
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
      bottomSheet: Container(
        child: _checkOutContent,
        height: MediaQuery.of(context).size.height / 5,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black45,
            spreadRadius: 3.0,
            blurRadius: 2.0,
          ),
        ]),
      ),
    );
  }
}
