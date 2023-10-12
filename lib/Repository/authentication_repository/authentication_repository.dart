import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:stormen/Features/authentication/screens/Welcome_Screen/welcome_screen.dart';
import 'package:stormen/Features/dashboard/screens/dashboard_screen.dart';
import 'exceptions/signup_email_password_failure.dart';

class AuthenticationRepository extends GetxController{

  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser ;

  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 2));
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
    
  }

  _setInitialScreen(User? user) {
    user == null ? Get.offAll(()=> WelcomeScreen()) : Get.offAll(()=> DashboardScreen());
  }

  Future<String> createUserWithEmailAndPassword(String email,String password) async {
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;
      firebaseUser.value != null ? Get.offAll(()=> DashboardScreen()) : Get.to(()=> WelcomeScreen());
      return uid;
    } on FirebaseAuthException catch(e){
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    } catch(_){
      final ex = SignUpWithEmailAndPasswordFailure();
      print('EXCEPTION - ${ex.message}');
      throw ex;
    }
  }
  Future<void> loginWithEmailAndPassword(String email,String password) async {
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null ? Get.offAll(()=> DashboardScreen()) : Get.snackbar('Wrong email/Password', 'Check the email or password');
    } on FirebaseAuthException catch(e){
    } catch(_){}
  }

  Future<void> logout() async => await _auth.signOut();

}