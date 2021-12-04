import 'package:flutter/material.dart';
import 'package:password_manager/components/rounded_textfield.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class EditEntry extends StatelessWidget {
  const EditEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Edit Item',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const <Widget>[
          IconButton(
            onPressed: (null),
            icon: Icon(
              Icons.check_outlined,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 40, top: 20),
              child: const Text(
                'Item Information',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.centerLeft,
            ),
            RoundedTextFormField(
              labelText: 'Name',
              icon: Icons.person,
              disabled: true,
              focusNode: AlwaysDisabledFocusNode(),
            ),
            SizedBox(height: size.height * 0.015),
            RoundedTextFormField(
              labelText: 'Username',
              icon: Icons.person,
              disabled: true,
              focusNode: AlwaysDisabledFocusNode(),
              suffixIcon: IconButton(
                  onPressed: () {}, icon: const Icon(Icons.content_copy)),
            ),
            SizedBox(height: size.height * 0.015),
            RoundedTextFormField(
              labelText: 'Password',
              icon: Icons.lock,
              disabled: true,
              focusNode: AlwaysDisabledFocusNode(),
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.content_copy),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.015),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 20, left: 40),
              child: const Text("URIs"),
            ),
            RoundedTextFormField(
              focusNode: AlwaysDisabledFocusNode(),
              labelText: 'Website',
              icon: Icons.language,
              disabled: true,
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.launch_outlined),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.content_copy),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
