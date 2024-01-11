import 'package:flutter/material.dart';
import 'package:shoes_ferm/view/widgets/textfield_widget.dart';
import '../widgets/button_widget.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final _phoneController2 = TextEditingController();
  final _loginKey5 = GlobalKey<FormState>();
  bool isLoading6 = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _loginKey5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 75,
                ),
                const Text(
                  'OTP Verification',
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
                    'Enter the OTP code to verify your phone number',
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
                  controller: _phoneController2,
                  hintText: "",
                  obscureText: false,
                  prefixIcon: null,
                  suffixIcon: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please input your OTP";
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
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  onTap: () async {
                    if (_loginKey5.currentState!.validate()) {
                      setState(() {
                        isLoading6 = true;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
