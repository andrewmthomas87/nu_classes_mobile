import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'bloc/blocs.dart';

void main() {
  final googleSignIn = GoogleSignIn(scopes: ['email']);
  final authBloc = AuthBloc(googleSignIn);

  authBloc.dispatch(SilentAuthEvent());

  runApp(BlocProvider(
    builder: (context) => authBloc,
    child: App(),
  ));
}

var theme = ThemeData(
  primaryColor: Color.fromARGB(255, 78, 42, 132),
  primaryColorDark: Color.fromARGB(255, 29, 0, 86),
  primaryColorLight: Color.fromARGB(255, 126, 85, 180),
);

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return BlocBuilder(
      bloc: authBloc,
      builder: (BuildContext context, AuthState state) {
        var content;
        if (state is InitialAuthState) {
          content = Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is SignedOutAuthState) {
          content = SignedOut();
        } else if (state is SignedInAuthState) {
          content = SignedIn();
        }

        return MaterialApp(
          title: "Northwestern",
          theme: theme,
          home: content,
        );
      },
    );
  }
}

class SignedOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in"),
      ),
      body: Center(
        child: BlocBuilder(
          bloc: authBloc,
          builder: (BuildContext context, AuthState state) {
            if (state is! SignedOutAuthState) {
              return Container();
            }

            if ((state as SignedOutAuthState).loading) {
              return CircularProgressIndicator();
            } else {
              return RaisedButton(
                child: Text("Sign in"),
                onPressed: () => authBloc.dispatch(SignInAuthEvent()),
              );
            }
          },
        ),
      ),
    );
  }
}

class SignedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: BlocBuilder(
          bloc: authBloc,
          builder: (BuildContext context, AuthState state) {
            if (state is! SignedInAuthState) {
              return Container();
            }

            if ((state as SignedInAuthState).loading) {
              return CircularProgressIndicator();
            } else {
              return RaisedButton(
                child: Text("Sign out"),
                onPressed: () => authBloc.dispatch(SignOutAuthEvent()),
              );
            }
          },
        ),
      ),
    );
  }
}
