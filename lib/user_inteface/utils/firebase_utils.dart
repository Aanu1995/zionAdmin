import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseUtils {
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static Firestore get firestore => Firestore.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;

  // database collection and document name
  // do not change, this will affect the backend
  static String get admin => 'admin';
  static String get profileImages => 'profileImages';
  static String get profileURL => 'profileURL';
  static String get phone => 'phone';
  static String get address => 'address';
  static String get group => 'group';
  static String get groups => 'groups';
  static String get oneone => 'oneone';
  static String get messages => 'messages';

  // collections and documents for notification
  static String get notification => 'notification';

  // documents and collections (firebase) for chats
  static String get chats => "chats";
  static String get user => 'user';

  // this returns string result to data submitted to backend
  // results could be success or error
  static String get success => 'success';
  static String get error => 'Unknown error occured. Please try again!';
}
