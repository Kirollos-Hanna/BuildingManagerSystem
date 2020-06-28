import 'package:flutter/material.dart';
import 'package:flutter_front_end/widgets/rawPayedBillWidget.dart';

class PayedBillsWidget extends StatefulWidget {
  final String documentID;
  final String amountPayed;
  final String generationDate;
  final String type;
  final String payerName;
  final String billID;
  final Function verifyPaidBills;
  final Function doNotVerifyPaidBills;

  PayedBillsWidget(
      this.documentID,
      this.amountPayed,
      this.generationDate,
      this.type,
      this.payerName,
      this.billID,
      this.verifyPaidBills,
      this.doNotVerifyPaidBills);

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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF852DCE),
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0x99852DCE),
            spreadRadius: 2,
            blurRadius: 7, // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        RawPayedBillWidget(widget.amountPayed,
            widget.generationDate,
            widget.type,
            widget.payerName),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                child: Text("Verify"),
                color: Color(0xFFC8A2C8),
                onPressed: () {
                  print("verify");
                  widget.verifyPaidBills(
                      widget.documentID, widget.billID, widget.amountPayed);
                },
              ),
              RaisedButton(
                child: Text("Don't verify"),
                color: Color(0xFFC8A2C8),
                onPressed: () {
                  print("don't verify");
                  // Delete bill document from payedBills
                  widget.doNotVerifyPaidBills(widget.documentID);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
