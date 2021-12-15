import 'dart:typed_data' show Uint8List;

import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:flutter/material.dart';
import 'package:password_manager/components/rounded_textfield.dart';
import 'package:password_manager/constants.dart' show purpleMaterialColor;
import 'package:password_manager/models/password_entry.dart';
import 'package:password_manager/utils.dart'
    show generateKey, getMasterPassword, pepper;
import 'package:timeago/timeago.dart' as timeago show format;

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class ItemScreenArguments {
  final bool isEditable;
  final void Function(PasswordEntry) onSave;
  final void Function(PasswordEntry) onDelete;
  final PasswordEntry passwordEntry;

  ItemScreenArguments(
      this.isEditable, this.onSave, this.onDelete, this.passwordEntry);
}

class ItemScreen extends StatefulWidget {
  final bool isEditable;
  final void Function(PasswordEntry) onSave;
  final void Function(PasswordEntry) onDelete;
  final PasswordEntry passwordEntry;

  const ItemScreen({
    Key? key,
    required this.isEditable,
    required this.passwordEntry,
    required this.onSave,
    required this.onDelete,
  }) : super(key: key);

  factory ItemScreen.fromItemScreenArguments(
      ItemScreenArguments itemScreenArguments) {
    return ItemScreen(
      isEditable: itemScreenArguments.isEditable,
      passwordEntry: itemScreenArguments.passwordEntry,
      onSave: itemScreenArguments.onSave,
      onDelete: itemScreenArguments.onDelete,
    );
  }

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  late bool isEditable;
  late bool isPasswordVisible;
  late final Uint8List _key;

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController uriController;

  void _resetTextFields() {
    nameController.text = widget.passwordEntry.name;
    emailController.text = widget.passwordEntry.email;
    passwordController.text = '        ';
    uriController.text = widget.passwordEntry.uri.toString();
  }

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

    () async {
      _key = generateKey(
          await getMasterPassword(), pepper, widget.passwordEntry.createdAt);
    }();
  }

  void _onSave() async {
    bool updated = false;
    if (nameController.text != widget.passwordEntry.name) {
      widget.passwordEntry.name = nameController.text;
      updated = true;
    }
    if (emailController.text != widget.passwordEntry.email) {
      widget.passwordEntry.email = emailController.text;
      updated = true;
    }
    if (uriController.text != widget.passwordEntry.uri.toString()) {
      widget.passwordEntry.uri = Uri.parse(uriController.text);
      updated = true;
    }
    if (widget.passwordEntry.getPassword(_key) != passwordController.text) {
      widget.passwordEntry.setPassword(passwordController.text, _key);
      updated = true;
    }

    if (updated) {
      widget.passwordEntry.lastUpdated = Timestamp.now();
      widget.onSave(widget.passwordEntry);
    }

    setState(() => isEditable = false);
  }

  void _onDelete() {
    widget.onDelete(widget.passwordEntry);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("${isEditable ? 'Edit' : 'View'} item"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          isEditable
              ? IconButton(
                  icon: const Icon(Icons.check_outlined),
                  onPressed: _onSave,
                )
              : IconButton(
                  icon: const Icon(Icons.delete_outlined),
                  onPressed: _onDelete),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
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
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.content_copy_outlined,
                    size: 20,
                  ),
                  padding: const EdgeInsets.only(left: 16),
                  constraints: const BoxConstraints(),
                  onPressed: () {},
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
                    IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                      padding: const EdgeInsets.only(right: 8),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        // Using not as state is set later
                        passwordController.text =
                            !isPasswordVisible || isEditable
                                ? widget.passwordEntry.getPassword(_key)
                                : '        ';
                        setState(() => isPasswordVisible = !isPasswordVisible);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.content_copy_outlined,
                        size: 20,
                      ),
                      padding: const EdgeInsets.only(left: 8),
                      constraints: const BoxConstraints(),
                      onPressed: () {},
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
                    IconButton(
                      icon: const Icon(
                        Icons.launch_outlined,
                        size: 20,
                      ),
                      padding: const EdgeInsets.only(right: 8),
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.content_copy_outlined,
                        size: 20,
                      ),
                      padding: const EdgeInsets.only(left: 8),
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              if (!isEditable)
                Container(
                  padding: const EdgeInsets.only(left: 30, top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "Last updated: ${timeago.format(widget.passwordEntry.lastUpdated.toDate())}",
                      style: Theme.of(context).textTheme.overline),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: purpleMaterialColor,
        onPressed: () {
          setState(() => isEditable = !isEditable);
          if (!isEditable) _resetTextFields();
        },
        child: Icon(isEditable ? Icons.clear : Icons.edit_outlined),
      ),
    );
  }
}
