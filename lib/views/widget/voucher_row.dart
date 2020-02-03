import 'package:flutter/material.dart';
import 'package:user_pijar/models/voucher.dart';

class VoucherRow extends StatelessWidget {
  final Voucher model;

  const VoucherRow(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Card(
        child: new ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
          leading: new Container(
            padding: EdgeInsets.only(left: 10),
            width: 70.0,
            height: 30.0,
            child: Text(
              model.voucherPercent.toString() + "%",
              style: TextStyle(fontFamily: 'Work Sans', fontSize: 24),
            ),
          ),
          title: new Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  model.voucherName,
                  style: TextStyle(
                    fontFamily: 'Work Sans',
                    fontSize: 24,
                  ),
                ),
                Text(
                  "code : ${model.voucherCode}",
                  style: TextStyle(
                    fontFamily: 'Work Sans',
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Max. nominal : ${model.voucherMax}",
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Valid until : ${model.voucherMax}",
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).pop(
                '${model.voucherID},${model.voucherPercent},${model.voucherMax},${model.voucherName}');
          },
        ),
      ),
    );
  }
}
