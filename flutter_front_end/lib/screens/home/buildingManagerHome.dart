import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/constants/loading.dart';
import 'package:flutter_front_end/models/Bill.dart';
import 'package:flutter_front_end/models/User.dart';
import 'package:flutter_front_end/screens/homeWrapper.dart';
import 'package:flutter_front_end/services/auth.dart';
import 'package:flutter_front_end/services/database.dart';
import 'package:flutter_front_end/widgets/billWidget.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingManagerHome extends StatefulWidget {
  @override
  _BuildingManagerHomeState createState() => _BuildingManagerHomeState();
}

class _BuildingManagerHomeState extends State<BuildingManagerHome> {
  final AuthService _auth = AuthService();

  int price = 0;
  String billType = "";

  String dropdownString = "Water";

  List<dynamic> buildingAddress = [];
  String managerID = "a";
  bool asyncDone = false;
  String userName = "";

  List<dynamic> payedBills = [];
  List<dynamic> alreadyPayedBills = [];

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
      for (final element in value.documents) {
        print(element['role']);
        if (element['role'] == "Building Manager") {
          if (element['address']
                  .sublist(2, element['address'].length)
                  .toString() ==
              buildingAddress.toString()) {
            setState(() {
              managerID = element.documentID;
              asyncDone = true;
            });
            break;
          }
        }
      }

      setState(() {
        asyncDone = true;
      });
    });
    print(asyncDone);
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
    final user = Provider.of<User>(context);
    print(managerID);
    // TODO make the manager specify the number of residents in the building along with the number of business owners

    // if amountDue of a bill = 0, then it's status becomes = paid
    // manager should receive a message that says "{Name} has payed {Amount} of {Type} bill"
    // if manager verifies the message, subtract amount payed from original bill

    return !asyncDone
        ? Loading()
        : Scaffold(
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
                    items: <String>[
                      "Water",
                      "Electricity",
                      "Elevator",
                      "Salaries",
                      "Cleaning",
                      "Other"
                    ].map<DropdownMenuItem<String>>((String val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    validator: (val) => val.isEmpty ? 'Enter a price' : null,
                    decoration:
                        InputDecoration(hintText: "Bill price to be paid"),
                    onChanged: (val) {
                      setState(() {
                        price = int.parse(val);
                      });
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      DateTime currentDate = new DateTime.now();
                      String date = currentDate.year.toString() +
                          "-" +
                          currentDate.month.toString() +
                          "-" +
                          currentDate.day.toString();

                      // TODO change the uid to a dynamic one
                      Firestore.instance
                          .collection('bills/' + managerID + '/bills')
                          .add({
                        "status": 'unpaid',
                        "generationDate": date,
                        "type": billType,
                        "amountDue": price
                      });
                    },
                  ),
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection('bills/' + managerID + '/bills')
                          .snapshots(),
                      builder: (ctx, streamSnapshot) {
                        print(streamSnapshot.connectionState);
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Loading(),
                          );
                        }

                        final documents = streamSnapshot.data.documents;

                        print("Docs");
                        print(documents);

                        String userName = "";
                        Firestore.instance
                            .collection('additionalinfo')
                            .document(user.uid)
                            .get()
                            .then((value) => userName = value['name']);

                        var visibleDocs = [...documents];

                        print("Bills");
                        print(alreadyPayedBills);
                        documents.forEach((el) {
                          // if el.documentID in documents, remove it from visibleDocs
                          if (alreadyPayedBills.contains(el.documentID)) {
                            visibleDocs.remove(el);
                          }
                        });

                        print(visibleDocs);

                        // updated payedBills variable with the amountDue and type of bills that have been checked as paid
                        void updatePaidBills(
                            bool paid, String documentID, String price) {
                          if (paid) {
                            payedBills.add([userName, documentID, price]);
                          } else {
                            payedBills.remove([userName, documentID, price]);
                          }
                        }

                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: visibleDocs.length,
                            itemBuilder: (ctx, index) => Container(
                                  child: BillWidget(
                                      visibleDocs[index].documentID,
                                      visibleDocs[index]['amountDue']
                                          .toString(),
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
