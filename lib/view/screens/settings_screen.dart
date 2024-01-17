import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_ferm/view/auth_ui/welcome_screen.dart';
import 'package:shoes_ferm/view/screens/profile_screen.dart';
import '../../controller/google_sign_in_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  GoogleSignInController googleSignInController = GoogleSignInController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  tileColor: Colors.white,
                  onTap: () {
                    Get.to(()=>const ProfileScreen());
                  },
                  leading: const Icon(
                    Icons.person_outline,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Account",
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  tileColor: Colors.white,
                  onTap: () {},
                  leading: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Notifications",
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  tileColor: Colors.white,
                  onTap: () {},
                  leading: const Icon(
                    Icons.headphones_outlined,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Help and Support",
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  tileColor: Colors.white,
                  onTap: () {},
                  leading: const Icon(
                    Icons.help_outline,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "About",
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  tileColor: Colors.white,
                  onTap: () async {
                    FirebaseAuth.instance.signOut();
                    Get.offAll(() => const WelcomeScreen());
                  },
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
