import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/constants.dart' show darkBlueishColor;
import 'package:password_manager/models/password_entry.dart';
import 'package:password_manager/utils.dart';

class PasswordWidget extends StatelessWidget {
  final PasswordEntry entry;
  late final String faviconPath;
  final VoidCallback onView;

  PasswordWidget({Key? key, required this.entry, required this.onView})
      : super(key: key) {
    faviconPath = "${entry.uri.origin}/favicon.ico";
  }

  @override
  int get hashCode => hashValues(entry, faviconPath);

  @override
  bool operator ==(Object other) {
    return other is PasswordWidget &&
        other.entry == entry &&
        other.faviconPath == faviconPath;
  }

  Widget _getIcon() {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      foregroundColor: darkBlueishColor,
      radius: 15,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: Image.network(
          faviconPath,
          errorBuilder: (_, __, ___) => const Icon(Icons.language, size: 30),
          height: 30,
          width: 30,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  ListTile itemInfoModal(IconData icon, String title, VoidCallback fun) {
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
          onTap: onView,
          leading: _getIcon(),
          title: Text(
            entry.name,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            entry.email,
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
                    height: 330.0,
                    child: Column(
                      children: [
                        ListTile(
                          dense: true,
                          leading: _getIcon(),
                          title: Text(
                            entry.name,
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
                        itemInfoModal(
                          Icons.copy_outlined,
                          "Copy email",
                          () {
                            copyToClipboard(
                              context,
                              entry.email,
                              "Email",
                            );
                          },
                        ),
                        itemInfoModal(
                          Icons.copy_outlined,
                          "Copy password",
                          () async {
                            copyToClipboard(
                              context,
                              entry.getPassword(generateKey(
                                  await getMasterPassword(),
                                  pepper,
                                  entry.createdAt)),
                              "Password",
                            );
                          },
                        ),
                        itemInfoModal(
                          Icons.info_outline,
                          "View details",
                          () {},
                        ),
                        itemInfoModal(
                          Icons.edit_outlined,
                          "Edit",
                          () {},
                        ),
                        itemInfoModal(
                          Icons.delete_outline,
                          "Delete",
                          () {},
                        )
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
