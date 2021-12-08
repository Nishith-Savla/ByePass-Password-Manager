import 'package:flutter/material.dart';
import 'package:password_manager/components/rounded_textfield.dart';
import 'package:password_manager/constants.dart' show purpleMaterialColor;
import 'package:password_manager/models/password_entry.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class ItemScreen extends StatefulWidget {
  final bool isEditable;
  final String Function() onPasswordView;
  final PasswordEntry passwordEntry;

  const ItemScreen(
      {Key? key,
      required this.onPasswordView,
      required this.isEditable,
      required this.passwordEntry})
      : super(key: key);

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  late bool isEditable;
  late bool isPasswordVisible;

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController uriController;

  @override
  void initState() {
    super.initState();
    isPasswordVisible = false;
    isEditable = widget.isEditable;
    nameController = TextEditingController(text: widget.passwordEntry.name);

    emailController = TextEditingController(text: widget.passwordEntry.email);

    passwordController = TextEditingController(text: '        ');

    uriController =
        TextEditingController(text: widget.passwordEntry.uri.toString());
  }

  void _onSave() {
    if (nameController.text != widget.passwordEntry.name) {
      widget.passwordEntry.name = nameController.text;
    }
    if (emailController.text != widget.passwordEntry.email) {
      widget.passwordEntry.email = emailController.text;
    }
    if (uriController.text != widget.passwordEntry.uri.toString()) {
      widget.passwordEntry.uri = Uri.parse(uriController.text);
    }
    // TODO: set password
    widget.passwordEntry.setPassword(passwordController.text, '');
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${isEditable ? 'Edit' : 'View'} item",
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.check_outlined), onPressed: _onSave),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 20, left: 30),
              child: const Text(
                'Item Information',
                style: TextStyle(fontSize: 16),
              ),
              alignment: Alignment.centerLeft,
            ),
            RoundedTextFormField(
              labelText: 'Name',
              controller: nameController,
              icon: Icons.language_outlined,
              disabled: !isEditable,
              focusNode: isEditable ? null : AlwaysDisabledFocusNode(),
            ),
            SizedBox(height: size.height * 0.015),
            RoundedTextFormField(
              labelText: 'Username',
              controller: emailController,
              icon: Icons.person_outlined,
              disabled: !isEditable,
              focusNode: isEditable ? null : AlwaysDisabledFocusNode(),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: InkWell(
                  onTap: () {},
                  child: const Icon(Icons.content_copy_outlined),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.015),
            RoundedTextFormField(
              labelText: 'Password',
              controller: passwordController,
              obscureText: !isPasswordVisible,
              icon: Icons.lock_outlined,
              disabled: !isEditable,
              focusNode: isEditable ? null : AlwaysDisabledFocusNode(),
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: InkWell(
                      onTap: () {},
                      child: const Icon(Icons.content_copy_outlined),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: InkWell(
                      child: Icon(isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onTap: () {
                        setState(() => isPasswordVisible = !isPasswordVisible);
                        passwordController.text = isPasswordVisible
                            ? widget.onPasswordView()
                            : '        ';
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.015),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 20, left: 30),
              child: const Text(
                "URIs",
                style: TextStyle(fontSize: 16),
              ),
            ),
            RoundedTextFormField(
              focusNode: isEditable ? null : AlwaysDisabledFocusNode(),
              labelText: 'Website',
              controller: uriController,
              icon: Icons.link_outlined,
              disabled: !isEditable,
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: InkWell(
                      onTap: () {},
                      child: const Icon(Icons.launch_outlined),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: InkWell(
                      onTap: () {},
                      child: const Icon(Icons.content_copy_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        focusNode: isEditable ? null : AlwaysDisabledFocusNode(),
        backgroundColor: purpleMaterialColor,
        onPressed: () => setState(() => isEditable = !isEditable),
        child: const Icon(Icons.edit_outlined),
      ),
    );
  }
}
