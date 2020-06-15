import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/User.dart';
import 'package:flutter_front_end/screens/home/propertyOwnerHome.dart';
import 'package:provider/provider.dart';
import 'home/home.dart';
import 'authenticate/authenticate.dart';
import 'home/renterHome.dart';
import 'home/role.dart';

class HomeWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    final role = Provider.of<QuerySnapshot>(context);

    String currentRole = '';

    print(role.documents);
    for(var role in role.documents){
      if(role.documentID == user.uid){
        currentRole = role.data['role'];
      }
    }
    print("user id");
    print(user.uid);
//      print(role.documents);

//  return Text("homeWrapper");
    // return either home or autheticate widget
    if(currentRole == "undecided"){
      return Role();
    } else if (currentRole == "Property Owner"){
      return PropertyOwnerHome();
    } else {
      return RenterHome();
    }
  }
}