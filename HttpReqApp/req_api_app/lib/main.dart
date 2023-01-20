import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:req_api_app/http_networking.dart/firebase_api.dart';
import 'firebase_options.dart';
import 'http_networking.dart/16_networking_http.dart';

void main() async {
  // FIREBASE SINGKRON
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // MAIN METHOD RUN APP
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: materialFirebase(),
    ),
  );
}
