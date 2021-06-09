import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '/screens/tab_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/welcome_screen1.dart';
import 'screens/welcome_screen2.dart';
import './screens/chat_screen.dart';

import './theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'GV Chat',
            theme: darkThemeData(context),
            debugShowCheckedModeBanner: false,
            home: snapshot.connectionState != ConnectionState.done
                ? WelcomeScreen1()
                : StreamBuilder(
                    initialData: WelcomeScreen1(),
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (BuildContext ctx, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return WelcomeScreen1();
                      }
                      if (userSnapshot.hasData) {
                        if (Navigator.of(ctx).canPop()) {
                          Navigator.of(ctx).pop();
                        }
                        return TabScreen();
                      }
                      return WelcomeScreen2();
                    },
                  ),
            routes: {
              LoginScreen.routeName: (ctx) => LoginScreen(),
              SignupScreen.routeName: (ctx) => SignupScreen(),
              ChatScreen.routeName: (ctx) => ChatScreen(),
            },
          );
        });
  }
}
