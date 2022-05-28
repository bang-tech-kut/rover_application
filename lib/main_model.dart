import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier {
  double lon = 0;
  double lat = 0;

  Future getPosition() async {
    final snapshot = await FirebaseFirestore.instance.collection('place').get();
    final docs = snapshot.docs;
    this.lat = docs.lat;
    this.lon = docs.lon;
    notifyListeners();
  }
}