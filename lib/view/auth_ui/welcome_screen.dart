import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_ferm/view/auth_ui/sign_in_screen.dart';
import 'package:shoes_ferm/view/auth_ui/sign_up_screen.dart';
import 'package:shoes_ferm/view/widgets/button_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
            child: const Image(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/nike_wsi.jpeg")),
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 75,
                ),
                const Text(
                  "Welcome!",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 40),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'To continue, sign in or sign up with your account.',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyButton(
                child: const Center(
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                onTap: () {
                  Get.to(() => const SignIn(),
                      transition: Transition.leftToRightWithFade);
                },
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      'Or',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              MyButton(
                child: const Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                onTap: () {
                  Get.to(() => const SignUp(),
                      transition: Transition.leftToRightWithFade);
                },
              ),
              const SizedBox(
                height: 20,
              )
            ],
          )
        ],
      ),
    );
  }
}
