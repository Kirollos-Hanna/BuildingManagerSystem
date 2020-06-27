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
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingManagerHome extends StatefulWidget {
  static const routeName = "/BuildingManagerHome";

  @override
  _BuildingManagerHomeState createState() => _BuildingManagerHomeState();
}

class _BuildingManagerHomeState extends State<BuildingManagerHome> {
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
//    final FirebaseUser user = await FirebaseAuth.instance.currentUser();

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
    // TODO make the manager specify the number of residents in the building along with the number of business owners

    return !asyncDone
        ? Loading()
        : Scaffold(
            backgroundColor: Color(0xFFC8A2C8),
            appBar: AppBar(
              title: Text("Home Page"),
              backgroundColor: Color(0xFF852DCE),
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('logout'),
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.of(context).pushReplacementNamed(Login.routeName);
                  },
                ),
              ],
            ),
            drawer: BuildingManagerWidget(),
            body: Center(
              child: Text(
                "Welcome " + userName,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                ),
              ),
            ),
          );
  }
}
