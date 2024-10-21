import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawprints/models/users/users.dart';

const USERS_COLLECTION = "users";

class AuthService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  AuthService({
    FirebaseFirestore? firebaseFirestore,
    FirebaseAuth? firebaseAuth,
  })  : firestore = firebaseFirestore ?? FirebaseFirestore.instance,
        auth = firebaseAuth ?? FirebaseAuth.instance;
  Future<Users?> register(
      {required String name,
      required String email,
      required String password}) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      Users newUser = Users(
        id: result.user!.uid,
        name: name,
        email: email,
        phone: '',
        profile: '',
      );
      await firestore
          .collection('users')
          .doc(result.user!.uid)
          .set(newUser.toJson());

      return newUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Users?> login(
      {required String email, required String password}) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _getUserFromFirebase(result.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Get User from Firestore
  Future<Users?> getUser() async {
    try {
      User? user = auth.currentUser;
      if (user == null) {
        return null;
      }
      DocumentSnapshot doc =
          await firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return Users.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Helper function to convert Firebase user to custom User model
  Future<Users?> _getUserFromFirebase(User? firebaseUser) async {
    return getUser();
  }

  Stream<User?> authStateChanges() {
    return auth.authStateChanges();
  }
}
