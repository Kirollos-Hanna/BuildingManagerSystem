import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/User.dart';
import 'package:flutter_front_end/services/auth.dart';
import 'package:flutter_front_end/services/database.dart';
import 'package:provider/provider.dart';

class Role extends StatefulWidget {

  @override
  _RoleState createState() => _RoleState();
}

class _RoleState extends State<Role> {
//  final AuthService _auth = AuthService();

  String role = "Renter";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text("Choose your role"),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: const Text('Renter'),
            leading: Radio(
              value: 'Renter',
              groupValue: role,
              onChanged: (val) {
                setState(() {
                  role = val;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Property Owner'),
            leading: Radio(
              value: 'Property Owner',
              groupValue: role,
              onChanged: (val) {
                setState(() {
                  role = val;
                });
              },
            ),
          ),
          RaisedButton(
            child: Text("Submit"),
            onPressed: () {
              DatabaseService(uid: user.uid).updateRole(role);
            },
          )
        ],
      ),
    );
  }
}