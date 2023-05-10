import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileSystem{
  Future<String> getAppDocPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> getTempPath() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  //Copies a file and returns the final file with
  Future<File> copyFile({required String oldPath, required String newFileName, bool deleteOldVersion = true}) async {
    String appDocPath = await getAppDocPath();
    appDocPath = "$appDocPath/$newFileName";
    File oldFile = File(oldPath);
    File result = await oldFile.copy(appDocPath);
    oldFile.delete();

    return result;
  }
  
  Future<void> clearCache() async {
    final directory = await getTemporaryDirectory();
    Directory(directory.path).delete(recursive: true);
  }
}