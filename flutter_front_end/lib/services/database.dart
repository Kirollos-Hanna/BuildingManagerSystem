import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference roleCollection = Firestore.instance.collection('roles');

  Future updateRole(String role) async {
    return await roleCollection.document(uid).setData({
      'role': role
    });
  }

  Stream<QuerySnapshot> get role {
    return roleCollection.snapshots();
  }
}