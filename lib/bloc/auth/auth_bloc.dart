import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GoogleSignIn _googleSignIn;

  StreamSubscription _signInSubscription;

  AuthBloc(this._googleSignIn) {
    _signInSubscription = _googleSignIn.onCurrentUserChanged.listen(_onSignIn);
  }

  _onSignIn(GoogleSignInAccount account) {
    if (account == null) {
      dispatch(SignedOutAuthEvent());
    } else {
      dispatch(SignedInAuthEvent(account.email));
    }
  }

  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    var state = currentState;
    if (event is SilentAuthEvent) {
      if (state is InitialAuthState) {
        yield SignedOutAuthState(true);

        await _googleSignIn.signInSilently(suppressErrors: true);
        if (!await _googleSignIn.isSignedIn()) {
          yield SignedOutAuthState(false);
        }
      }
    } else if (event is SignInAuthEvent) {
      if (state is SignedOutAuthState && !state.loading) {
        yield SignedOutAuthState(true);

        try {
          await _googleSignIn.signIn();
          if (!await _googleSignIn.isSignedIn()) {
            yield SignedOutAuthState(false);
          }
        } catch (exception) {
          yield SignedOutAuthState(false);
        }
      }
    } else if (event is SignedInAuthEvent) {
      yield SignedInAuthState(event.email, false);
    } else if (event is SignOutAuthEvent) {
      if (state is SignedInAuthState && !state.loading) {
        yield SignedInAuthState(state.email, true);

        _googleSignIn.disconnect();
      }
    } else if (event is SignedOutAuthEvent) {
      yield SignedOutAuthState(false);
    }
  }

  @override
  void dispose() {
    _signInSubscription.cancel();

    super.dispose();
  }
}
