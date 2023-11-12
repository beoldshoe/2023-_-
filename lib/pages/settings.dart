import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  User? user;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정 페이지'),
      ),
      body: Center(
        child: user == null
            ? ElevatedButton(
              child: Text('Google Account Login'),
              onPressed: signInWithGoogle,
            )
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('환영합니다, ${user!.displayName}님!'),
                ElevatedButton(
                  child: Text('로그아웃'),
                  onPressed: signOut,
                ),
              ],
            ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // 사용자 정보를 Firestore에 저장
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
    await usersCollection.doc(userCredential.user!.uid).set({
      'email': userCredential.user!.email,
      'name': userCredential.user!.displayName,
    });

    setState(() {
      user = userCredential.user;
    });
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();

    setState(() {
      user = null;
    });
  }
}
