import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<UserCredential> firebaseSignIn(BuildContext context,
    {String email, String password, void errorFunc()}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential userCredential;
  try {
    userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
  } on PlatformException catch (error) {
    showSnackBar(context: context, text: error.message);
    errorFunc();
  } on Exception catch (error) {
    print(error);
  }

  return userCredential;
}

Future<void> signIn(BuildContext context,
    {String email, String password, void errorFunc()}) async {
  firebaseSignIn(context,
          email: email, password: password, errorFunc: errorFunc)
      .then((result) {
    if (result != null) {
      Navigator.pushReplacementNamed(context, 'signup');
    } else
      Navigator.pushReplacementNamed(context, 'inventory');
  });
}

Future<UserCredential> firebaseSignUp(BuildContext context,
    {String email, String password, void errorFunc()}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential userCredential;
  try {
    userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
  } on PlatformException catch (error) {
    showSnackBar(context: context, text: error.message);
    errorFunc();
  } on Exception catch (error) {
    print(error);
  }

  return userCredential;
}

Future<void> signUp(BuildContext context,
    {String email, String password, void errorFunc()}) async {
  firebaseSignUp(context,
          email: email, password: password, errorFunc: errorFunc)
      .then((result) {
    if (result != null) {
      Navigator.pushNamed(context, 'userdetails');
    }
  });
}

void showSnackBar({BuildContext context, String text}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text,
        style: Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(color: Colors.white)),
    elevation: 4,
    behavior: SnackBarBehavior.floating,
  ));
}

SnackBar snackBar({Widget content}) {
  return SnackBar(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    content: content,
    duration: Duration(seconds: 10),
    elevation: 10,
  );
}

Future<void> checkUser(BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  // auth.signOut();
  User user = auth.currentUser;

  if (user != null) {
    Navigator.pushReplacementNamed(context, 'signup');
  }
}
