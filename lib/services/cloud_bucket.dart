import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class CloudBucket{
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask storeFile({required String path, required File file}){
    return _storage.ref().child(path).putFile(file);
  }
}