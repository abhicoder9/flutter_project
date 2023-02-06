import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:revamph/resources/storage_methods.dart';

class AuthModels {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up User
  Future<String> signupUser({
    required String fullName,
    required String emailAddress,
    required String passWord,
    required String phoneNumber,
    required String collegeName,
    required String admissionYear,
    Uint8List? image,
    required String passYear,
  }) async {
    String res = 'some error occured';
    try {
      if (fullName.isNotEmpty ||
          emailAddress.isNotEmpty ||
          passWord.isNotEmpty ||
          phoneNumber.isNotEmpty ||
          collegeName.isNotEmpty ||
          admissionYear.isNotEmpty ||
          image != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: emailAddress,
          password: passWord,
        );

        // store image  in firebase storage and clod firestore.

        String photoUrl =
            await StorageMethods().uploadImageToStorage('profilePic', image!);

        await _firestore.collection('users').doc(cred.user!.uid).set({
          'full_name': fullName,
          'email': emailAddress,
          'password': passWord,
          'phone_number': phoneNumber,
          'college_name': collegeName,
          'admission_year': admissionYear,
          'pass_year': passYear,
          'photo_url': photoUrl,
        });
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }
  // login user

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'some error occured';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // Sign Out User

  Future<void> signOutUser() async {
    await _auth.signOut();
  }
}
