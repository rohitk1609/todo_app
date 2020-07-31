
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/models/user.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  var actualcode;

  User _userFromFirebaseUser(FirebaseUser user){

    return user!=null? User(uid:user.uid,email: user.email,profilepic: user.photoUrl):null;
    
  }


  Stream<User> get user{
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);

  }
  Future<User> signinwithGoogle()async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn(); 
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

    AuthResult result = await _auth.signInWithCredential(credential);
    FirebaseUser user = result.user;
    return _userFromFirebaseUser(user);
  }

  Future<bool> signoutwithGoogle()async{
    await _auth.signOut().then((value){
        googleSignIn.signOut();
        return true;
    });

  }

 

  

  Future signOut() async{
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  
}
