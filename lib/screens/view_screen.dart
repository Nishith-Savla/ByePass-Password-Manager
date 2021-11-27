import 'package:flutter/material.dart';
import 'package:password_manager/components/rounded_textfield.dart';

class ItemViewScreen extends StatelessWidget {
  const ItemViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View item',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Align(
              child: Padding(
                  padding: EdgeInsets.only(left: 40, top: 20),
                  child: Text(
                    'Item Information',
                    style: TextStyle(fontSize: 17),
                  )),
              alignment: Alignment.centerLeft,
            ),
            const RoundedTextFormField(
              labelText: 'Name',
              icon: Icons.person,
              disabled: true,
            ),
            SizedBox(height: size.height * 0.015),
            const RoundedTextFormField(
              labelText: 'Username',
              icon: Icons.person,
              disabled: true,
            ),
            SizedBox(height: size.height * 0.015),
            const RoundedTextFormField(
              labelText: 'Password',
              icon: Icons.lock,
              disabled: true,
            ),
            SizedBox(height: size.height * 0.015),
            const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 20, left: 40),
                  child: Text("URIs"),
                )),
            const RoundedTextFormField(
              labelText: 'Website',
              icon: Icons.language,
              disabled: true,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.edit),
      ),
    );
  }
}
