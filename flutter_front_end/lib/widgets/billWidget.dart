import 'package:flutter/material.dart';

class BillWidget extends StatefulWidget{

  final String documentID;
  final String amountDue;
  final String status;
  final String generationDate;
  final String type;
  Function updatePaidBills;

  BillWidget(this.documentID, this.amountDue, this.status, this.generationDate, this.type, this.updatePaidBills);

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

    return Column(
      children: <Widget>[
        Text(widget.amountDue),
        Text(widget.status),
        Text(widget.generationDate),
        Text(widget.type),
        CheckboxListTile(
          title: Text("Paid"),
          value: _paid,
          onChanged: (newValue) {
            setState(() {
              this.widget.updatePaidBills(newValue, widget.documentID, widget.amountDue);
              _paid = newValue;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}