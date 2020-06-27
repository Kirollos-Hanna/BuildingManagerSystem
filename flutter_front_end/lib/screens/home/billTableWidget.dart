import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/constants/loading.dart';
import 'package:flutter_front_end/models/User.dart';
import 'package:flutter_front_end/services/auth.dart';
import 'package:flutter_front_end/services/database.dart';
import 'package:flutter_front_end/widgets/billWidget.dart';
import 'package:flutter_front_end/widgets/buildingManagerWidget.dart';
import 'package:provider/provider.dart';

class BillTableWidget extends StatefulWidget {
  static const routeName = "/BillTableWidget";

  @override
  _BillTableWidgetState createState() => _BillTableWidgetState();
}

class _BillTableWidgetState extends State<BillTableWidget> {

  final AuthService _auth = AuthService();

  List<dynamic> buildingAddress = [];
  String managerID = "a";
  bool asyncDone = false;
  String userName = "";
  String pricePaidNotification = "";
  double totalNumberOfResidents = 1;
  String userRole = "";

  List<dynamic> payedBills = [];
  List<dynamic> alreadyPayedBills = [];

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    final user = Provider.of<User>(context);

    var currentDoc =
    Firestore.instance.collection('additionalinfo').document(user.uid);
    await currentDoc.get().then((value) {
      userRole = value['role'];
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

    CollectionReference residentsCollection =
    Firestore.instance.collection('/residents');

    await residentsCollection.document(managerID).get()
        .then((value) {
      setState(() {
        totalNumberOfResidents = value["residents"].toDouble();
        totalNumberOfResidents += value["businessOwners"]*2.0;
      });
    });

    CollectionReference payedBillsCollection =
    Firestore.instance.collection('bills/' + managerID + '/payedbills');

    await payedBillsCollection.getDocuments().then((value) {
      value.documents.forEach((element) {
        if (element['payerName'] == userName &&
            !alreadyPayedBills.contains(element["billID"])) {
          setState(() {
            alreadyPayedBills.add(element["billID"]);
          });
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService().role,
      child: Scaffold(
        backgroundColor: Color(0xFFC8A2C8),
        appBar: AppBar(
          title: Text("My Bills"),
          backgroundColor: Color(0xFF852DCE),
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
        drawer: BuildingManagerWidget(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
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
                      if (alreadyPayedBills.contains(el.documentID)) {
                        visibleDocs.remove(el);
                      }
                    });

                    // updated payedBills variable with the amountDue and type of bills that have been checked as paid
                    void updatePaidBills(
                        bool paid,
                        String type,
                        String generationDate,
                        String price,
                        String billID) {
                      if (paid) {
                        payedBills.add([
                          userName,
                          type,
                          generationDate,
                          price,
                          billID
                        ]);
                      } else {
                        payedBills.remove([
                          userName,
                          type,
                          generationDate,
                          price,
                          billID
                        ]);
                      }
                    }

                    if(userRole == "Business Owner"){
                      totalNumberOfResidents /= 2.0;
                    }

                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: visibleDocs.length,
                        itemBuilder: (ctx, index) => Container(
                          child: BillWidget(
                              visibleDocs[index].documentID,
                              (visibleDocs[index]['amountDue'] / totalNumberOfResidents)
                                  .toStringAsFixed(2), // TODO refactor this with the correct price up to 2 decimal points only
                              visibleDocs[index]['status'],
                              visibleDocs[index]['generationDate'],
                              visibleDocs[index]['type'],
                              updatePaidBills),
                        ));
                  }),
              Text(pricePaidNotification),
              RaisedButton(
                color: Color(0xFF852DCE),
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
                      "billID": element[4],
                      "amountPayed": element[3],
                      "generationDate": element[2],
                      "type": element[1],
                      "payerName": element[0],
                      "verified": false
                    });
                  });

                  setState(() {
                    pricePaidNotification = "Bill has been paid";
                    print(payedBills);
                    payedBills.forEach((element) {
                      alreadyPayedBills.add(element[4]);
                    });
                    payedBills = [];
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

