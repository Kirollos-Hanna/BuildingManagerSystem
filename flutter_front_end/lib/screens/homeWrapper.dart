import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/User.dart';
import 'package:provider/provider.dart';
import 'home/residentHome.dart';
import 'home/buildingManagerHome.dart';
import 'home/businessOwnerHome.dart';
import 'home/role.dart';
import 'package:flutter_front_end/providers/billsProvider.dart';

class HomeWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    final role = Provider.of<QuerySnapshot>(context);

    String currentRole = '';

    if(role != null) {
      for (var role in role.documents) {
        if (role.documentID == user.uid) {
          currentRole = role.data['role'];
        }
      }
    }

    if(currentRole == "Building Manager"){
      return BuildingManagerHome();
    } else if (currentRole == "Business Owner" || currentRole == "Resident"){
      return ResidentHome();
    } else if (currentRole == "undecided"){
      return Role();
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}