import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LocalFileSystem{
  Future<String> getAppDocPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> getTempPath() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  //Copies a file onto a new custom path, then returns the same file with a new path and a new object
  Future<File> copyFile({required String oldPath, required String newFileName, bool deleteOldVersion = true}) async {
    String appDocPath = await getAppDocPath();
    appDocPath = "$appDocPath/$newFileName";
    File oldFile = File(oldPath);
    File result = await oldFile.copy(appDocPath); //copy the old file onto the new path
    oldFile.delete();

    return result;
  }
  
  Future<void> clearCache() async {
    final directory = await getTemporaryDirectory();
    Directory(directory.path).delete(recursive: true);
  }
}