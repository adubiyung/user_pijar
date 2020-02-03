import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:user_pijar/models/getTransaction.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/pages/voucher_page.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/dialog_payment_qr.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;

class CheckoutTicketPage extends StatefulWidget {
  final DataTransaction modelTrans;
  final int selectedType;

  const CheckoutTicketPage({Key key, this.modelTrans, this.selectedType})
      : super(key: key);
  @override
  _CheckoutTicketPageState createState() => _CheckoutTicketPageState();
}

class _CheckoutTicketPageState extends State<CheckoutTicketPage> {
  SessionManager _session;
  HashMap<String, String> userData;

  String userID;
  String checkout = '';
  String duration = '';
  int fare = 0;
  int penalty = 0;
  int billing = 0;
  String _voucherID = "";
  String _voucherName = "";
  String _voucherPercent = "";
  String _voucherNominal = "";
  double voucherTemp = 0;
  var dateout;
  String datetimeOut = '9999-12-31T00:00:00';
  var loading = false;

  void _showModalQR(context) {
    String transCode = widget.modelTrans.transactionCode;
    String methodCode;

    if (widget.selectedType == 2) {
      methodCode = '2';
    } else {
      methodCode = '3';
    }

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return DialogPaymentQR(methodCode, userID, transCode);
        });
  }

  Future<Null> _fetchData() async {
    String url = BaseUrl.GETTIME;
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    userID = userData['USER_ID'];
    String token = userData['USER_TOKEN'];
    int startPrice = widget.modelTrans.startPrice;
    int nextPrice = widget.modelTrans.nextPrice;

    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    final response = await http
        .get("$url", headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      final jsonObject = jsonDecode(response.body);

      setState(() {
        loading = false;

        DateTime keluarDate;
        DateTime masukDate;
        String timeServer = jsonObject['data'];
        DateTime waktuServer = DateTime.parse(timeServer);
        if (widget.selectedType == 1) {
          masukDate = DateTime.parse(widget.modelTrans.checkinTime);
          datetimeOut = timeServer;
          keluarDate = DateTime.parse(datetimeOut);
        } else {
          masukDate = DateTime.parse(widget.modelTrans.startTime);
          datetimeOut = widget.modelTrans.endTime;
          keluarDate = DateTime.parse(datetimeOut);
        }
        int inMinutes = masukDate.difference(keluarDate).inMinutes.abs();

        String convertJam = (inMinutes / 60).toString();
        String jam = convertJam.split('.')[0];
        String menit = (inMinutes % (60)).toString();
        duration = '${jam}h ${menit}m';

        var hour = int.parse(jam);
        var min = int.parse(menit);
        int nextJam = hour - 1;
        if (widget.selectedType == 1) {
          if (min > 5) {
            setState(() {
              fare = (1 * startPrice) + (nextJam * nextPrice) + nextPrice;
              billing = fare;
            });
          } else {
            setState(() {
              fare = (1 * startPrice) + (nextJam * nextPrice);
              billing = fare;
            });
          }
        } else {
          int inMinutes = keluarDate.difference(waktuServer).inMinutes.abs();
          String convertJam = (inMinutes / 60).toString();
          String jam = convertJam.split('.')[0];
          String menit = (inMinutes % (60)).toString();
          // duration = '${jam}h ${menit}m';
          var hour = int.parse(jam);
          var min = int.parse(menit);
          if (min > 5) {
            setState(() {
              fare = widget.modelTrans.parkingBilling;
              penalty = (hour * nextPrice) + nextPrice;
              billing = fare + penalty;
            });
          } else {
            setState(() {
              fare = widget.modelTrans.parkingBilling;
              penalty = (hour * nextPrice);
              billing = fare + penalty;
            });
          }
        }
      });
    }
  }

  Future<Null> _checkData() async {
    String url = BaseUrl.GETTIME;
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    String token = userData['USER_TOKEN'];
    int startPrice = widget.modelTrans.startPrice;
    int nextPrice = widget.modelTrans.nextPrice;

    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    final response = await http
        .get("$url", headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      final jsonObject = jsonDecode(response.body);

      setState(() {
        datetimeOut = jsonObject['data'];
        DateTime keluarDate = DateTime.parse(datetimeOut);
        DateTime masukDate = DateTime.parse(widget.modelTrans.checkinTime);
        int inMinutes = masukDate.difference(keluarDate).inMinutes.abs();
        loading = false;
        String jam = (inMinutes / 60).toString().substring(0, 1);
        String menit = (inMinutes % (60)).toString();
        duration = '${jam}h ${menit}m';

        var hour = int.parse(jam);
        var min = int.parse(menit);
        int nextJam = hour - 1;
        if (min > 5) {
          int harga = (1 * startPrice) + (nextJam * nextPrice) + nextPrice;
          if (harga != fare) {
            setState(() {
              fare = harga;
              billing = harga;
            });
            _dialogWarning();
          } else {
            _showModalQR(context);
          }
        } else {
          int harga = (1 * startPrice) + (nextJam * nextPrice);
          if (harga != fare) {
            setState(() {
              fare = harga;
              billing = harga;
            });
            _dialogWarning();
          } else {
            _showModalQR(context);
          }
        }
      });
    }
  }

  void _dialogWarning() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.SCALE,
      body: new Container(
        child: Column(
          children: <Widget>[
            new Center(
              child: new Text(
                "Ooops !",
                style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            new Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(
                "There is price changes",
                style: TextStyle(fontFamily: 'Work Sans'),
              ),
            ),
          ],
        ),
      ),
      btnOkText: "OK",
      btnOkOnPress: () {},
      dismissOnTouchOutside: false,
    ).show();
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

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

    _navigateVoucherPage(BuildContext context) async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new VoucherPage(),
          fullscreenDialog: true,
        ),
      );

      if (result != null) {
        var hasil = result.split(",");
        voucherTemp = billing * (int.parse(hasil[1]) / 100);
        if (voucherTemp < int.parse(hasil[2])) {
          setState(() {
            billing = fare - voucherTemp.round();
            //
          });
        } else {
          setState(() {
            billing = fare - int.parse(hasil[2]);
            voucherTemp = double.parse(hasil[2]);
            //
          });
        }
        if (mounted) {
          setState(() {
            _voucherID = hasil[0];
            _voucherPercent = hasil[1];
            _voucherNominal = hasil[2];
            _voucherName = hasil[3];
          });
        }
      }
    }

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
          (_voucherName.isEmpty) ? "Gunakan voucher" : _voucherName,
          style:
              TextStyle(fontFamily: 'Work Sans', color: ColorLibrary.primary),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "choose",
              style: TextStyle(
                  fontFamily: 'Work Sans', color: ColorLibrary.primary),
            ),
            Icon(Icons.more_vert)
          ],
        ),
        onTap: () {
          _navigateVoucherPage(context);
        },
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
                        amount: billing.toDouble(),
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
                      "Penalty Time ()",
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
                      "Rp 0",
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
                              amount: fare.toDouble(),
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
                                amount: penalty.toDouble(),
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
                              amount: voucherTemp.toDouble(),
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
                              amount: billing.toDouble(),
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
                      amount: billing.toDouble(),
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
                    side: BorderSide(color: ColorLibrary.secondary),
                  ),
                  color: ColorLibrary.secondary,
                  child: Text(
                    (widget.selectedType == 1) ? "Check Out" : "Check in",
                    style: TextStyle(fontFamily: 'Work Sans'),
                  ),
                  onPressed: () {
                    (widget.selectedType == 1)
                        ? _checkData()
                        : _showModalQR(context);
                  },
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
