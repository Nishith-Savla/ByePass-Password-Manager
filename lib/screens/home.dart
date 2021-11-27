import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/components/rounded_textfield.dart';
import 'package:password_manager/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTabIndex = 0;
  bool showCrossIcon = false;
  final String imageUrl =
      "https://static.deepsource.io/avatars/1f8d2e00-2bd6-4308-b96b-abf4e89ee762.jpg";

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    debugPrint(size.toString());
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 15.0,
              ),
              child: RoundedTextFormField(
                style: const TextStyle(
                  fontSize: 18,
                ),
                hintText: "Search password",
                icon: Icons.search_rounded,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.close_outlined,
                    color:
                        showCrossIcon ? darkBlueishColor : Colors.transparent,
                  ),
                  onPressed: showCrossIcon ? () {} : null,
                ),
                color: darkBlueishColor,
                onChanged: (value) => setState(() {
                  value.length > 0
                      ? showCrossIcon = true
                      : showCrossIcon = false;
                }),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: Container(
                  color: purpleMaterialColor[200],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: SizedBox(
                height: size.height * 0.58,
                width: double.infinity,
                child: Container(
                  child: Text(selectedTabIndex.toString()),
                  color: purpleMaterialColor,
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.lock_outline_rounded), label: "Vault"),
          BottomNavigationBarItem(
              icon: Icon(Icons.repeat_outlined), label: "Generate"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: "Settings"),
        ],
        currentIndex: selectedTabIndex,
        selectedItemColor: darkBlueishColor,
        unselectedItemColor: Colors.black,
        onTap: (int item) {
          setState(() {
            selectedTabIndex = item;
          });
        },
      ),
    );
  }
}
