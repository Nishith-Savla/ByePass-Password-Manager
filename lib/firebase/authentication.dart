import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  late final FirebaseAuth _firebaseAuth;
  late final FirebaseFirestore _firebaseFirestore;

  Authentication(
      {FirebaseAuth? firebaseAuth, FirebaseFirestore? firebaseFirestore}) {
    _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
    _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String?> addUserWithEmailAndPassword(
      {required String email,
      required String password,
      required String collectionPath,
      String? name}) async {
    late final AuthenticationResult authResult;
    authResult =
        await createUserWithEmailAndPassword(email: email, password: password);
    if (authResult.error != null && authResult.error!.isNotEmpty) {
      return authResult.error;
    }
    if (authResult.userCredential == null) return null;

    final data = <String, dynamic>{'email': email};
    data['createdAt'] =
        authResult.userCredential!.user?.metadata.creationTime ??
            FieldValue.serverTimestamp();
    if (name != null) data['name'] = name;
    _firebaseFirestore
        .collection(collectionPath)
        .doc(authResult.userCredential!.user!.uid)
        .set({...data});
  }

  Future<AuthenticationResult> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential? userCredential;
    String? error;
    try {
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password provided for that user.';
      }
    } catch (e) {
      error = e.toString();
    }
    return AuthenticationResult(userCredential: userCredential, error: error);
  }

  Future<AuthenticationResult> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential? userCredential;
    String? error;
    try {
      userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        error = 'The account already exists for that email.';
      } else {
        error = e.toString();
      }
    } catch (e) {
      error = e.toString();
    }
    return AuthenticationResult(userCredential: userCredential, error: error);
  }

  Future<void> sendEmailVerification(User? user) async {
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> verifyCurrentUser() async {
    User? user = _firebaseAuth.currentUser;
    await sendEmailVerification(user);
  }
}

class AuthenticationResult {
  UserCredential? userCredential;
  String? error;

  AuthenticationResult({required this.userCredential, this.error});

  factory AuthenticationResult.fromJson(Map<String, dynamic> json) {
    return AuthenticationResult(
      userCredential: json['userCredential'],
      error: json['error'],
    );
  }
}
