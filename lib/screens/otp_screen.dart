import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../screens/signup_screen.dart';
import '../services/auth_service.dart';
import '../utils/images.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import '../extensions/app_button.dart';
import '../extensions/common.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/loader_widget.dart';
import '../extensions/shared_pref.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../network/RestApis.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'dashboard_screen.dart';

class OTPScreen extends StatefulWidget {
  final String? verificationId;
  final String? phoneNumber;
  final String? mobileNo;
  final bool? isCodeSent;
  final PhoneAuthCredential? credential;
  final Function? onCall;

  OTPScreen({this.verificationId, this.isCodeSent, this.phoneNumber, this.mobileNo, this.credential, this.onCall});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String otpCode = '';
  Timer? _timer;
  bool isResendEnabled = false;
  int resendTimeout = 60;

  OtpFieldController otpController = OtpFieldController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> resendOTP() async {
    hideKeyboard(context);
    appStore.setLoading(true);
    resendTimeout = 60;
    isResendEnabled = false;
    setState(() {});
    await loginWithOTP(context, widget.phoneNumber.validate().trim(), widget.phoneNumber.validate().trim(), false, () {
      init();
      setState(() {});
    }).then((value) {
      setState(() {
        appStore.setLoading(false);
      });
    }).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  Future<void> submit() async {
    hideKeyboard(context);
    await appStore.setLoading(true);
    AuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId!, smsCode: otpCode);
    await FirebaseAuth.instance.signInWithCredential(credential).then((result) async {
      Map req = {
        "username": widget.phoneNumber!.replaceAll('+', ''),
        "login_type": LoginTypeOTP,
        "user_type": LoginUser,
        "accessToken": widget.phoneNumber!.replaceAll('+', ''),
        "contact_number": widget.phoneNumber,
        'player_id': getStringAsync(PLAYER_ID).validate(),
      };
      await otpLogInApi(req).then((value) async {
        await setValue(IS_OTP, true);
        userStore.setPhoneNo(widget.phoneNumber!.replaceAll('+', ''));
        appStore.setLoading(false);

        if (value.isUserExist == false) {
          finish(context);
          SignUpScreen(phoneNumber: widget.phoneNumber!.replaceAll('+', '')).launch(context);
        } else {
          await appStore.setLogin(true);
          setValue(TOKEN, value.data!.apiToken.validate());
          userStore.setToken(value.data!.apiToken.validate());
          await getUSerDetail(context, value.data!.id.validate()).whenComplete(() {
            DashboardScreen().launch(context, isNewTask: true);
          });
        }
      }).catchError((e) async {
        print("Into otp Screen Error?");
        await appStore.setLoading(false);
        if (e.toString().contains('invalid_username')) {
          finish(context);
          SignUpScreen(phoneNumber: widget.phoneNumber!.replaceAll('+', '')).launch(context);
        } else {
          if (e.toString().contains('OTP is invalid')) toast(language.invalidOtp);
        }
      });
    }).catchError((e) async {
      log("error->" + e.toString());
      toast(e.toString());
      await appStore.setLoading(false);
      setState(() {});
    });
  }

  void init() async {
    await appStore.setLoading(false);
    startResendTimer();
    setState(() {});
    super.initState();
  }

  void startResendTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (resendTimeout != 0) {
        setState(() {
          resendTimeout--;
        });

      } else {
        setState(() {
          isResendEnabled = true;
        });

      }
    });
  }

  String formatTime(int seconds) {
    if (seconds <= 0) {
      return '';
    }

    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return "00:$secondsStr";
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
        systemNavigationBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
      ),
      child: WillPopScope(
        onWillPop: () async {
          finish(context);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: Image.asset(ic_back, color: primaryColor, height: 16, width: 16).onTap(() {
              finish(context);
            }).paddingOnly(top: 20, bottom: 20),
            centerTitle: true,
            backgroundColor: appStore.isDarkModeOn ? scaffoldColorDark : selectIconColor,
            elevation: 0,
            title: Text(
              language.verifyPhoneNumber,
              style: boldTextStyle(size: 18, color: appStore.isDarkModeOn ? selectIconColor : scaffoldColorDark),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                clipBehavior: Clip.none,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: language.enterTheConfirmationCodeWeSentTo,
                            style: secondaryTextStyle(size: 16),
                          ),
                          TextSpan(text: " " + widget.phoneNumber.toString().replaceAll(RegExp(r'(?<=.{3}).(?=.*...)'), '*'), style: boldTextStyle(size: 16, color: grayColor)),
                        ],
                      ),
                    ),

                    20.height,
                    Image.asset(
                      ic_verify,
                      fit: BoxFit.fill,
                      height: context.height() * 0.4,
                    ),
                    20.height,
                    Align(alignment: Alignment.topLeft, child: Text(language.enterOTP, style: boldTextStyle(size: 18, color: primaryColor), textAlign: TextAlign.start)),
                    10.height,
                    OTPTextField(
                        otpFieldStyle: OtpFieldStyle(backgroundColor: appStore.isDarkModeOn ? cardDarkColor : cardLightColor),
                        controller: otpController,
                        length: 6,
                        keyboardType: TextInputType.number,
                        width: MediaQuery.of(context).size.width,
                        fieldWidth: 45,
                        style: primaryTextStyle(),
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldStyle: FieldStyle.box,
                        onChanged: (s) {
                          otpCode = s;
                        },
                        onCompleted: (pin) async {
                          otpCode = pin;
                          submit();

                          setState(() {});
                        }),
                    10.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            Text(language.didntReceiveCode, style: primaryTextStyle(color: grayColor, size: 16)),
                            8.width,
                            isResendEnabled
                                ? Text(language.resend, style: boldTextStyle(color: primaryColor)).paddingAll(2).onTap(() {
                                    setState(() {
                                      // if (isResendEnabled) {
                                      resendOTP();
                                      // _timer = Timer.periodic(Duration(seconds: 1), (Timer t) { });
                                      // isResendEnabled = false;
                                      // }
                                    });
                                  })
                                : SizedBox(),
                            Text(
                              formatTime(resendTimeout),
                              style: primaryTextStyle(),
                            ).paddingAll(2),
                          ],
                        ),
                      ],
                    ),
                    25.height,
                    AppButton(
                      text: language.verify,
                      color: primaryColor,
                      width: context.width(),
                      textColor: Colors.white,
                      elevation: 0,
                      onTap: () async {
                        if (appStore.isLoading == false) {
                          if (otpCode.length == 6) {
                            submit();
                          } else {
                            toast(language.enterValidOTP);
                          }
                        }
                        setState(() {});
                      },
                    ),
                    20.height,
                  ],
                ).paddingSymmetric(horizontal: 20).paddingOnly(top: context.statusBarHeight + 20),
              ),
              Observer(
                builder: (context) {
                  return Loader().center().visible(appStore.isLoading);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
