import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

//relative imports
import 'local_file_system.dart';
import 'perms.dart';
import 'cloud_bucket.dart';

class MStore { //not using MediaStore as the name to avoid complications with the media_store_plus plugin
  //Media store is not the official api; from media_store_plus on pub.dev
  final MediaStore _store = MediaStore();
  final CloudBucket _storage = CloudBucket();
  final ImagePicker _imagePicker = ImagePicker();
  final LocalFileSystem _fileSystem = LocalFileSystem();
  final Perms _permsHandler = Perms();

  MStore() {
    //Exception would be thrown if folder name is not set
    MediaStore.appFolder = "Mittens";
  }

  Future<bool> setProfilePicture() async {
    bool isGranted = await _permsHandler.checkPermission(Permission.photos);
    bool isSaved = false;

    if (!isGranted) {
      return false;
    }

    XFile? originalImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (originalImage != null) {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
          sourcePath: originalImage.path,
          cropStyle: CropStyle.circle,
          compressQuality: 50,
          compressFormat: ImageCompressFormat.jpg);

      //Terminate in case the user backs out of the cropping process.
      if (croppedImage != null) {
        File finalImage = await _fileSystem.copyFile(oldPath: croppedImage.path, newFileName: "profile.jpg");

        //Put the picture on the cloud then save. The MediaStore plugin deletes the original photo after saving.
        _storage.storeFile(path: "profile_picture/profile.jpg", file: finalImage);

        //needed to capture the value of the saveFile method to stop threads from prematurely bypassing this procedure.
        isSaved = await _store.saveFile(tempFilePath: finalImage.path, dirType: DirType.photo, dirName: DirType.photo.defaults);
      }
    }

    _fileSystem.clearCache();
    return isSaved;
  }

  //Making return type nullable in case of, for example, the user manually deleting the photo from MediaStore.
  //This method will check if the file exists in the firebase cloud storage before returning null.
  File? getImage({required String fileName}) {
    File image = File("${DirType.photo.fullPath(relativePath: MediaStore.appFolder, dirName: DirType.photo.defaults)}/$fileName");
    return image.existsSync() ? image : null;
  }

  //See if an image exists in the local MediaStore db
  bool ifImageExists({required String fileName}){
    return File(DirType.photo.fullPath(relativePath: MediaStore.appFolder, dirName: DirType.photo.defaults)).existsSync();
  }
}