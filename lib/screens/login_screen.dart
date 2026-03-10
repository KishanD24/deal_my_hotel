import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../extensions/app_text_field.dart';
import '../extensions/app_button.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/loader_widget.dart';
import '../extensions/shared_pref.dart';
import '../extensions/text_styles.dart';
import '../languageConfiguration/LanguageDataConstant.dart';
import '../main.dart';
import '../services/auth_service.dart';
import '../utils/app_common.dart';
import '../utils/app_config.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/images.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> mFormKey = GlobalKey<FormState>();
  TextEditingController mMobileNumberCont = TextEditingController();
  FocusNode mMobileFocus = FocusNode();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    if (getStringAsync(PLAYER_ID).isEmpty) {
      await saveOneSignalPlayerId().then((value) {
        //
      });
    }
    getUserUID();
    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void getUserUID() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String uid = user.uid;
        setValue(FIREBASE_USER_ID, uid);
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Error getting user UID: $e");
    }
  }

  Future<void> sendOTP() async {
    if (loginFormKey.currentState!.validate()) {
      loginFormKey.currentState!.save();
      hideKeyboard(context);
      await appStore.setLoading(true);

      String number = '$countryCode${mMobileNumberCont.text.trim()}';
      if (!number.startsWith('+')) {
        number = '$mMobileNumberCont${mMobileNumberCont.text.trim()}';
      }
      await loginWithOTP(context, number, mMobileNumberCont.text.trim(), true, () {}).then((value) {}).catchError((e) async {
        toast(e.toString());
        await appStore.setLoading(false);
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        body: Observer(builder: (context) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(top: context.statusBarHeight + 60, right: 16, left: 16),
                child: Form(
                  key: mFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(alignment: Alignment.center, child: Text(language.signIn, style: boldTextStyle(size: 24))),
                      20.height,
                      Center(child: Image.asset(ic_login, fit: BoxFit.fill, height: context.height() * 0.4)),
                      30.height,
                      Align(alignment: Alignment.topLeft, child: Text(language.mobileNumber + " :", style: primaryTextStyle(size: 18, color: primaryColor, weight: FontWeight.w600))),
                      20.height,
                      Form(
                        key: loginFormKey,
                        child: AppTextField(
                          focus: mMobileFocus,
                          controller: mMobileNumberCont,
                          textFieldType: TextFieldType.PHONE,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          isValidationRequired: true,
                          suffix: mSuffixTextFieldIconWidget(ic_call_outlined),
                          decoration: defaultInputDecoration(context,
                              label: language.enterYourMobileNumber,
                              textStyle: TextStyle(color: grayColor),
                              mPrefix: IntrinsicHeight(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CountryCodePicker(
                                      initialSelection: getCountryCode(),
                                      showCountryOnly: false,
                                      showFlag: false,
                                      boxDecoration: BoxDecoration(borderRadius: radius(defaultRadius), color: context.scaffoldBackgroundColor),
                                      showFlagDialog: true,
                                      showOnlyCountryWhenClosed: false,
                                      alignLeft: false,
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      textStyle: primaryTextStyle(color: grayColor),
                                      onInit: (c) {
                                        countryCode = c!.dialCode!;
                                      },
                                      onChanged: (c) {
                                        countryCode = c.dialCode!;
                                      },
                                    ),
                                    VerticalDivider(color: grayColor, endIndent: 12, indent: 12, width: 5),
                                    18.width,
                                  ],
                                ),
                              )),
                          onFieldSubmitted: (p0) {
                            sendOTP();
                          },
                        ),
                      ),
                      50.height,
                      AppButton(
                        text: language.signIn,
                        color: primaryColor,
                        width: context.width(),
                        textColor: Colors.white,
                        elevation: 0,
                        onTap: () async {
                          await sendOTP();
                        },
                      ),
                      20.height,
                    ],
                  ),
                ),
              ),
              Loader().center().visible(appStore.isLoading)
            ],
          );
        }),
      ),
    );
  }
}
