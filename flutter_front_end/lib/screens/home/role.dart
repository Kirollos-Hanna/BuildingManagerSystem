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
  String phoneNumber = "";
  String apartmentNumber = "";
  String floorNumber = "";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);


    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text("Fill your Info"),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text("Choose your role"),
            ListTile(
              title: const Text('Business Owner'),
              leading: Radio(
                value: 'Business Owner',
                groupValue: role,
                onChanged: (val) {
                  setState(() {
                    role = val;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Resident'),
              leading: Radio(
                value: 'Resident',
                groupValue: role,
                onChanged: (val) {
                  setState(() {
                    role = val;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Building Manager'),
              leading: Radio(
                value: 'Building Manager',
                groupValue: role,
                onChanged: (val) {
                  setState(() {
                    role = val;
                  });
                },
              ),
            ),
            Text("Phone Number"),
            SizedBox(height: 20.0,),
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Phone Number"
              ),
              obscureText: true,
              validator: (val) => val.length < 10 ? 'Enter a valid phone number' : null,
              onChanged: (val) {
                setState(() {
                  phoneNumber = val;
                });
              },
            ),
            Text("Floor and Apartment Number"),
            SizedBox(height: 20.0,),
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Floor Number"
              ),
              obscureText: true,
              validator: (val) => val == null ? 'Enter a floor number' : null,
              onChanged: (val) {
                setState(() {
                  floorNumber = val;
                });
              },
            ),
            SizedBox(height: 20.0,),
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Apartment Number"
              ),
              obscureText: true,
              validator: (val) => val == null ? 'Enter an apartment number' : null,
              onChanged: (val) {
                setState(() {
                  apartmentNumber = val;
                });
              },
            ),
            RaisedButton(
              child: Text("Submit"),
              onPressed: () {
                DatabaseService(uid: user.uid).updateRole(role, phoneNumber, floorNumber, apartmentNumber);
              },
            )
          ],
        ),
      ),
    );
  }
}