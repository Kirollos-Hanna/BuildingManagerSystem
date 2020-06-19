import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_front_end/models/Bill.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference infoCollection = Firestore.instance.collection('additionalinfo');
  final CollectionReference billCollection = Firestore.instance.collection('bills');
  final CollectionReference reportCollection = Firestore.instance.collection('reports');
  final CollectionReference notificationCollection = Firestore.instance.collection('notifications');

  Future updateRole(String name, String role, String phoneNumber, String floorNumber, String apartmentNumber, bool occupied, var address) async {
    return await infoCollection.document(uid).setData({
      'name': name,
      'role': role,
      'phone_number': phoneNumber,
      'floor_number': floorNumber,
      'apartment_number': apartmentNumber,
      'occupied': occupied,
      'address': address,
    });
  }

  Map<String, dynamic> billData(Bill inputBill) {
    Map<String, dynamic> bill = <String, dynamic>{
      'status': inputBill.status,
      'generationDate': inputBill.generationDate,
      'type': inputBill.type,
      'amountDue': inputBill.amountDue,
    };
    return bill;
  }

  Future updateBill(Bill bill) async {
    List<dynamic> bills = [billData(bill)];

//    billCollection.document(uid).get().then((value) {
//      List<dynamic> values = value.data['bills'];
//      bills.add(values.sublist(0, values.length));
//      print(bills);
//    });

    return await billCollection.document(uid).setData({
      'bills': bills,
      });
    print(bill.amountDue);

    return await billCollection.document(uid).setData(await billData(bill));
  }

  Future getBillData() async {
    return billCollection.document(uid).get();
  }

  List<Bill> returnBills(DocumentSnapshot snapshot) {
    return snapshot.data['bills'];
  }

//  Future updateReport(Admin admin, Customer customer, Bill bill, bool paidBill) async {
//    return await reportCollection.document(uid).setData({
//      'admin': admin,
//      'customer': customer,
//      'bill': bill,
//      'bill_paid': paidBill
//    });
//  }
//
//  Future updateNotification(String message, String receiver, String sender, bool seen) async {
//    return await notificationCollection.document(uid).setData({
//      'message': message,
//      'sender': sender,
//      'receiver': receiver,
//      'seen': seen
//    });
//  }

  Stream<QuerySnapshot> get role {
    return infoCollection.snapshots();
  }

  Stream<DocumentSnapshot> get bills {
    return billCollection.document(uid).snapshots();
  }
}