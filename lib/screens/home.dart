import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:password_manager/components/password_widget.dart';
import 'package:password_manager/components/rounded_textfield.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/password_entry.dart';
import 'package:password_manager/repository/data_repository.dart';
import 'package:password_manager/screens/generate.dart';
import 'package:password_manager/screens/item_screen.dart';
import 'package:password_manager/utils.dart';

final repository = DataRepository();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTabIndex = 0;
  bool isSearching = false;
  late final List<PasswordWidget> entries;
  late List<PasswordWidget> filteredEntries;

  final TextEditingController _controller = TextEditingController();

  late final PageController pageController;

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    entries = <PasswordWidget>[];
    filteredEntries = <PasswordWidget>[];
    pageController = PageController(
      initialPage: selectedTabIndex,
      keepPage: true,
    );
  }

  void _search(String query) {
    setState(() {
      filteredEntries = entries
          .where((element) =>
              element.entry.name.contains(query) ||
              element.entry.email.contains(query))
          .toList(growable: false);
    });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return FutureBuilder(
      future: Future.wait(snapshot!
          .map((data) async => await _buildListItem(context, data))
          .toList()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        return ListView(
          padding: const EdgeInsets.only(top: 20.0),
          children: isSearching ? filteredEntries : entries,
        );
      },
    );
  }

  Future<Widget> _buildListItem(
      BuildContext context, DocumentSnapshot snapshot) async {
    final passwordEntry = PasswordEntry.fromSnapshot(
      snapshot,
      key: generateKey(
        await getMasterPassword(),
        dotenv.env['PEPPER']!,
        (snapshot.data() as Map<String, dynamic>)['createdAt'],
      ),
    );
    final widget = PasswordWidget(
      entry: passwordEntry,
      onView: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemScreen(
            isEditable: false,
            passwordEntry: passwordEntry,
            onSave: repository.updateEntry,
            onDelete: repository.deleteEntry,
          ),
        ),
      ),
    );
    if (!entries.contains(widget)) entries.add(widget);
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final homeBody = PageView(
      controller: pageController,
      onPageChanged: (index) {
        _bottomNavigationKey.currentState!.setPage(index);
        setState(() => selectedTabIndex = index);
      },
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            title: RoundedTextFormField(
              controller: _controller,
              style: const TextStyle(
                fontSize: 18,
              ),
              hintText: "Search password",
              icon: Icons.search_outlined,
              suffixIcon: isSearching
                  ? IconButton(
                      icon: const Icon(
                        Icons.close_outlined,
                        color: darkBlueishColor,
                      ),
                      onPressed: () {
                        _controller.clear();
                        setState(() => isSearching = false);
                      },
                    )
                  : null,
              color: darkBlueishColor,
              onChanged: (value) {
                _search(value);
                setState(() => isSearching = value.isNotEmpty);
              },
            ),
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: SizedBox(
              height: size.height * 0.585,
              width: double.infinity,
              child: StreamBuilder(
                stream: repository.getStream(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) return const LinearProgressIndicator();
                  return _buildList(context, snapshot.data?.docs ?? []);
                },
              ),
            ),
          ),
        ),
        const Generate(generateType: GenerateType.password),
        const Icon(Icons.admin_panel_settings_outlined),
      ],
    );

    return Scaffold(
      body: homeBody,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        items: const [
          Icon(
            Icons.lock_outline_rounded,
            color: Colors.white,
          ),
          Icon(
            Icons.repeat_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.settings_outlined,
            color: Colors.white,
          ),
        ],
        color: purpleMaterialColor,
        buttonBackgroundColor: purpleMaterialColor,
        backgroundColor: Colors.white,
        animationCurve: Curves.bounceInOut,
        animationDuration: const Duration(milliseconds: 200),
        height: 60,
        onTap: (int index) {
          setState(() {
            selectedTabIndex = index;
            pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
