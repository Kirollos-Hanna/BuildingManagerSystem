import 'package:flutter/material.dart';
import 'package:flutter_front_end/screens/home/billForm.dart';
import 'package:flutter_front_end/screens/home/billTableWidget.dart';
import 'package:flutter_front_end/screens/home/buildingManagerHome.dart';
import 'package:flutter_front_end/screens/home/reportsWidget.dart';
import 'package:flutter_front_end/screens/home/residentNumberForm.dart';

class BuildingManagerWidget extends StatelessWidget {
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
          buildListTile("Write Bills", Icons.account_balance_wallet, () {
            Navigator.of(context).pushReplacementNamed(BillForm.routeName);
          }),
          buildListTile("Set Resident Number", Icons.person_add, () {
            Navigator.of(context).pushReplacementNamed(ResidentNumberForm.routeName);
          }),
          buildListTile("My Bills", Icons.monetization_on, () {
            Navigator.of(context).pushReplacementNamed(BillTableWidget.routeName);
          }),
          buildListTile("Reports", Icons.report, () {
            Navigator.of(context).pushReplacementNamed(ReportsWidget.routeName);
          }),
        ],
      ),
    );
  }
}
