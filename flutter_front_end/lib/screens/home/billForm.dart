import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/User.dart';
import 'package:flutter_front_end/widgets/buildingManagerWidget.dart';
import 'package:provider/provider.dart';

class BillForm extends StatefulWidget {
  static const routeName = "/BillForm";

  @override
  _BillFormState createState() => _BillFormState();
}

class _BillFormState extends State<BillForm> {
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
      backgroundColor: Color(0xFFC8A2C8),
      appBar: AppBar(
        title: Text("Bill Form"),
        backgroundColor: Color(0xFF852DCE),
        elevation: 0.0,
      ),
      drawer: BuildingManagerWidget(),
      body: Column(
        children: <Widget>[
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

          Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(

              validator: (val) => val.isEmpty ? 'Enter a price' : null,
              decoration: InputDecoration(hintText: "Bill price to be paid"),
              onChanged: (val) {
                setState(() {
                  price = int.parse(val);
                });
              },
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          RaisedButton(
            color: Color(0xFF852DCE),
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

              Firestore.instance
                  .collection('bills/' + managerID + '/bills')
                  .add({
                "status": 'unpaid',
                "amountPaid": 0.0,
                "generationDate": date,
                "type": billType,
                "amountDue": price
              });
              setState(() {
                billSubmittedStr = "Bill submitted successfully";
              });
            },
          ),
          Text(billSubmittedStr),
        ],
      ),
    );
  }
}
