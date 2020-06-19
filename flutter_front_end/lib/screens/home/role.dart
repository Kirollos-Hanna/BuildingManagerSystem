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

  String name = "";
  String role = "Renter";
  String phoneNumber = "";
  bool occupied = false;

  String country = "";
  String governorate = "";
  String district = "";
  String street = "";
  String buildingNumber = "";
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
            Text("Write your name"),
            SizedBox(height: 20.0,),
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Name"
              ),
              validator: (val) => val == null ? 'Enter your Name' : null,
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
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
            CheckboxListTile(
              title: Text("Are you occupying your apartment?"),
              value: occupied,
              onChanged: (newValue) {
                setState(() {
                  occupied = newValue;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
            ),
            Text("Phone Number"),
            SizedBox(height: 20.0,),
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Phone Number"
              ),
              validator: (val) => val.length < 10 ? 'Enter a valid phone number' : null,
              onChanged: (val) {
                setState(() {
                  phoneNumber = val;
                });
              },
            ),
            Text("Floor, Apartment Number and Address"),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  width: 100,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Floor Number"
                    ),
                    validator: (val) => val == null ? 'Enter a floor number' : null,
                    onChanged: (val) {
                      setState(() {
                        floorNumber = val.toLowerCase();
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  width: 100,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Apartment Number"
                    ),
                    validator: (val) => val == null ? 'Enter an apartment number' : null,
                    onChanged: (val) {
                      setState(() {
                        apartmentNumber = val.toLowerCase();
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  width: 100,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Building Number"
                    ),
                    validator: (val) => val == null ? 'Enter a building number' : null,
                    onChanged: (val) {
                      setState(() {
                        buildingNumber = val.toLowerCase();
                      });
                    },
                  ),
                ),
              ],
            ),
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5.0),
              width: 100,
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: "Street name"
                ),
                validator: (val) => val == null ? 'Enter a street name' : null,
                onChanged: (val) {
                  setState(() {
                    street = val.toLowerCase();
                  });
                },
              ),
            ),

            Container(
              padding: EdgeInsets.all(5.0),
              width: 100,
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: "district"
                ),
                validator: (val) => val == null ? 'Enter a district name' : null,
                onChanged: (val) {
                  setState(() {
                    district = val.toLowerCase();
                  });
                },
              ),
            ),
            ],
        ),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  width: 100,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Governorate"
                    ),
                    validator: (val) => val == null ? 'Enter a governorate' : null,
                    onChanged: (val) {
                      setState(() {
                        governorate = val.toLowerCase();
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  width: 100,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Country"
                    ),
                    validator: (val) => val == null ? 'Enter a country' : null,
                    onChanged: (val) {
                      setState(() {
                        country = val.toLowerCase();
                      });
                    },
                  ),
                ),
              ],
            ),
            RaisedButton(
              child: Text("Submit"),
              onPressed: () {
                var address = [apartmentNumber, floorNumber, buildingNumber, street, district, governorate, country];
                DatabaseService(uid: user.uid).updateRole(name, role, phoneNumber, floorNumber, apartmentNumber, occupied, address);
              },
            )
          ],
        ),
      ),
    );
  }
}