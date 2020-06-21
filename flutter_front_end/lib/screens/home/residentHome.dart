import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/User.dart';
import 'package:flutter_front_end/screens/homeWrapper.dart';
import 'package:flutter_front_end/services/auth.dart';
import 'package:flutter_front_end/services/database.dart';
import 'package:flutter_front_end/widgets/billWidget.dart';
import 'package:provider/provider.dart';

class ResidentHome extends StatefulWidget {

  @override
  _ResidentHomeState createState() => _ResidentHomeState();
}

class _ResidentHomeState extends State<ResidentHome> {
  final AuthService _auth = AuthService();

  List<dynamic> buildingAddress = [];
  String managerID = "";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    var currentDoc = Firestore.instance.collection('additionalinfo').document(user.uid);
    currentDoc.get().then((value) {
      buildingAddress = value['address'].sublist(2, value['address'].length);
    });

    // get bills related to this address
    Firestore.instance.collection('additionalinfo')
        .getDocuments()
        .then((value) {
          value.documents.forEach((element) {
            if(element['role'] == "Building Manager"){
              if(element['address'].sublist(2, element['address'].length).toString() == buildingAddress.toString()){
                managerID = element.documentID;
              }
            }
          });
    });

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
        body: Column(
          children: <Widget>[
            Text("Resident Home"),
            SizedBox(height: 20,),
            StreamBuilder(
                stream: Firestore.instance
                    .collection('bills/' + managerID + '/bills')
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
                        child: BillWidget(
                            documents[index]['amountDue'].toString(),
                            documents[index]['status'],
                            documents[index]['generationDate'],
                            documents[index]['type']),
                      )
                  );
                }
            ),
            RaisedButton(
              color: Colors.pink[400],
              child: Text(
                "Submit payments",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {

              },
            ),
          ],
        ),
      ),
    );
  }
}