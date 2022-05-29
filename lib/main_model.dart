import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier {
  double lon = 0;
  double lat = 0;

  Future getPosition() async {
    final snapshot = FirebaseFirestore.instance.collection('place').doc('vEHSzDxi8X4FGiNm9tEY');
    final doc = await snapshot.get();
    this.lat = doc.get('lat');
    this.lon = doc.get('lon');
    notifyListeners();
  }
}