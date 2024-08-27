import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/google_sign_in_controller.dart';
import '../../controller/user_data_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GoogleSignInController googleSignInController =
      GoogleSignInController();
  final GetUserDataController _getUserDataController =
      Get.put(GetUserDataController());

  late final User user;
  late List<QueryDocumentSnapshot<Object?>> userData = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    _getUserData();
  }

  Future<void> _getUserData() async {
    userData = await _getUserDataController.getUserData(user.uid);
    if (mounted) {
      setState(() {});
    }
  }

  var email = TextEditingController();
  var password = TextEditingController();
  var mobile = TextEditingController();

  final saveKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[400],
                  ),
                  CircleAvatar(
                    radius: 59,
                    backgroundImage: NetworkImage(
                      userData.isNotEmpty &&
                              userData[0]['userImg'] != null &&
                              userData[0]['userImg'].isNotEmpty
                          ? userData[0]['userImg']
                          : 'https://via.placeholder.com/150',
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.grey[100],
                height: 50,
                width: 350,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      textAlign: TextAlign.start,
                      "Name :   ${userData.isNotEmpty ? userData[0]['username'] : 'N/A'}",
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.grey[100],
                height: 50,
                width: 350,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      textAlign: TextAlign.start,
                      "Email :   ${userData.isNotEmpty ? userData[0]['email'] : 'N/A'}",
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.grey[100],
                height: 50,
                width: 350,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      textAlign: TextAlign.start,
                      "Mobile :   ${userData.isNotEmpty ? userData[0]['phone'] : 'N/A'}",
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
