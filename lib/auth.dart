import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authstateChanges => _firebaseAuth.authStateChanges();
  
  // ignore: non_constant_identifier_names
  get await_firebaseAuth => null;
  
 
  
  

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async{
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password,
      );
  }
   
   Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
   })async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
      );
   }

   Future<void> signOut() async {
    await _firebaseAuth.signOut();
   }
}