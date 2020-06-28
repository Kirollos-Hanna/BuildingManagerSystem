import 'package:flutter/material.dart';
import 'package:flutter_front_end/screens/home/billForm.dart';
import 'package:flutter_front_end/screens/home/billTableWidget.dart';
import 'package:flutter_front_end/screens/home/buildingManagerHome.dart';
import 'package:flutter_front_end/screens/home/personalPaymentHistory.dart';
import 'package:flutter_front_end/screens/home/reportsWidget.dart';
import 'package:flutter_front_end/screens/home/residentNumberForm.dart';
import 'package:flutter_front_end/screens/home/userPaymentHistory.dart';

class ResidentDrawerWidget extends StatefulWidget {
  @override
  _ResidentDrawerWidgetState createState() => _ResidentDrawerWidgetState();
}

class _ResidentDrawerWidgetState extends State<ResidentDrawerWidget> {
  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Color(0xFF842DCE),
            child: Text(
              "Building Manager System",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildListTile("Home", Icons.home, () {
            Navigator.of(context).pushReplacementNamed(BuildingManagerHome.routeName);
          }),
          buildListTile("Personal Payments History", Icons.info_outline, () {
            Navigator.of(context).pushReplacementNamed(PersonalPaymentHistoryWidget.routeName);
          }),
        ],
      ),
    );
  }
}
