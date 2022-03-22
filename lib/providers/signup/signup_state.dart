import 'package:equatable/equatable.dart';
import 'package:firebase_app_provider/models/custom_error.dart';

enum SignupStatus {
  initial,
  submitting,
  success,
  error,
}

class SignupState extends Equatable {
  final SignupStatus signupStatus;
  final CustomError error;

  const SignupState({
    required this.signupStatus,
    required this.error,
  });

  factory SignupState.initial() {
    return const SignupState(
      signupStatus: SignupStatus.initial,
      error: CustomError(),
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [signupStatus, error];

  SignupState copyWith({
    SignupStatus? signupStatus,
    CustomError? error,
  }) {
    return SignupState(
      signupStatus: signupStatus ?? this.signupStatus,
      error: error ?? this.error,
    );
  }
}
