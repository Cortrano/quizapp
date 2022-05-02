import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizapp/services/auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const FlutterLogo(size: 150),
          Flexible(
            child: LoginButton(
              icon: FontAwesomeIcons.userNinja,
              text: 'Continue as Guest',
              loginMethod: AuthService().anonymousLogin,
              color: Colors.deepPurple,
            ),
          ),
          LoginButton(
              icon: FontAwesomeIcons.google,
              text: 'Sign in with Google',
              loginMethod: AuthService().googleLogin,
              color: Colors.blue,
            ),
        ],
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function() loginMethod;
  const LoginButton({
    Key? key,
    required this.color,
    required this.icon,
    required this.text,
    required this.loginMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: loginMethod,
      icon: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
      label: Text(text),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(24),
        backgroundColor: color,
      ),
    );
  }
}
