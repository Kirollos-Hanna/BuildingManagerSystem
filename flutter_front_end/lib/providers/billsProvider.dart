import 'package:flutter/material.dart';

class BillsProvider with ChangeNotifier {
  List<dynamic> _items = [];

  List<dynamic> get items {
    return [..._items];
  }

  void dummyFunction(){
    notifyListeners();
  }
}