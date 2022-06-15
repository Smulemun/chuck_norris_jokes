import 'dart:async';

import 'package:chuck_jokes/ui/joke_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'logic/consts.dart';
import 'logic/firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp(
    name: 'Tinder with Chuck',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chuck Norris Jokes',
      theme: ThemeData.dark(),
      home: FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            db = FirebaseDatabase.instanceFor(app: snapshot.data as FirebaseApp)
                .ref('favourites');
            FlutterError.onError =
                FirebaseCrashlytics.instance.recordFlutterFatalError;
            return JokesScreen(fbApp: snapshot.data as FirebaseApp);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
