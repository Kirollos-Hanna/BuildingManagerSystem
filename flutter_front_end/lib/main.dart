import 'package:flutter/material.dart';
import 'package:flutter_front_end/screens/authenticate/login.dart';
import 'package:flutter_front_end/screens/home/billForm.dart';
import 'package:flutter_front_end/screens/home/billTableWidget.dart';
import 'package:flutter_front_end/screens/home/buildingManagerHome.dart';
import 'package:flutter_front_end/screens/home/personalPaymentHistory.dart';
import 'package:flutter_front_end/screens/home/reportsWidget.dart';
import 'package:flutter_front_end/screens/home/residentHome.dart';
import 'package:flutter_front_end/screens/home/residentNumberForm.dart';
import 'package:flutter_front_end/screens/home/userPaymentHistory.dart';
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
          ReportsWidget.routeName: (ctx) => ReportsWidget(),
          BuildingManagerHome.routeName: (ctx) => BuildingManagerHome(),
          ResidentHome.routeName: (ctx) => ResidentHome(),
          Login.routeName: (ctx) => Login(),
          Wrapper.routeName: (ctx) => Wrapper(),
          UserPaymentHistoryWidget.routeName: (ctx) => UserPaymentHistoryWidget(),
          PersonalPaymentHistoryWidget.routeName: (ctx) => PersonalPaymentHistoryWidget(),
        },
      ),
    );
  }
}
