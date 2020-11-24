import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String userName;
String userEmail;
String userImageUrl;
String uid;
String phone;
bool admin;

Future<String> signInWithGoogle(ctx) async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final authResult = await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final User currentUser =  _auth.currentUser;
  assert(user.uid == currentUser.uid);

  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoURL != null);

  userName = user.displayName;
  userEmail = user.email;
  userImageUrl = user.photoURL;
  uid = user.uid;
  admin = false;
  phone = '';

  if (user != null) {
    // Check is already sign up
    final QuerySnapshot result =  await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: user.uid).get();
    final List <DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      // Update data to server if new user
      FirebaseFirestore.instance.collection('users').doc(user.uid).set(
          { 'username': userName, 'photoUrl': userImageUrl, 'id': user.uid, 'email': userEmail, 'phone': '', 'admin': false});
    }
    else{
      phone = documents[0]['phone'];
      admin = documents[0]['admin'];
    }
  }
  print('Signed in with Google: $userEmail');
  return "Signed In";
}

void signOut() async{
  await _auth.signOut();
  await googleSignIn.signOut();
  userEmail=null;
  userName=null;
  userImageUrl=null;
  uid = null;
  print("User Sign Out");
}

Future<String> currentUser() async {
  return _auth.currentUser.uid;
}