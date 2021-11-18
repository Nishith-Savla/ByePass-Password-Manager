import 'package:flutter/material.dart';
import 'package:password_manager/components/rounded_button.dart';
import 'package:password_manager/components/rounded_textfield.dart';
import 'package:password_manager/utils.dart' show emailRegex;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

extension Validator on String {
  bool isValidEmail() => RegExp(emailRegex).hasMatch(this);

  String validatePassword() {
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
        : '';
  }
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  String _email = "";
  String _password = "";
  String _emailErrorMessage = "";
  String _passwordErrorMessage = "";
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
              RoundedTextField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                focusNode: _emailFocusNode,
                labelText: 'Email Address',
                hintText: 'Enter your email',
                suffixIcon: IconButton(
                    icon: const Icon(Icons.email_outlined),
                    onPressed: () => _emailFocusNode.requestFocus()),
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                autofillHints: const [AutofillHints.email],
                maxLength: 50,
                validator: (email) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    setState(() => _emailErrorMessage = email!.isValidEmail()
                        ? ""
                        : "Please enter a valid email address");
                  });
                },
                onSaved: (email) => _email = email!,
              ),
              Text(_emailErrorMessage),
              RoundedTextField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                focusNode: _passwordFocusNode,
                obscureText: _isPasswordVisible,
                labelText: 'Password',
                hintText: 'Enter your password',
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                      _passwordFocusNode.requestFocus();
                    },
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined)),
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const [AutofillHints.password],
                maxLength: 40,
                validator: (password) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    setState(() =>
                        _passwordErrorMessage = password!.validatePassword());
                  });
                },
                onSaved: (password) => _password = password!,
              ),
              Text(_passwordErrorMessage),
              RoundedButton(
                text: "LOGIN",
                onPressed: () => _validate(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }
}
