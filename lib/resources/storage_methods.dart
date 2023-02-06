import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  PlatformFile? resume;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // adding image to firebase
  Future<String> uploadImageToStorage(String childName, Uint8List image) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    UploadTask uploadImage = ref.putData(image);

    TaskSnapshot snapImage = await uploadImage;

    String downloadImageUrl = await snapImage.ref.getDownloadURL();

    return downloadImageUrl;
  }
}
