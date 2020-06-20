import 'package:flutter/material.dart';

class BillWidget extends StatelessWidget{

  final String amountDue;
  final String status;
  final String generationDate;
  final String type;

  BillWidget(this.amountDue, this.status, this.generationDate, this.type);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(amountDue),
        Text(status),
        Text(generationDate),
        Text(type),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

}