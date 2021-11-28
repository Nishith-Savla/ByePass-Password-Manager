import 'package:flutter/material.dart';
import 'package:password_manager/models/display_passwords.dart';
import 'package:flutter/services.dart';

class PasswordWidget extends StatelessWidget {
  final DisplayPasswords displayPasswords;

  const PasswordWidget({Key? key, required this.displayPasswords})
      : super(key: key);

  ListTile addBottomNavWidget(IconData icon, String title, Function() fun) {
    return ListTile(
      dense: true,
      leading: Icon(
        icon,
        size: 30.0,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
        ),
      ),
      onTap: fun,
    );
  }

  copyToClipboard(BuildContext context, String data, String name) {
    Clipboard.setData(ClipboardData(
      text: data,
    )).then((_) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "$name has been copied to clipboard",
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
          minLeadingWidth: 0.0,
          onTap: () {},
          leading: Image.network(
            displayPasswords.favicon,
            height: 30.0,
            width: 30.0,
          ),
          title: Text(
            displayPasswords.siteName,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            displayPasswords.email,
            style: const TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert_outlined),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.all(10.0),
                    height: 300.0,
                    child: Column(
                      children: [
                        ListTile(
                          dense: true,
                          leading: Image.network(
                            displayPasswords.favicon,
                            height: 30.0,
                            width: 30.0,
                          ),
                          title: Text(
                            displayPasswords.siteName,
                            style: const TextStyle(fontSize: 18.0),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close_outlined),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Divider(
                          color: Colors.grey.shade500,
                        ),
                        addBottomNavWidget(
                          Icons.copy_outlined,
                          "Copy email",
                          () {
                            copyToClipboard(
                              context,
                              displayPasswords.email,
                              "Email",
                            );
                          },
                        ),
                        addBottomNavWidget(
                          Icons.copy_outlined,
                          "Copy password",
                          () {
                            copyToClipboard(
                              context,
                              displayPasswords.password,
                              "Password",
                            );
                          },
                        ),
                        addBottomNavWidget(
                          Icons.info_outline,
                          "View details",
                          () {},
                        ),
                        addBottomNavWidget(
                          Icons.edit_outlined,
                          "Edit",
                          () {},
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        Divider(
          color: Colors.grey.shade400,
        )
      ],
    );
  }
}
