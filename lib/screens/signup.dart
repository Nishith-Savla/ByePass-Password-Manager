import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:password_manager/components/background.dart';
import 'package:password_manager/components/rounded_button.dart';
import 'package:password_manager/components/rounded_textfield.dart';
import 'package:password_manager/constants.dart' show emailRegex, nameRegex;
import 'package:password_manager/firebase/authentication.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

extension Validation on String {
  String isEmailValid() {
    if (isEmpty) return "Email cannot be empty";

    if (!RegExp(emailRegex).hasMatch(this)) return "Invalid email";

    return "";
  }

  String isPasswordValid() {
    final _errors = [];
    if (isEmpty) return "Password cannot be empty";

    if (length < 8) {
      _errors.add(' • minimum 8 characters');
    }
    if (!RegExp(r'[a-z]').hasMatch(this)) {
      _errors.add(' • A lowercase letter');
    }
    if (!RegExp(r'[A-Z]').hasMatch(this)) {
      _errors.add(' • An uppercase letter');
    }
    if (!RegExp(r'[!@#\$&*~.-/:`]').hasMatch(this)) {
      _errors.add(' • A special character');
    }
    if (!RegExp(r'\d').hasMatch(this)) {
      _errors.add(' • A number');
    }

    if (_errors.isEmpty) return "";

    final _errorMessage = StringBuffer("Password must contain: \n");
    for (int i = 0; i < _errors.length; ++i) {
      if (i % 2 == 1) {
        _errorMessage.writeln(_errors[i]);
        continue;
      }

      _errorMessage.write(_errors[i] + '\t');
    }

    return _errorMessage.toString().trimRight();
  }

  String isNameValid() {
    if (isEmpty) return "Name field is empty";

    if (!RegExp(nameRegex).hasMatch(this)) {
      return "Invalid name. Use only letters and spaces";
    }

    return "";
  }
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;
  bool _isPasswordFocused = false;
  String _name = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";

  String _nameErrorMessage = "";
  String _emailErrorMessage = "";
  String _passwordErrorMessage = "";
  String _confirmPasswordErrorMessage = "";

  bool _validate() {
    if (_name.isNotEmpty &&
        _nameErrorMessage.isEmpty &&
        _confirmPasswordErrorMessage.isEmpty &&
        _passwordErrorMessage.isEmpty &&
        _emailErrorMessage.isEmpty) {
      debugPrint(_name);
      debugPrint(_email);
      debugPrint(_password);
      debugPrint(_confirmPassword);
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  void _signup() async {
    if (!_validate()) return;
    final auth = Authentication();
    final error = await auth.addUserWithEmailAndPassword(
        email: _email,
        password: _password,
        collectionPath: 'users',
        values: {'name': _name});
    if (error != null && error.isNotEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Sign up successful')));
      auth.verifyCurrentUser();
    }
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
                  "SIGN UP",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

                SizedBox(
                  height: size.height * 0.02,
                ),
                SvgPicture.asset(
                  "assets/icons/signup.svg",
                  height: size.height * 0.25,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                // Name
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Column(
                    children: [
                      RoundedTextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.name,
                        labelText: "Enter your name",
                        autofillHints: const [AutofillHints.name],
                        icon: Icons.person,
                        validator: (name) {
                          WidgetsBinding.instance!.addPostFrameCallback(
                            (_) => setState(
                                () => _nameErrorMessage = name!.isNameValid()),
                          );
                        },
                        onChanged: (name) => _name = name!,
                      ),
                      _nameErrorMessage.isNotEmpty
                          ? Text(
                              _nameErrorMessage,
                              style: const TextStyle(color: Colors.red),
                            )
                          : Container(),
                    ],
                  ),
                ),

                // Email
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Column(
                    children: [
                      RoundedTextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        labelText: "Enter email address",
                        autofillHints: const [AutofillHints.email],
                        icon: Icons.email,
                        validator: (email) {
                          WidgetsBinding.instance!.addPostFrameCallback(
                            (_) => setState(
                              () => _emailErrorMessage = email!.isEmailValid(),
                            ),
                          );
                        },
                        onSaved: (email) => _email = email!,
                      ),
                      _emailErrorMessage.isNotEmpty
                          ? Text(
                              _emailErrorMessage,
                              textAlign: TextAlign.left,
                              style: const TextStyle(color: Colors.red),
                            )
                          : Container(),
                    ],
                  ),
                ),

                // Password
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Column(
                    children: [
                      Focus(
                        child: RoundedTextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          labelText: "Enter password",
                          icon: Icons.lock,
                          obscureText: _isPasswordVisible,
                          keyboardType: TextInputType.visiblePassword,
                          autofillHints: const [AutofillHints.password],
                          suffixIcon: _isPasswordFocused
                              ? IconButton(
                                  onPressed: () {
                                    setState(() => _isPasswordVisible =
                                        !_isPasswordVisible);
                                  },
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                  ),
                                )
                              : null,
                          validator: (password) {
                            WidgetsBinding.instance!.addPostFrameCallback(
                              (_) => setState(() => _passwordErrorMessage =
                                  password!.isPasswordValid()),
                            );
                          },
                          onChanged: (password) => _password = password!,
                        ),
                        onFocusChange: (hasFocus) =>
                            setState(() => _isPasswordFocused = hasFocus),
                      ),
                      _passwordErrorMessage.isNotEmpty
                          ? Text(
                              _passwordErrorMessage,
                              style: const TextStyle(color: Colors.red),
                            )
                          : Container(),
                    ],
                  ),
                ),

                // Confirm Password
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Column(
                    children: [
                      Focus(
                        child: RoundedTextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          labelText: "Confirm your password",
                          icon: Icons.lock,
                          obscureText: _isPasswordVisible,
                          keyboardType: TextInputType.visiblePassword,
                          autofillHints: const [AutofillHints.password],
                          suffixIcon: _isPasswordFocused
                              ? IconButton(
                                  onPressed: () {
                                    setState(() => _isPasswordVisible =
                                        !_isPasswordVisible);
                                  },
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                  ),
                                )
                              : null,
                          validator: (confirmPassword) {
                            WidgetsBinding.instance!.addPostFrameCallback(
                              (_) => setState(() =>
                                  _confirmPasswordErrorMessage =
                                      confirmPassword!.isNotEmpty
                                          ? confirmPassword == _password
                                              ? ""
                                              : "Password is not matching"
                                          : 'Confirm Password cannot be empty'),
                            );
                          },
                          onChanged: (confirmPassword) =>
                              _confirmPassword = confirmPassword!,
                        ),
                        onFocusChange: (hasFocus) {},
                      ),
                      _confirmPasswordErrorMessage.isNotEmpty
                          ? Text(
                              _confirmPasswordErrorMessage,
                              style: const TextStyle(color: Colors.red),
                            )
                          : Container(),
                    ],
                  ),
                ),

                RoundedButton(
                  text: "SIGN UP",
                  onPressed: _signup,
                ),
                SizedBox(height: size.height * 0.02),
                const Text(
                  "Already have an account? Login",
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
