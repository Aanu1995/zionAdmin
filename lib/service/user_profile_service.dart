import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/user_inteface/components/custom_dialogs.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';

class UserProfileService {
  static get initialData => UserProfile(
        name: "Anonymous",
        email: "example@gmail.com",
        phoneNumber: '08132363398',
        profileURL: "",
        address: "my address is in Nigeria",
      );
  // stream of user profile date
  StreamController<UserProfile> userProfileStreamController =
      StreamController.broadcast();

  // fetch user data from the server
  void fetchUserData() async {
    try {
      final user = await FirebaseUtils.auth.currentUser(); // get current user
      final documentSnapshot = await FirebaseUtils.firestore
          .collection(FirebaseUtils.admin)
          .document(user.uid)
          .get();
      if (documentSnapshot != null) {
        final userProfile = UserProfile.fromMap(map: documentSnapshot.data);
        userProfileStreamController.add(userProfile); // add data to stream
      }
    } catch (e) {
      print(e);
    }
  }

// displose the stream
  void dispose() {
    userProfileStreamController.close();
  }

  // upload user profile to the server
  Future<String> uploadImage(final imageFile) async {
    try {
      // gets userid
      final user = await FirebaseUtils.auth.currentUser();
      // sent images to firebase storage
      final storageReference = FirebaseUtils.storage
          .ref()
          .child(FirebaseUtils.profileImages)
          .child(user.uid)
          .child("profile.jpg");
      StorageUploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.onComplete;
      final String url = await storageReference.getDownloadURL();
      if (url != null) {
        // update the profile url in cloud firestore
        await FirebaseUtils.firestore
            .collection(FirebaseUtils.admin)
            .document(user.uid)
            .updateData({FirebaseUtils.profileURL: url});
        // calls the function that gets user details data from server
        fetchUserData();
        // return profile url
        return url;
      } else {
        // returns error
        return FirebaseUtils.error;
      }
    } catch (e) {
      // returns error
      return FirebaseUtils.error;
    }
  }

// delete user's profile image
  deleteProfileImage() async {
    try {
      // gets userid
      final user = await FirebaseUtils.auth.currentUser();
      // delete user data from the server
      await FirebaseUtils.firestore
          .collection(FirebaseUtils.admin)
          .document(user.uid)
          .updateData({FirebaseUtils.profileURL: ''});
      // calls the function that gets user details data from server
      fetchUserData();
      return "";
    } catch (e) {
      // returns error
      return FirebaseUtils.error;
    }
  }

  // edit user address
  editAddress(String address, context) async {
    try {
      // gets userid
      final user = await FirebaseUtils.auth.currentUser();
      // delete user data from the server
      await FirebaseUtils.firestore
          .collection(FirebaseUtils.admin)
          .document(user.uid)
          .updateData({FirebaseUtils.address: address});
      // calls the function that gets user details data from server
      fetchUserData();
    } catch (e) {
      // returns error
      CustomDialogs.showErroDialog(context, FirebaseUtils.error);
    }
  }

  // edit user address
  editPhone(String phone, context) async {
    try {
      // gets userid
      final user = await FirebaseUtils.auth.currentUser();
      // delete user data from the server
      await FirebaseUtils.firestore
          .collection(FirebaseUtils.admin)
          .document(user.uid)
          .updateData({FirebaseUtils.phone: phone});
      // calls the function that gets user details data from server
      fetchUserData();
    } catch (e) {
      // returns error
      CustomDialogs.showErroDialog(context, FirebaseUtils.error);
    }
  }

  static setOnlineStatus() async {
    try {
      // gets userid
      final user = await FirebaseUtils.auth.currentUser();
      if (user != null) {
        FirebaseDatabase.instance
            .reference()
            .child("/admin/" + user.uid)
            .onDisconnect()
            .set("offline");

        FirebaseDatabase.instance
            .reference()
            .child("/admin/" + user.uid)
            .set("online");
      }
    } catch (e) {
      print(e);
    }
  }

  static setUserOnline() async {
    try {
      // gets userid
      final user = await FirebaseUtils.auth.currentUser();
      if (user != null) {
        await FirebaseUtils.firestore
            .collection(FirebaseUtils.admin)
            .document(user.uid)
            .updateData({
          'online': true,
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
