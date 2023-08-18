import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
late Reference ref;

Future<String> upload(File image, String uid)async{
  final String imageName = image.path.split("/").last;
  try {
    ref = _storage.ref().child("publicaciones").child(uid).child(imageName);
  } on Exception catch (e) {
    print(e.toString());
  }
  
  final storageSnapshot = await ref.putFile(image);
  String url = await storageSnapshot.ref.getDownloadURL();

  return url;
}