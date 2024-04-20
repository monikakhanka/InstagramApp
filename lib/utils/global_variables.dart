import 'package:crypto_wallet/screens/feed_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/add_post_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';

const webScreenSize = 600;   //beyond this the screen will like a web screen

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('notif'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
];