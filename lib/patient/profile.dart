import 'package:flutter/material.dart';
import 'home.dart';
import 'modify_profile.dart';

void main() => runApp(const Profile());

/// This is the main application widget.
class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  Widget _iconButton(BuildContext context, IconData icon, String tooltip,
      StatelessWidget statelessWidget) {
    IconButton iconButton;

    if (tooltip != "Modifica") {
      iconButton = IconButton(
        icon: Icon(icon),
        tooltip: tooltip,
        iconSize: 40,
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } else {
      iconButton = IconButton(
        icon: Icon(icon),
        tooltip: tooltip,
        iconSize: 40,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => statelessWidget),
          );
        },
      );
    }

    return iconButton;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading:
              _iconButton(context, Icons.arrow_back, 'Indietro', const Home()),
          title: const Center(
            child: Text("Profilo"),
          ),
          actions: [
            _iconButton(context, Icons.edit, 'Modifica', const ModifyProfile()),
            _iconButton(context, Icons.logout, 'Logout', const Home()),
          ],
        ),
        body: const Center(
          child: MyProfile(),
        ),
      ),
    );
  }
}

// This is the stateless widget that the main application instantiates.
class MyProfile extends StatelessWidget {
  const MyProfile({Key? key}) : super(key: key);

  Widget _card(String title, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
      ),
    );
  }

  Widget _checkboxListTile(String text, bool value) {
    return CheckboxListTile(
      title: Text(text),
      contentPadding: const EdgeInsets.symmetric(horizontal: 100),
      value: value,
      onChanged: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Mario Rossi",
          style: TextStyle(fontSize: 50),
        ),
        _card("SMLLNEXIXISI", Icons.person),
        _card("+39 331 313 3141", Icons.smartphone),
        _card("mariorossi@gmail.com", Icons.email),
        const Text("\nTipologia chat"),
        _checkboxListTile("Solo testo", false),
        _checkboxListTile("Videochiamata", true),
        _checkboxListTile("Chiamata vocale", false),
      ],
    );
  }
}
