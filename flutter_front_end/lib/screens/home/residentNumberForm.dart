import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_front_end/models/User.dart';
import 'package:flutter_front_end/widgets/buildingManagerWidget.dart';
import 'package:provider/provider.dart';

class ResidentNumberForm extends StatefulWidget {
  static const routeName = "/ResidentNumberForm";

  @override
  _ResidentNumberFormState createState() => _ResidentNumberFormState();
}

class _ResidentNumberFormState extends State<ResidentNumberForm> {
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

  String billSubmittedStr = "";

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
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text("Bill Form"),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
      ),
      drawer: BuildingManagerWidget(),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: new InputDecoration(
                labelText: "Enter number of normal residents"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            onChanged: (val) {
              setState(() {
                residentsNumber = int.parse(val);
              });
            },
          ),
          TextField(
            decoration: new InputDecoration(
                labelText: "Enter number of business owners"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            onChanged: (val) {
              setState(() {
                businessOwnersNumber = int.parse(val);
              });
            },
          ),
          RaisedButton(
            color: Colors.pink[400],
            child: Text(
              "Submit Total",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              CollectionReference residentsCollection =
              Firestore.instance.collection('/residents');

              residentsCollection.document(managerID).setData({
                "residents": residentsNumber,
                "businessOwners": businessOwnersNumber
              });
            },
          ),
        ],
      ),
    );
  }
}
