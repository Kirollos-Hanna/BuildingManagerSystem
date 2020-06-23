import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/constants/loading.dart';
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
  String managerID = "a";
  bool asyncDone = false;
  String userName = "";

  List<dynamic> payedBills = [];
  List<dynamic> alreadyPayedBills = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    final user = Provider.of<User>(context);

    var currentDoc =
    Firestore.instance.collection('additionalinfo').document(user.uid);
    await currentDoc.get().then((value) {
      buildingAddress = value['address'].sublist(2, value['address'].length);
    });


    Firestore.instance
        .collection('additionalinfo')
        .document(user.uid)
        .get()
        .then((value) => userName = value['name']);

    // get bills related to this address
    await Firestore.instance
        .collection('additionalinfo')
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        //TODO if a building manager doesn't exist for this address, tell the user they don't have a building manager
        if (element['role'] == "Building Manager") {
          if (element['address']
              .sublist(2, element['address'].length)
              .toString() ==
              buildingAddress.toString()) {
            setState(() {
              managerID = element.documentID;
              asyncDone = true;
            });
          }
        }
      });
    });

    CollectionReference payedBillsCollection = Firestore
        .instance
        .collection('bills/' + managerID + '/payedbills');

    await payedBillsCollection.getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        if(element['payerName'] == userName && !alreadyPayedBills.contains(element["billID"])){
          setState(() {
            alreadyPayedBills.add(element["billID"]);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return !asyncDone
        ? Loading()
        : StreamProvider<QuerySnapshot>.value(
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
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream: Firestore.instance
                    .collection('bills/' + managerID + '/bills')
                    .snapshots(),
                builder: (ctx, streamSnapshot) {
                  if (streamSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: Loading(),
                    );
                  }

                  final documents = streamSnapshot.data.documents;

                  var visibleDocs = [...documents];

                  documents.forEach((el) {
                    // if el.documentID is in documents, remove it from visibleDocs
                    if(alreadyPayedBills.contains(el.documentID)){
                      visibleDocs.remove(el);
                    }
                  });

                  // updated payedBills variable with the amountDue and type of bills that have been checked as paid
                  void updatePaidBills(bool paid, String documentID,
                      String price) {
                    if (paid) {
                      payedBills.add([userName, documentID, price]);
                    } else {
                      payedBills.remove([userName, documentID, price]);
                    }
                  }

                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: visibleDocs.length,
                      itemBuilder: (ctx, index) =>
                          Container(
                            child: BillWidget(
                                visibleDocs[index].documentID,
                                visibleDocs[index]['amountDue'].toString(),
                                visibleDocs[index]['status'],
                                visibleDocs[index]['generationDate'],
                                visibleDocs[index]['type'],
                                updatePaidBills),
                          ));
                }),
            RaisedButton(
              color: Colors.pink[400],
              child: Text(
                "Submit payments",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // send verification to manager (Data: type, amount, name)
                CollectionReference payedBillsCollection = Firestore
                    .instance
                    .collection('bills/' + managerID + '/payedbills');
                payedBills.forEach((element) {
                  payedBillsCollection.add({
                    "amountPayed": element[2],
                    "billID": element[1],
                    "payerName": element[0]
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
