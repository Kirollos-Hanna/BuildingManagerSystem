import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/Bill.dart';
import 'package:flutter_front_end/models/User.dart';
import 'package:flutter_front_end/screens/homeWrapper.dart';
import 'package:flutter_front_end/services/auth.dart';
import 'package:flutter_front_end/services/database.dart';
import 'package:flutter_front_end/widgets/billWidget.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingManagerHome extends StatefulWidget {
  // TODO show this page only after the user has decided their role

  @override
  _BuildingManagerHomeState createState() => _BuildingManagerHomeState();
}


class _BuildingManagerHomeState extends State<BuildingManagerHome> {
  final AuthService _auth = AuthService();

  int price = 0;
  String billType = "";

  String dropdownString = "Water";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final _formKey = GlobalKey<FormState>();

    // TODO make the manager specify the number of residents in the building along with the number of business owners

    return  Scaffold(
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
        body: SingleChildScrollView(
          child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
          DropdownButton<String>(
            value: dropdownString,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            underline: Container(
              height: 2,
              color: Colors.black,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownString = newValue;
                billType = newValue;
              });
            },
            items: <String>["Water", "Electricity", "Elevator", "Salaries", "Cleaning", "Other"]
                .map<DropdownMenuItem<String>> ((String val) {
                  return DropdownMenuItem<String> (
                    value: val,
                    child: Text(val),
                  );
            }).toList(), ),
                  SizedBox(height: 20.0,),

                  TextFormField(
                    validator: (val) => val.isEmpty ? 'Enter a price' : null,
                    decoration: InputDecoration(
                        hintText: "Bill price to be paid"
                    ),
                    onChanged: (val) {
                      setState(() {
                        price = int.parse(val);
                      });
                    },
                  ),
                  SizedBox(height: 20.0,),
                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: ()  {
                        DateTime currentDate = new DateTime.now();
                        String date = currentDate.year.toString() + "-" + currentDate.month.toString() + "-" + currentDate.day.toString();

                        // TODO change the uid to a dynamic one
                        Firestore.instance.collection('bills/es5oYeeSI9gWFOepMqhJ5y1kY6k1/bills')
                            .add({"status": 'unpaid', "generationDate": date, "type": billType, "amountDue": price});
                    },
                  ),
                  SizedBox(
                    height: 500,
                child: StreamBuilder(
                      stream: Firestore.instance
                          .collection('bills/es5oYeeSI9gWFOepMqhJ5y1kY6k1/bills')
                          .snapshots(),
                      builder: (ctx, streamSnapshot) {

                        final documents = streamSnapshot.data.documents;

                        if(streamSnapshot.connectionState == ConnectionState.waiting){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                          itemCount: documents.length,
                          itemBuilder: (ctx, index) => Container(
//                            child: Text(documents[index]['amountDue'].toString()),
                            child: BillWidget(
                                documents[index]['amountDue'].toString(),
                                documents[index]['status'],
                                documents[index]['generationDate'],
                                documents[index]['type']),
                          )
                        );
                      }
                    ),
              ),
                ],
              ),
        ),
    );
  }
}