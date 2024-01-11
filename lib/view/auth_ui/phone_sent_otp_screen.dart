import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_ferm/view/widgets/textfield_widget.dart';
import '../widgets/button_widget.dart';

class SentOtp extends StatefulWidget {
  const SentOtp({super.key});

  @override
  State<SentOtp> createState() => _SentOtpState();
}

class _SentOtpState extends State<SentOtp> {
  final _phoneController1 = TextEditingController();
  final _loginKey4 = GlobalKey<FormState>();
  bool isLoading4 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _loginKey4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 75,
              ),
              const Text(
                'Enter your phone number',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 75,
              ),
              SizedBox(
                width: 300,
                height: 60,
                child: Text(
                  'We will send you a 6-digit verification code to your phone number.',
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              MyTextField(
                keyboardType: TextInputType.phone,
                controller: _phoneController1,
                hintText: "",
                obscureText: false,
                prefixIcon: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      "+91",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                suffixIcon: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please input your phone number";
                  }
                  if (!RegExp(r'^(\+91[\-\s]?)?0?(91)?[789]\d{9}$')
                      .hasMatch(value)) {
                    return "Enter a valid phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              MyButton(
                child: const Center(
                  child: Text(
                    "GENERATE OTP",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                onTap: () async {
                  if (_loginKey4.currentState!.validate()) {
                    Get.snackbar(
                        'Phone services not available', 'Sign in with google');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
