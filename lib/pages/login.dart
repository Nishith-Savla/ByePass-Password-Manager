import 'package:flutter/material.dart';
import 'package:password_manager/components/background.dart';
import 'package:password_manager/components/rounded_button.dart';
import 'package:password_manager/components/rounded_textfield.dart';
import 'package:flutter_svg/svg.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  bool _isPasswordVisisble = false;
  bool _isPasswordFocused = false;
  String _emailErrorMessage = "";
  String _passwordErrorMessage = "";

  bool _validate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      debugPrint(_email);
      debugPrint(_password);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "LOGIN",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                SvgPicture.asset(
                  "assets/icons/login.svg",
                  height: size.height * 0.35,
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Column(
                    children: [
                      RoundedTextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        labelText: "Enter email address",
                        autofocus: true,
                        autofillHints: const [AutofillHints.email],
                        icon: Icons.email,
                        validator: (email) {
                          WidgetsBinding.instance!.addPostFrameCallback(
                            (_) => setState(() => _emailErrorMessage =
                                email!.isNotEmpty
                                    ? ''
                                    : 'Email cannot be empty'),
                          );
                        },
                        onSaved: (email) => _email = email!,
                      ),
                      _emailErrorMessage.isNotEmpty
                          ? Text(
                              _emailErrorMessage,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    children: [
                      Focus(
                        child: RoundedTextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          labelText: "Enter password",
                          icon: Icons.lock,
                          obscureText: _isPasswordVisisble,
                          keyboardType: TextInputType.visiblePassword,
                          autofillHints: const [AutofillHints.password],
                          suffixIcon: _isPasswordFocused
                              ? IconButton(
                                  onPressed: () {
                                    setState(() => _isPasswordVisisble =
                                        !_isPasswordVisisble);
                                  },
                                  icon: Icon(
                                    _isPasswordVisisble
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                  ),
                                )
                              : null,
                          validator: (password) {
                            WidgetsBinding.instance!.addPostFrameCallback(
                              (_) => setState(() => _passwordErrorMessage =
                                  password!.isNotEmpty
                                      ? ''
                                      : 'Password cannot be empty'),
                            );
                          },
                          onSaved: (password) => _password = password!,
                        ),
                        onFocusChange: (hasFocus) =>
                            setState(() => _isPasswordFocused = hasFocus),
                      ),
                      _passwordErrorMessage.isNotEmpty
                          ? Text(
                              _passwordErrorMessage,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                RoundedButton(
                  text: "LOGIN",
                  onPressed: _validate,
                ),
                SizedBox(height: size.height * 0.02),
                const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
