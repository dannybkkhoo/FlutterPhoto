import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreStorage {
  final _dbRef = FirebaseFirestore.instance;

  Future<bool> writeData(String col, String doc, String col1, String doc1, Map<String,dynamic> data) async {
    try {
      await _dbRef.collection(col).doc(doc).collection(col1).doc(doc1).set(data);
    } on Exception catch (e) {
      print(e);
      return false;
    }
    print("Document created in " + col + "/" + doc + "/" + col1 + "/" + doc1);
    return true;
  }

  Future<Map<String,dynamic>?> readData(String col, String doc, String col1, String doc1) async {
    try {
      final result = await _dbRef.collection(col).doc(doc).collection(col1).doc(doc1).get();
      return result.data();
    } on Exception catch (e) {
      return null;
    }
  }
}