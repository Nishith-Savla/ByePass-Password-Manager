import 'package:flutter/material.dart';

import '../utils.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

extension Validator on String {
  bool isValidEmail() => RegExp(emailRegex).hasMatch(this);

  String? validatePassword() {
    final _errorMessage = StringBuffer();

    if (length < 8) {
      _errorMessage.write(' • minimum 8 characters\n');
    }
    if (!RegExp(r'[a-z]').hasMatch(this)) {
      _errorMessage.write(' • at least 1 lowercase letter\n');
    }
    if (!RegExp(r'[A-Z]').hasMatch(this)) {
      _errorMessage.write(' • at least 1 uppercase letter\n');
    }
    if (!RegExp(r'[!@#\$&*~.-/:`]').hasMatch(this)) {
      _errorMessage.write(' • at least 1 special character\n');
    }
    if (!RegExp(r'\d').hasMatch(this)) {
      _errorMessage.write(' • at least 1 number\n');
    }

    return _errorMessage.toString().isNotEmpty
        ? 'Password must contain:\n' + _errorMessage.toString()
        : null;
  }
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  bool _isPasswordVisible = true;

  bool _validate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(_email);
      print(_password);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter your email',
                  suffixIcon: Icon(Icons.mail_outline_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                autofillHints: const [AutofillHints.email],
                maxLength: 50,
                validator: (email) => email!.isValidEmail()
                    ? null
                    : "Please enter a valid email address",
                onSaved: (email) => _email = email!,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: _isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  suffixIcon: IconButton(
                      onPressed: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible),
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined)),
                ),
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const [AutofillHints.password],
                maxLength: 40,
                validator: (password) => password!.validatePassword(),
                onSaved: (password) => _password = password!,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () => _validate(),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
