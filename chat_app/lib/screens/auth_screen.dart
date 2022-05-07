import 'dart:io';

import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    File userImageFile,
    bool isLogin,
  ) async {
    setState(() {
      _isLoading = true;
    });

    UserCredential userCredential;
    try {
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Could not create user.'),
            backgroundColor: Theme.of(context).errorColor,
          ));

          return;
        }

        await FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}.jpg')
            .putFile(userImageFile);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(
          {
            'username': username,
            'email': email,
          },
        );
        print('username and email stored in firestore');
      }
    } on FirebaseAuthException catch (err) {
      var message = 'An error occurred, please check your credentials.';

      if (err.message != null) {
        message = err.message!;
      } else {
        print({'Firebase auth failed without error message', err});
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print({'in auth failure catch-all', err});
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
