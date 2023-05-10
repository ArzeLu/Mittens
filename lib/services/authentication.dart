import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  User? get currentUser => _authInstance.currentUser;

  Stream<User?> get authState => _authInstance.authStateChanges();

  String getUserID(){
    return currentUser!.uid;
  }

  Future<String?> signUp(
      {required String email, required String password}) async {
    try {
      await _authInstance.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }

  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _authInstance.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if(e.code == "invalid-email"){
        return "Note: the email is invalid";
      }else if(e.code == "user-disabled"){
        return "Note: the user is disabled";
      }else if(e.code == "user-not-found"){
        return "Note: the user is not found";
      }else if(e.code == "wrong-password"){
        return "Note: the password is incorrect";
      }
    }
    return null;
  }

  Future<void> signOut() async {
    await _authInstance.signOut();
  }
}
