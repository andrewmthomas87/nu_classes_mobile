import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent extends Equatable {
  AuthEvent([List props = const []]) : super(props);
}

class SilentAuthEvent extends AuthEvent {}

class SignInAuthEvent extends AuthEvent {}

class SignedInAuthEvent extends AuthEvent {
  final String email;

  SignedInAuthEvent(this.email) : super([email]);
}

class SignOutAuthEvent extends AuthEvent {}

class SignedOutAuthEvent extends AuthEvent {}
