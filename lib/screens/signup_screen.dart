import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/app_button.dart';
import '../extensions/app_text_field.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/loader_widget.dart';
import '../extensions/shared_pref.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../network/RestApis.dart';
import '../screens/dashboard_screen.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/images.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key, required this.phoneNumber});

  final String? phoneNumber;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();


  @override
  void initState() {
    phoneController.text = widget.phoneNumber!;
    super.initState();
  }

  void registerApiCall() async {
    if (signUpFormKey.currentState!.validate()) {
      signUpFormKey.currentState!.save();
      hideKeyboard(context);
      appStore.setLoading(true);
      var request = {
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "username": phoneController.text,
        "email": emailController.text,
        "password": getStringAsync(FIREBASE_USER_ID),
        "user_type": LoginUser,
        "login_type": LoginTypeOTP,
        "status": ACTIVE,
        "contact_number": "${"+"}${phoneController.text}",
      };
      await signUpApi(request, context).then((res) async {
        appStore.setLogin(true);
        print(res.data);
        setValue(TOKEN, res.data!.apiToken);
        setValue(USER_ID, res.data!.id);
        userStore.setLogin(true);
        userStore.setToken(res.data!.apiToken.validate());
        setValue(EMAIL, res.data!.email.validate());
        setValue(USER_CONTACT_NUMBER, phoneController.text);
        DashboardScreen().launch(context,isNewTask: true);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
        log(e.toString());
        return;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
        systemNavigationBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: signUpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(language.signUp, style: boldTextStyle(size: 20)).center(),
                    20.height,
                    Image.asset(ic_sign_up, height: context.height() * 0.3, width: context.width(), fit: BoxFit.cover).paddingSymmetric(horizontal: 20),
                    40.height,
                    Text(language.firstName + ":", style: primaryTextStyle()),
                    10.height,
                    AppTextField(
                      controller: firstNameController,
                      textFieldType: TextFieldType.NAME,
                      isValidationRequired: true,
                      focus: firstNameFocus,
                      nextFocus: lastNameFocus,
                      decoration: defaultInputDecoration(context, label: language.enterFirstName),
                    ),
                    20.height,
                    Text(language.lastName + ":", style: primaryTextStyle()),
                    10.height,
                    AppTextField(
                      controller: lastNameController,
                      textFieldType: TextFieldType.NAME,
                      isValidationRequired: true,
                      focus: lastNameFocus,
                      nextFocus: emailFocus,
                      decoration: defaultInputDecoration(context, label: language.enterLastName),
                    ),
                    20.height,
                    Text(language.email + ":", style: primaryTextStyle()),
                    10.height,
                    AppTextField(
                      controller: emailController,
                      textFieldType: TextFieldType.EMAIL,
                      isValidationRequired: true,
                      focus: emailFocus,
                      decoration: defaultInputDecoration(context, label: language.enterEmail),
                      onFieldSubmitted: (p0) {
                        registerApiCall();
                        setState(() {});
                      },
                    ),
                    40.height,
                    AppButton(
                      text: language.signUp,
                      color: primaryColor,
                      width: context.width(),
                      textColor: Colors.white,
                      elevation: 0,
                      onTap: () async {
                        registerApiCall();
                        setState(() {});
                      },
                    ),
                    20.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(language.alreadyHaveAccount, style: primaryTextStyle(color: darkGrayTextColor)),
                        5.width,
                        Text(language.signIn, style: boldTextStyle(color: primaryColor, size: 16)).onTap(() {
                          LoginScreen().launch(context);
                        })
                      ],
                    ),
                    20.height,
                  ],
                ).paddingSymmetric(horizontal: 16).paddingOnly(top: context.statusBarHeight + 16),
              ),
            ),
            Observer(
              builder: (context) {
                return Loader().center().visible(appStore.isLoading);
              }
            )
          ],
        ),
      ),
    );
  }
}
