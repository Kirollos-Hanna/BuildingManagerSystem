import 'package:flutter/material.dart';

class PayedBillsWidget extends StatefulWidget{

  final String documentID;
  final String amountPayed;
  final String generationDate;
  final String type;
  final String payerName;
  final String billID;
  Function verifyPaidBills;
  Function doNotVerifyPaidBills;

  PayedBillsWidget(this.documentID, this.amountPayed, this.generationDate, this.type, this.payerName, this.billID, this.verifyPaidBills, this.doNotVerifyPaidBills);

  @override
  _PayedBillsWidget createState() => _PayedBillsWidget();
}

class _PayedBillsWidget extends State<PayedBillsWidget> {
  bool _paid = false;
  bool get paid {
    return _paid;
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Text(widget.payerName),
        Text(widget.amountPayed),
        Text(widget.generationDate),
        Text(widget.type),
        RaisedButton(
          child: Text("verify"),
          onPressed: () {
            print("verify");
            widget.verifyPaidBills(widget.documentID, widget.billID, widget.amountPayed);

          },
        ),
        RaisedButton(
          child: Text("don't verify"),
          onPressed: () {
            print("don't verify");
            // Delete bill document from payedBills
            widget.doNotVerifyPaidBills(widget.documentID);
          },
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}