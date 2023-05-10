import 'package:permission_handler/permission_handler.dart';

class Perms{

  Future<bool> checkPermission(Permission newPerm) async {
    if(await newPerm.isGranted){
      return true;
    }

    //initial value set to false in case user dismissed the permission prompt
    bool isGranted = false;
    await newPerm.request().then((value) {
      isGranted = value.isGranted;
    });

    return isGranted;
  }
}