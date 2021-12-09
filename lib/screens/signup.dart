import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:password_manager/components/background.dart';
import 'package:password_manager/components/rounded_button.dart';
import 'package:password_manager/components/rounded_textfield.dart';
import 'package:password_manager/firebase/authentication.dart';
import 'package:password_manager/utils.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
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
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      debugPrint(_name);
      debugPrint(_email);
      debugPrint(_password);
      debugPrint(_confirmPassword);
      return true;
    }
    return false;
  }

  void _signup() async {
    if (!_validate()) return;
    final auth = Authentication();
    final error = await auth.addUserWithEmailAndPassword(
        email: _email, password: _password, collectionPath: 'users');
    if (error != null && error.isNotEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Sign up successful')));
      setMasterPassword(_password);
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

                //
                SizedBox(
                  height: size.height * 0.02,
                ),
                SvgPicture.asset(
                  "assets/icons/login.svg",
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
                        labelText: "Enter you name",
                        autofillHints: const [AutofillHints.name],
                        icon: Icons.person,
                        validator: (name) {
                          WidgetsBinding.instance!.addPostFrameCallback(
                            (_) => setState(() => _nameErrorMessage =
                                name!.isNotEmpty ? '' : 'Name cannot be empty'),
                          );
                        },
                        onSaved: (name) => _name = name!,
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
                                          ? ''
                                          : 'Confirm Password cannot be empty'),
                            );
                          },
                          onSaved: (confirmPassword) =>
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
