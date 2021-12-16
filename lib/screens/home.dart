import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:password_manager/components/password_widget.dart';
import 'package:password_manager/components/rounded_textfield.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/password_entry.dart';
import 'package:password_manager/repository/data_repository.dart';
import 'package:password_manager/screens/generate.dart';
import 'package:password_manager/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTabIndex = 0;
  bool showCrossIcon = false;

  final TextEditingController _controller = TextEditingController();
  final repository = DataRepository();

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot!.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    debugPrint(snapshot.toString());
    final passwordEntry = PasswordEntry.fromSnapshot(snapshot,
        key: generateKey("fdajflakfjd", dotenv.env['PEPPER']!,
            (snapshot.data() as Map<String, dynamic>)['createdAt']));

    return PasswordWidget(entry: passwordEntry);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    debugPrint(size.toString());
    final homeBody = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: SizedBox(
          height: size.height * 0.585,
          width: double.infinity,
          child: StreamBuilder(
              stream: repository.getStream(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                debugPrint(snapshot.toString());
                if (!snapshot.hasData) return const LinearProgressIndicator();
                return _buildList(context, snapshot.data?.docs ?? []);
              }),
        ),
      ),
      const Generate(generateType: GenerateType.password),
      const Icon(Icons.admin_panel_settings_outlined),
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: RoundedTextFormField(
          controller: _controller,
          style: const TextStyle(
            fontSize: 18,
          ),
          hintText: "Search password",
          icon: Icons.search_rounded,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.close_outlined,
              color: showCrossIcon ? darkBlueishColor : Colors.transparent,
            ),
            onPressed: showCrossIcon
                ? () {
                    _controller.clear();
                  }
                : null,
          ),
          color: darkBlueishColor,
          onChanged: (value) => setState(() {
            value.length > 0 ? showCrossIcon = true : showCrossIcon = false;
          }),
        ),
      ),
      body: homeBody[selectedTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_outline_rounded),
            label: "Vault",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.repeat_outlined),
            label: "Generate",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "Settings",
          ),
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
