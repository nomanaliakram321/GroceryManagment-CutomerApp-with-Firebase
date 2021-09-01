import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/models/User_model.dart';

class UserServices {
  String collection = 'users';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // create new user
  Future<void> createUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await _firestore.collection(collection).doc(id).set(values);
  }

  //Update User Data
  Future<void> updateUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await _firestore.collection(collection).doc(id).update(values);
  }

  //get user data by user id
  Future<DocumentSnapshot> getUserById(String id) async {
    var result = await _firestore.collection(collection).doc(id).get();
    return result;
  }
}
