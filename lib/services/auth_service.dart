import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/common.dart';
import '../main.dart';
import '../screens/otp_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> loginWithOTP(BuildContext context, String phoneNumber, String mobileNo, bool resend, Function? oncall) async {
  print("Phone Number " + phoneNumber.toString());
  print("mobile Number " + mobileNo.toString());

  appStore.setLoading(true);
  return await _auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {},
    verificationFailed: (FirebaseAuthException e) async {
      await appStore.setLoading(false);
      if (e.code == 'invalid-phone-number') {
        // appStore.setLoading(false);
        toast(language.theProvidedPhoneNumberIsNotValid);
        throw 'The provided phone number is not valid.';
      } else {
        toast(e.toString());
        throw e.toString();
      }
    },
    timeout: Duration(minutes: 1),
    codeSent: (String verificationId, int? resendToken) async {
      if (resend == true) {
        OTPScreen(
          verificationId: verificationId,
          isCodeSent: true,
          phoneNumber: phoneNumber,
          mobileNo: mobileNo,
          onCall: () {},
        ).launch(context);
      }
      return;
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      //
    },
  );
}

sendOtp(BuildContext context, {required String phoneNumber, required Function(String) onUpdate}) async {
  appStore.setLoading(true);
  try {
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        appStore.setLoading(false);
        toast(language.phoneVerificationDone);

        // toast(language.verificationCompleted);
      },
      verificationFailed: (FirebaseAuthException e) {
        appStore.setLoading(false);
        if (e.code == 'invalid-phone-number') {
          toast(language.invalidPhoneNumber);
          // throw language.phoneNumberInvalid;
        } else {
          toast(e.message.toString());
          throw e.message.toString();
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        appStore.setLoading(false);
        toast(language.codeSent);
        onUpdate.call(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        appStore.setLoading(false);
      },
    );
  } on FirebaseException catch (error) {
    appStore.setLoading(false);
    toast(error.message);
  }
}
