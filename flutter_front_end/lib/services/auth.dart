import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_front_end/models/User.dart';
import 'package:flutter_front_end/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on firebaseUser
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }
  
// sign in using email and password
  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

// register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      FirebaseUser user = result.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateRole("", "undecided", "0", "0", "0", false);

      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

// sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}