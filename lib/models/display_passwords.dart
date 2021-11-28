class DisplayPasswords {
  final int id;
  final String siteName;
  final String email;
  final String password;
  final String favicon;

  DisplayPasswords(
      {required this.id,
      required this.siteName,
      required this.email,
      required this.password,
      required this.favicon});
}

class AvailablePasswords {
  static final products = [
    DisplayPasswords(
      id: 1,
      siteName: "Google",
      email: "varshilshah1004@gmail.com",
      password: "Root@Google#123",
      favicon:
          "https://upload.wikimedia.org/wikipedia/commons/2/2d/Google-favicon-2015.png",
    ),
    DisplayPasswords(
      id: 2,
      siteName: "Facebook",
      email: "varshilshah5152@gmail.com",
      password: "Root@Facebook#123",
      favicon:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Facebook_icon.svg/2048px-Facebook_icon.svg.png",
    ),
    DisplayPasswords(
      id: 3,
      siteName: "Instagram",
      email: "varshilshah0301@gmail.com",
      password: "Root@Instagram#123",
      favicon:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Instagram-Icon.png/1025px-Instagram-Icon.png",
    ),
    DisplayPasswords(
      id: 4,
      siteName: "Github",
      email: "varshilshah7913@gmail.com",
      password: "Root@Instagram#123",
      favicon:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Octicons-mark-github.svg/2048px-Octicons-mark-github.svg.png",
    ),
  ];
}
