import 'package:flutter/material.dart';
import 'package:flutter_front_end/screens/home/billForm.dart';
import 'package:flutter_front_end/screens/home/billTableWidget.dart';
import 'package:flutter_front_end/screens/home/residentNumberForm.dart';
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
        initialRoute: "/",
        routes: {
//            ManagerResidentsCountForm.routeName: (ctx) => ManagerResidentsCountForm(),
          BillForm.routeName: (ctx) => BillForm(),
          ResidentNumberForm.routeName: (ctx) => ResidentNumberForm(),
          BillTableWidget.routeName: (ctx) => BillTableWidget(),
        },
      ),
    );
  }
}
