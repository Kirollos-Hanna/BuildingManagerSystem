import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFC8A2C8),
      child: Center(
        child: SpinKitChasingDots(
          color: Color(0xFF852DCE),
          size: 50.0,
        ),
      ),
    );
  }
}