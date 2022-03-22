import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_app_provider/providers/auth/auth_state.dart';
import 'package:firebase_app_provider/repositories/auth_repository.dart';


class AuthProvider with ChangeNotifier {
  AuthSate _sate = AuthSate.unknown();

  AuthSate get state => _sate;

  final AuthRepository authRepository;
  AuthProvider({
    required this.authRepository,
  });

  void update(fb_auth.User? user){
    if(user != null){
      _sate = _sate.copyWith(
        authStatus: AuthStatus.authenticated,
        user: user,
      );
    } else{
      _sate = _sate.copyWith(authStatus: AuthStatus.unauthenticated);
    }
    notifyListeners();
  }

  void signout() async {
    await authRepository.signout();
  }

}
