import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_ferm/controller/google_sign_in_controller.dart';
import 'package:shoes_ferm/view/auth_ui/forgot_password_screen.dart';
import 'package:shoes_ferm/view/auth_ui/phone_sent_otp_screen.dart';
import 'package:shoes_ferm/view/auth_ui/sign_up_screen.dart';
import 'package:shoes_ferm/view/main_screen.dart';
import 'package:shoes_ferm/view/widgets/button_widget.dart';
import 'package:shoes_ferm/view/widgets/square_tile_widget.dart';
import 'package:shoes_ferm/view/widgets/textfield_widget.dart';
import '../../controller/email_sign_in_controller.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _loginKey1 = GlobalKey<FormState>();
  final _emailController1 = TextEditingController();
  final _passwordController1 = TextEditingController();

  get emailTextController => _passwordController1;

  get passwordTextController => _passwordController1;
  bool _passwordVisible1 = false;
  bool isLoading1 = false;
  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());
  final EmailPassController _emailPassController =
      Get.put(EmailPassController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _loginKey1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Icon(
                Icons.lock,
                size: 100,
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                'Welcome back, you\'ve been missed!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              MyTextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController1,
                hintText: 'Email',
                obscureText: false,
                prefixIcon: const Icon(
                  Icons.mail,
                ),
                suffixIcon: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please input your email";
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return "Input a valid email address";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                keyboardType: TextInputType.text,
                controller: _passwordController1,
                hintText: 'Password',
                obscureText: !_passwordVisible1,
                prefixIcon: const Icon(
                  Icons.lock,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordVisible1 = !_passwordVisible1;
                    });
                  },
                  icon: Icon(_passwordVisible1
                      ? Icons.visibility
                      : Icons.visibility_off),
                  color: Colors.black,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please input your password";
                  }
                  if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,12}$')
                      .hasMatch(value)) {
                    return "Input a valid password";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => const ForgotPassword(),
                            transition: Transition.leftToRightWithFade);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
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
                onTap: () async {
                  if (_loginKey1.currentState!.validate()) {
                    _emailPassController.updateLoading();
                    try {
                      UserCredential? userCredential =
                          await _emailPassController.signInUser(
                              _emailController1.text,
                              _passwordController1.text);
                      if (userCredential!.user!.emailVerified) {
                        final user = userCredential.user;
                        Get.offAll(() => const MainScreen(),
                            transition: Transition.leftToRightWithFade);
                      }
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    } finally {
                      _emailPassController.updateLoading();
                    }
                  }
                },
              ),
              const SizedBox(
                height: 30,
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
                      'Or continue with',
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
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                      onTap: () {
                        _googleSignInController.signInWithGoogle();
                      },
                      imagePath: 'assets/images/google.png'),
                  const SizedBox(width: 15),
                  SquareTile(
                      onTap: () {
                        Get.to(() => const SentOtp(),
                            transition: Transition.leftToRightWithFade);
                      },
                      imagePath: 'assets/images/phone.jpeg')
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New User?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const SignUp(),
                          transition: Transition.leftToRightWithFade);
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
