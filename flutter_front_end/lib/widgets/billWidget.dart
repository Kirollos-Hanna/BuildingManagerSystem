import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/widgets/rawBillWidget.dart';

class BillWidget extends StatefulWidget {
  final String documentID;
  final String amountDue;
  final String status;
  final String generationDate;
  final String type;
  Function updatePaidBills;

  BillWidget(this.documentID, this.amountDue, this.status, this.generationDate,
      this.type, this.updatePaidBills);

  @override
  _BillWidgetState createState() => _BillWidgetState();
}

class _BillWidgetState extends State<BillWidget> {
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
          RawBillWidget(widget.amountDue, widget.generationDate, widget.type),
          CheckboxListTile(
            title: Text("Make Payment", style: TextStyle(fontSize: 16)),
            value: _paid,
            activeColor: Color(0xFFC8A2C8),
            onChanged: (newValue) {
              setState(() {
                this.widget.updatePaidBills(newValue, widget.type,
                    widget.generationDate, widget.amountDue, widget.documentID);
                _paid = newValue;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
        ],
      ),
    );
  }
}
