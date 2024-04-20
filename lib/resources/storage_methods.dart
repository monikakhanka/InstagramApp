import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods{

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //adding image (profile or post) to firebase storage
    Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {

    //reference to the folder
    Reference ref =  _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if(isPost){
      String id = const Uuid().v1();
      ref = ref.child(id);
    }
    //upload the file in the ref location
    UploadTask uploadTask =  ref.putData(file);

    //take a snapshot of uplaod
     TaskSnapshot snap = await uploadTask;

     //url which can be used to display image to all other users
     String downloadUrl = await snap.ref.getDownloadURL();
     return downloadUrl;
    }
}