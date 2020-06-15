import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference infoCollection = Firestore.instance.collection('additionalinfo');

  Future updateRole(String role, String phoneNumber, String floorNumber, String apartmentNumber) async {
    return await infoCollection.document(uid).setData({
      'role': role,
      'phone_number': phoneNumber,
      'floor_number': floorNumber,
      'apartment_number': apartmentNumber,
    });
  }

  Stream<QuerySnapshot> get role {
    return infoCollection.snapshots();
  }
}