import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/User.dart';
import 'package:provider/provider.dart';
import 'home/home.dart';
import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    // return either home or autheticate widget
    if(user == null){
      return Authenticate();
    } else {
      return Home();
    }
  }
}


  // void EnterLoginScreen(BuildContext context){
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (_) {
  //       return loginScreen();
  //     }
  //   ));
  // }