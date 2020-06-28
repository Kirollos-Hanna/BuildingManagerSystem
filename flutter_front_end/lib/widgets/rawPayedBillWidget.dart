import 'package:flutter/material.dart';

class RawPayedBillWidget extends StatefulWidget {
  final String amountPayed;
  final String generationDate;
  final String type;
  final String payerName;

  RawPayedBillWidget(
      this.amountPayed,
      this.generationDate,
      this.type,
      this.payerName);

  @override
  _RawPayedBillWidgetState createState() => _RawPayedBillWidgetState();
}

class _RawPayedBillWidgetState extends State<RawPayedBillWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Payer Name: " + widget.payerName,
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
            ),
            Text(
              "Price Paid: " + widget.amountPayed,
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ],
        ),
        Text("Bill type: " + widget.type),
        Text("Date of Bill: " + widget.generationDate),
      ],
    );
  }
}
