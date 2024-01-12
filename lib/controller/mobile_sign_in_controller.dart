import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoes_ferm/view/main_screen.dart';
import '../model/user_model.dart';
import '../view/auth_ui/phone_verify_otp_screen.dart';
import 'device_token_controller.dart';

class SentOtpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetDeviceTokenController getDeviceTokenController =
      Get.put(GetDeviceTokenController());

  void sendOtp(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Get.snackbar("Success", "Automatic Verification Completed");
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar("Error", "Verification Failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          Get.snackbar("Code Sent", "Code Sent to $phoneNumber");
          Get.to(() => VerifyOtp(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          Get.snackbar("Timeout", "Auto Retrieval Timeout: $verificationId");
        },
      );
    } catch (e) {
      Get.snackbar("Error", "Error: $e");
    }
  }

  void verifyOtp(String otp, String verificationId) async {
    try {
      UserCredential userCredential = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp,
        ),
      );

      UserModel userModel = UserModel(
        uId: userCredential.user!.uid,
        username: userCredential.user!.displayName ?? 'test user',
        email: userCredential.user!.email ?? 'testuser@gmail.com',
        phone: userCredential.user!.phoneNumber ?? '',
        userImg: userCredential.user!.photoURL ??
            'https://firebasestorage.googleapis.com/v0/b/dealninja-2b50b.appspot.com/o/User.png?alt=media&token=b2e7d3ec-7ff6-4567-84b5-d9cee26253f2',
        userDeviceToken: getDeviceTokenController.deviceToken.toString(),
        country: '',
        userAddress: '',
        street: '',
        isAdmin: false,
        isActive: true,
        createdOn: DateTime.now(),
        city: '',
      );

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userModel.toMap());
      } catch (error) {
        if (kDebugMode) {
          print('Error saving user data to Firestore: $error');
        }
        Get.snackbar(
          "Error",
          "$error",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      Get.snackbar('Success', 'Registration Successful');
      Get.snackbar("Success", "Verification Successful");
      Get.offAll(() => const MainScreen());
    } catch (e) {
      Get.snackbar("Error", "Verification Failed: $e");
    }
  }
}
