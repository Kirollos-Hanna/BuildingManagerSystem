import 'package:flutter/material.dart';

class RawBillWidget extends StatefulWidget {
  final String amountDue;
  final String generationDate;
  final String type;

  RawBillWidget(this.amountDue,this.generationDate,this.type);

  @override
  _RawBillWidgetState createState() => _RawBillWidgetState();
}

class _RawBillWidgetState extends State<RawBillWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Bill: " + widget.type,
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
            ),
            Text(
              "Payment: " + widget.amountDue,
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ],
        ),
//          Text(widget.status),
        Text("Bill Date: " + widget.generationDate),
      ],
    );
  }
}
