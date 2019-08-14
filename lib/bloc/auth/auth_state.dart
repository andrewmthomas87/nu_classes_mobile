import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthState extends Equatable {
  AuthState([List props = const []]) : super(props);
}

class InitialAuthState extends AuthState {}

class SignedOutAuthState extends AuthState {
  final bool loading;

  SignedOutAuthState(this.loading) : super([loading]);
}

class SignedInAuthState extends AuthState {
  final String email;
  final bool loading;

  SignedInAuthState(this.email, this.loading) : super([email, loading]);
}
