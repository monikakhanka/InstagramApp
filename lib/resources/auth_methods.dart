
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/models/user.dart' as model;
import 'package:crypto_wallet/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  //get user details
  Future<model.User> getUserDetails() async{
    //User datatype here is related to firebase_auth
    User currentUser = _auth.currentUser!;
    //takes the snapshot of currentuser
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid!).get();
    //returns the User object using the snap
    return model.User.fromSnap(snap);
  }

  //sign up user function
  Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        //register user using auth instance in firebase authentication
        //email and password gets stored in firebase auth and for remaining data firestore is needed
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        //add upload profile picture
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        //add user to firestore
        model.User user = model.User(
          email: email,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          username: username,
          bio: bio,
          followers: [],
          following: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //loggin in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //signout method
Future<void> signOut() async => await _auth.signOut();
}
