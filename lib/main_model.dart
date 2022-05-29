import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier {
  double lat = 0;
  double lon = 0;
  Future getPosition() async {
    final snapshot = FirebaseFirestore.instance.collection('place').doc('vEHSzDxi8X4FGiNm9tEY');
    final doc = await snapshot.get();
    this.lat = doc.get('lat');
    this.lon = doc.get('lon');
    notifyListeners();
  }

  void getPositionRealTime() {
    final snapshots = FirebaseFirestore.instance.collection('place').doc('vEHSzDxi8X4FGiNm9tEY').snapshots();
    snapshots.listen((snapshot) {
      this.lat = snapshot.get('lat');
      this.lon = snapshot.get('lon');
      notifyListeners();
    });
  }
}