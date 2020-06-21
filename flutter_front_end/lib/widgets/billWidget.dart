import 'package:flutter/material.dart';

class BillWidget extends StatefulWidget{

  final String amountDue;
  final String status;
  final String generationDate;
  final String type;

  BillWidget(this.amountDue, this.status, this.generationDate, this.type);

  @override
  _BillWidgetState createState() => _BillWidgetState();
}

class _BillWidgetState extends State<BillWidget> {
  bool paid = false;

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
          value: paid,
          onChanged: (newValue) {
            setState(() {
              paid = newValue;
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