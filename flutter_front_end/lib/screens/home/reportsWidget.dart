import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/constants/loading.dart';
import 'package:flutter_front_end/models/User.dart';
import 'package:flutter_front_end/services/auth.dart';
import 'package:flutter_front_end/widgets/buildingManagerWidget.dart';
import 'package:flutter_front_end/widgets/payedBillsWidget.dart';
import 'package:provider/provider.dart';

class ReportsWidget extends StatefulWidget {
  static const routeName = "/ReportsWidget";

  @override
  _ReportsWidgetState createState() => _ReportsWidgetState();
}

class _ReportsWidgetState extends State<ReportsWidget> {
  final AuthService _auth = AuthService();

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
    return Scaffold(
      backgroundColor: Color(0xFFC8A2C8),
      appBar: AppBar(
        title: Text("Reports"),
        backgroundColor: Color(0xFF852DCE),
        elevation: 0.0,
      ),
      drawer: BuildingManagerWidget(),
      body: Column(
        children: <Widget>[
          Text("Reports"),
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

//                        print("Bills");
//                        print(alreadyPayedBills);
                documents.forEach((el) {
                  if (el['verified']) {
                    visibleDocs.remove(el);
                  }
                });

                Future<void> verifyPaidBills(String documentID, String billID,
                    String amountPayed) async {
                  // if manager verifies the message, subtract amount payed from original bill
                  double amountDifference = 0.0;
                  double amountDue = 0.0;
                  await Firestore.instance
                      .collection('bills/' + managerID + '/bills')
                      .document(billID)
                      .get()
                      .then((value) {
                    amountDue = value['amountDue'].toDouble();
                    amountDifference =
                        value['amountPaid'] + double.parse(amountPayed);
                  });

                  // if amountDue of a bill = 0, then it's status becomes = paid
                  if (amountDifference >= amountDue) {
                    await Firestore.instance
                        .collection('bills/' + managerID + '/bills')
                        .document(billID)
                        .updateData(
                            {'amountPaid': amountDifference, 'status': "paid"});
                  } else {
                    await Firestore.instance
                        .collection('bills/' + managerID + '/bills')
                        .document(billID)
                        .updateData({'amountPaid': amountDifference});
                  }

                  await Firestore.instance
                      .collection('bills/' + managerID + '/payedbills')
                      .document(documentID)
                      .updateData({"verified": true});
                }

                Future<void> doNotVerifyPaidBills(String documentID) async {
                  // Delete bill document from payedBills
                  await Firestore.instance
                      .collection('bills/' + managerID + '/payedbills')
                      .document(documentID)
                      .delete();
                }

                // TODO manager should receive a message that says "{Name} has payed {Amount} of {Type} bill"
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: visibleDocs.length,
                    itemBuilder: (ctx, index) => Container(
                          child: PayedBillsWidget(
                              visibleDocs[index].documentID,
                              visibleDocs[index]['amountPayed'].toString(),
                              visibleDocs[index]['generationDate'],
                              visibleDocs[index]['type'],
                              visibleDocs[index]['payerName'],
                              visibleDocs[index]['billID'],
                              verifyPaidBills,
                              doNotVerifyPaidBills),
                        ));
              }),
        ],
      ),
    );
  }
}
