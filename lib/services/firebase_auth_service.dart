import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream para escutar mudanças no estado de autenticação
  Stream<User?> get user => _auth.authStateChanges();

  // Login com Email e Senha
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      return credential.user;
    } catch (e) {
      print("Erro no login: \$e");
      return null;
    }
  }

  // Deslogar
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
