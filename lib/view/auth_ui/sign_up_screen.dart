import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shoes_ferm/view/auth_ui/email_validation_screen.dart';
import 'package:shoes_ferm/view/auth_ui/phone_sent_otp_screen.dart';
import 'package:shoes_ferm/view/auth_ui/sign_in_screen.dart';
import 'package:shoes_ferm/view/widgets/square_tile_widget.dart';
import 'package:shoes_ferm/view/widgets/textfield_widget.dart';
import '../../controller/email_sign_in_controller.dart';
import '../../controller/google_sign_in_controller.dart';
import '../widgets/button_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _loginKey2 = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController2 = TextEditingController();
  final _passwordController2 = TextEditingController();
  bool _passwordVisible2 = false;
  bool isLoading2 = false;
  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());
  final EmailPassController _emailPassController =
      Get.put(EmailPassController());

  Widget getTextField(
      {required String hint,
      required var icons,
      bool obstxt = null ?? false,
      var suficons,
      required var validator,
      required var controller,
      required var keyboardType}) {
    return TextFormField(
      obscureText: obstxt,
      keyboardType: keyboardType,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
          suffixIcon: suficons,
          errorStyle: const TextStyle(
            color: Colors.yellow,
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          prefixIcon: icons,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          filled: true,
          fillColor: const Color(0xFFF1F4FF),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.black54,
            fontFamily: 'Roboto-Regular',
            fontSize: 15.sp,
            height: 0.h,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _loginKey2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Icon(
                Icons.account_box_rounded,
                size: 100,
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                'Create your account!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              MyTextField(
                  controller: _nameController,
                  hintText: 'Name',
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  suffixIcon: null,
                  prefixIcon: const Icon(Icons.person),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please input your name";
                    }
                    if (!RegExp(r'^[A-Za-z]+([ A-Za-z]+)$').hasMatch(value)) {
                      return "Enter a valid name";
                    }
                  }),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController2,
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
                controller: _passwordController2,
                hintText: 'Password',
                obscureText: !_passwordVisible2,
                prefixIcon: const Icon(
                  Icons.lock,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordVisible2 = !_passwordVisible2;
                    });
                  },
                  icon: Icon(_passwordVisible2
                      ? Icons.visibility
                      : Icons.visibility_off),
                  color: Colors.black,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please input a password";
                  }
                  if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,12}$')
                      .hasMatch(value)) {
                    return "Input a valid password";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
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
                onTap: () async {
                  if (_loginKey2.currentState!.validate()) {
                    _emailPassController.updateLoading();
                    try {
                      _emailPassController.signupUser(_emailController2.text,
                          _passwordController2.text, _nameController.text);
                      if (_emailPassController.currentUser != null) {
                        Get.off(
                            () => EmailValidationScreen(
                                user: _emailPassController.currentUser!),
                            transition: Transition.leftToRightWithFade);
                      } else {
                        Get.snackbar('No User Is', 'currently authenticated',
                            snackPosition: SnackPosition.TOP);
                      }
                    } catch (e) {
                      Get.snackbar('Error', e.toString(),
                          snackPosition: SnackPosition.TOP);
                    } finally {
                      _emailPassController.updateLoading();
                    }
                  }
                },
              ),
              const SizedBox(
                height: 20,
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
                height: 20,
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
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const SignIn(),
                          transition: Transition.leftToRightWithFade);
                    },
                    child: const Text(
                      'Sign In',
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
