import 'package:flutter/material.dart';
import 'package:flutter_front_end/services/auth.dart';
import 'package:provider/provider.dart';
import 'models/User.dart';
import 'screens/wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
        child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
