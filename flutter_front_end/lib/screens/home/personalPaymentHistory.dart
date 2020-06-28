import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_front_end/constants/loading.dart';
import 'package:flutter_front_end/models/Bill.dart';
import 'package:flutter_front_end/models/User.dart';
import 'package:flutter_front_end/screens/authenticate/login.dart';
import 'package:flutter_front_end/screens/home/billTableWidget.dart';
import 'package:flutter_front_end/screens/homeWrapper.dart';
import 'package:flutter_front_end/services/auth.dart';
import 'package:flutter_front_end/services/database.dart';
import 'package:flutter_front_end/widgets/billWidget.dart';
import 'package:flutter_front_end/widgets/buildingManagerWidget.dart';
import 'package:flutter_front_end/widgets/payedBillsWidget.dart';
import 'package:flutter_front_end/widgets/rawBillWidget.dart';
import 'package:flutter_front_end/widgets/rawPayedBillWidget.dart';
import 'package:flutter_front_end/widgets/residentDrawerWidget.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../wrapper.dart';

class PersonalPaymentHistoryWidget extends StatefulWidget {
  static const routeName = "/PersonalPaymentHistoryWidget";

  @override
  _PersonalPaymentHistoryWidgetState createState() => _PersonalPaymentHistoryWidgetState();
}

class _PersonalPaymentHistoryWidgetState extends State<PersonalPaymentHistoryWidget> {

  int price = 0;
  String billType = "";
  int residentsNumber = 0;
  int businessOwnersNumber = 0;

  String dropdownString = "Water";

  List<dynamic> buildingAddress = [];
  String managerID = "a";
  bool asyncDone = false;
  String userName = "";

  List<dynamic> payedBills = [];
  List<dynamic> alreadyPayedBills = [];

  String role = "";
  Widget drawer;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    final user = Provider.of<User>(context);

    var currentDoc =
    Firestore.instance.collection('additionalinfo').document(user.uid);

    await currentDoc.get().then((value) {
      buildingAddress = value['address'].sublist(2, value['address'].length);
      role = value['role'];
    });
    
    if(role == "Resident" || role == "Business Owner"){
      drawer = ResidentDrawerWidget();
    } else {
      drawer = BuildingManagerWidget();
    }
    
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
    return Scaffold(
      backgroundColor: Color(0xFFC8A2C8),
      appBar: AppBar(
        title: Text("Personal Payments History"),
        backgroundColor: Color(0xFF852DCE),
        elevation: 0.0,
      ),
      drawer: drawer,
      body: Column(
        children: <Widget>[
          StreamBuilder(
              stream: Firestore.instance
                  .collection('bills/' + managerID + '/payedbills')
                  .snapshots(),
              builder: (ctx, streamSnapshot) {
                print(streamSnapshot.connectionState);
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Loading(),
                  );
                }

                final documents = streamSnapshot.data.documents;

                print("Docs");
                print(documents);

                var visibleDocs = [...documents];

                documents.forEach((el) {
                  if (!el['verified'] || el['payerName'] != userName) {
                    visibleDocs.remove(el);
                  }
                });

                // TODO manager should receive a message that says "{Name} has payed {Amount} of {Type} bill"
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: visibleDocs.length,
                      itemBuilder: (ctx, index) => Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 2, vertical: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF852DCE),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x99852DCE),
                              spreadRadius: 2,
                              blurRadius: 7, // changes position of shadow
                            ),
                          ],
                        ),
                        child: RawBillWidget(
                            visibleDocs[index]['amountPayed'].toString(),
                            visibleDocs[index]['generationDate'],
                            visibleDocs[index]['type']),
                      )),
                );
              }),
        ],
      ),
    );
  }
}
