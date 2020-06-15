import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/screens/homeWrapper.dart';
import 'package:flutter_front_end/services/auth.dart';
import 'package:flutter_front_end/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingManagerHome extends StatelessWidget {
  // TODO show this page only after the user has decided their role

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {


    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService().role,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text("Home Page"),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: Text("Building Manager Home"),
      ),
    );
  }
}