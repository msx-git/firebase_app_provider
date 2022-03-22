import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthSate extends Equatable {
  final AuthStatus authStatus;
  final fb_auth.User? user;

  const AuthSate({
    required this.authStatus,
    this.user,
  });

  factory AuthSate.unknown(){
    return const AuthSate(authStatus: AuthStatus.unknown);
  }

  @override
  bool? get stringify => true;
  @override
  List<Object?> get props => [authStatus, user];

  AuthSate copyWith({
    AuthStatus? authStatus,
    fb_auth.User? user,
  }) {
    return AuthSate(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
    );
  }
}
