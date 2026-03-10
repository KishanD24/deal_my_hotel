import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_braintree_payment/flutter_braintree_payment.dart';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart' as payTab;
import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkApms.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutterwave_standard_smart/core/flutterwave.dart';
import 'package:flutterwave_standard_smart/models/requests/customer.dart';
import 'package:flutterwave_standard_smart/models/requests/customizations.dart';
import 'package:flutterwave_standard_smart/models/responses/charge_response.dart';
import 'package:flutterwave_standard_smart/view/view_utils.dart';
import 'package:http/http.dart' as http;
import 'package:mighty_properties/screens/web_view_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../components/app_bar_components.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../utils/images.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../components/payment_success_dialouge.dart';
import '../extensions/LiveStream.dart';
import '../extensions/animatedList/animated_list_view.dart';
import '../extensions/app_button.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/loader_widget.dart';
import '../extensions/shared_pref.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/payment_list_model.dart';
import '../models/stripe_pay_model.dart';
import '../network/RestApis.dart';
import '../network/network_utills.dart';
import '../utils/app_common.dart';
import '../utils/app_config.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'no_data_screen.dart';

class PaymentScreen extends StatefulWidget {
  final int? id;
  final num? price;
  final bool? isFromLimit;

  PaymentScreen({super.key, this.id, this.price, this.isFromLimit});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<PaymentModel> paymentList = [];
  Map<String, Object> paypalValue = {
    "is_test": true,
    "client_id": "1234",
    "client_secret": "1234",
  };

  String? selectedPaymentType,
      stripPaymentKey,
      stripPaymentPublishKey,
      payStackPublicKey,
      payPalTokenizationKey,
      flutterWavePublicKey,
      flutterWaveSecretKey,
      flutterWaveEncryptionKey,
      payTabsProfileId,
      payTabsServerKey,
      payTabsClientKey,
      myFatoorahToken,
      paytmMerchantId,
      orangeMoneyPublicKey,
      paytmMerchantKey;

  String? razorKey;

  bool isPaytmTestType = true;
  bool isFatrooahTestType = true;
  bool loading = false;

  final plugin = PaystackPlugin();

  late Razorpay _razorpay;

  CheckoutMethod method = CheckoutMethod.card;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await paymentListApiCall();
    if (paymentList.any((element) => element.type == PAYMENT_TYPE_STRIPE)) {
      Stripe.publishableKey = stripPaymentPublishKey.validate();
      Stripe.merchantIdentifier = mStripeIdentifier;
      Stripe.merchantIdentifier = 'ADD_YOUR_MERCHANT_IDENTIFIER_HERE';
      Stripe.urlScheme = 'mighty-realestate';
      await Stripe.instance.applySettings().catchError((e) {
        log("${e.toString()}");
      });
    }
    if (paymentList.any((element) => element.type == PAYMENT_TYPE_PAYSTACK)) {
      if (payStackPublicKey != null) {
        plugin.initialize(publicKey: payStackPublicKey.validate());
      }
    }
    if (paymentList.any((element) => element.type == PAYMENT_TYPE_RAZORPAY)) {
      _razorpay = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }
  }

  /// Get Payment Gateway Api Call
  Future<void> paymentListApiCall() async {
    appStore.setLoading(true);
    await getPaymentApi().then((value) {
      appStore.setLoading(false);

      paymentList.addAll(value.data!);

      if (paymentList.isNotEmpty) {
        paymentList.forEach((element) {
          setState(() {});

          if (paymentList.isNotEmpty) {
            if (element.type == PAYMENT_TYPE_STRIPE) {
              stripPaymentKey = element.isTest == 1
                  ? element.testValue!.secretKey
                  : element.liveValue!.secretKey;
              stripPaymentPublishKey = element.isTest == 1
                  ? element.testValue!.publishableKey
                  : element.liveValue!.publishableKey;
            } else if (element.type == PAYMENT_TYPE_PAYSTACK) {
              payStackPublicKey = element.isTest == 1
                  ? element.testValue!.publicKey
                  : element.liveValue!.publicKey;
            } else if (element.type == PAYMENT_TYPE_RAZORPAY) {
              razorKey = element.isTest == 1
                  ? element.testValue!.keyId.validate()
                  : element.liveValue!.keyId.validate();
            } else if (element.type == PAYMENT_TYPE_PAYPAL) {
              if (element.isTest == 1) {
                paypalValue = {
                  "is_test": true,
                  "client_id": "${element.testValue?.publicKey}",
                  "client_secret": "${element.testValue?.secretKey}",
                };
              } else {
                paypalValue = {
                  "is_test": false,
                  "client_id": "${element.liveValue?.publicKey}",
                  "client_secret": "${element.liveValue?.secretKey}",
                };
              }
            } else if (element.type == PAYMENT_TYPE_FLUTTERWAVE) {
              flutterWavePublicKey = element.isTest == 1
                  ? element.testValue!.publicKey
                  : element.liveValue!.publicKey;
              flutterWaveSecretKey = element.isTest == 1
                  ? element.testValue!.secretKey
                  : element.liveValue!.secretKey;
              flutterWaveEncryptionKey = element.isTest == 1
                  ? element.testValue!.encryptionKey
                  : element.liveValue!.encryptionKey;
            } else if (element.type == PAYMENT_TYPE_PAYTABS) {
              payTabsProfileId = element.isTest == 1
                  ? element.testValue!.profileId
                  : element.liveValue!.profileId;
              payTabsClientKey = element.isTest == 1
                  ? element.testValue!.clientKey
                  : element.liveValue!.clientKey;
              payTabsServerKey = element.isTest == 1
                  ? element.testValue!.serverKey
                  : element.liveValue!.serverKey;
            } else if (element.type == PAYMENT_TYPE_MYFATOORAH) {
              if (element.isTest == 1) {
                isFatrooahTestType = true;
              } else {
                isFatrooahTestType = false;
              }
              myFatoorahToken = element.isTest == 1
                  ? element.testValue!.accessToken
                  : element.liveValue!.accessToken;
            } else if (element.type == PAYMENT_TYPE_PAYTM) {
              if (element.isTest == 1) {
                isPaytmTestType = true;
              } else {
                isPaytmTestType = false;
              }
              paytmMerchantId = element.isTest == 1
                  ? element.testValue!.merchantId
                  : element.liveValue!.merchantId;
              paytmMerchantKey = element.isTest == 1
                  ? element.testValue!.merchantKey
                  : element.liveValue!.merchantKey;
            } else if (element.type == PAYMENT_TYPE_ORANGE_MONEY) {
              orangeMoneyPublicKey = element.isTest == 1
                  ? element.testValue!.publicKey
                  : element.liveValue!.publicKey;
            }
          }

          setState(() {});
          // }
        });
      }
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      log("====>" + '${error.toString()}');
    });
  }

  /// My Fatoorah Payment
  Future<void> myFatoorahPayment() async {
    PaymentResponse response = await MyFatoorah.startPayment(
      context: context,
      successChild: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, size: 50, color: Colors.green),
          16.height,
          Text(language.success,
              style: boldTextStyle(color: Colors.green, size: 24)),
        ],
      ).center(),
      errorChild: Center(
          child: Text(language.failed,
              style: boldTextStyle(color: Colors.red, size: 24))),
      request: isFatrooahTestType
          ? MyfatoorahRequest.test(
              currencyIso: Country.SaudiArabia,
              successUrl: 'https://pub.dev/packages/get',
              errorUrl: 'https://www.google.com/',
              invoiceAmount: widget.price.toString().validate().toDouble(),
              language: appStore.selectedLanguage == 'ar'
                  ? ApiLanguage.Arabic
                  : ApiLanguage.English,
              token: myFatoorahToken!,
            )
          : MyfatoorahRequest.live(
              currencyIso: Country.SaudiArabia,
              successUrl: 'https://pub.dev/packages/get',
              errorUrl: 'https://www.google.com/',
              invoiceAmount: widget.price.toString().validate().toDouble(),
              language: appStore.selectedLanguage == 'ar'
                  ? ApiLanguage.Arabic
                  : ApiLanguage.English,
              token: myFatoorahToken!,
            ),
    );
    if (response.isSuccess) {
      paymentConfirm();
    } else if (response.isError) {
      toast(language.paymentFailed);
    }
  }

  /// Razor Pay
  void razorPayPayment() {
    var options = {
      'key': razorKey.validate(),
      'amount': (widget.price!.toDouble() * 100).toInt(),
      'name': APP_NAME,
      'description': mRazorDescription,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': getStringAsync(CONTACT_NUMBER),
        'email': getStringAsync(EMAIL),
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      log(e.toString());
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    toast(language.success);
    paymentConfirm();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    toast("ERROR: " + response.code.toString() + " - " + response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    toast("EXTERNAL_WALLET: " + response.walletName!);
  }

  /// StripPayment
  ///
  void stripePay() async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $stripPaymentKey',
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };

    var request = http.Request('POST', Uri.parse(stripeURL));

    request.bodyFields = {
      'amount': '${(widget.price! * 100).toInt()}',
      'currency': userStore.currencyCode.toLowerCase(),
      'automatic_payment_methods[enabled]': 'true',
    };

    request.headers.addAll(headers);
    appStore.setLoading(true);

    try {
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      print("Stripe PaymentIntent Response: ${response.body}");

      if (response.statusCode == 200) {
        final res = StripePayModel.fromJson(await handleResponse(response));

        final params = SetupPaymentSheetParameters(
          paymentIntentClientSecret: res.clientSecret!,
          merchantDisplayName: APP_NAME,

          // Only THIS is required for MobilePay
          returnURL: 'mighty-realestate://stripe-redirect',

          applePay: PaymentSheetApplePay(
            merchantCountryCode: 'INR',
          ),
          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: 'INR',
            testEnv: true,
          ),
          allowsDelayedPaymentMethods: true,
        );

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: params,
        );

        await Stripe.instance.presentPaymentSheet();
        paymentConfirm();
      } else {
        print("Stripe PaymentIntent Failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Stripe error: $e");
    } finally {
      appStore.setLoading(false);
    }
  }
  // void stripePay() async {
  //   Map<String, String> headers = {
  //     HttpHeaders.authorizationHeader: 'Bearer ${stripPaymentKey.validate()}',
  //     HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
  //   };
  //
  //   var request = http.Request('POST', Uri.parse(stripeURL));
  //
  //   request.bodyFields = {
  //     'amount': '${(widget.price!.toDouble() * 100).toInt()}',
  //     'currency': "${userStore.currencyCode.toUpperCase()}",
  //   };
  //
  //   log(request.bodyFields);
  //   request.headers.addAll(headers);
  //
  //   log(request);
  //
  //   appStore.setLoading(true);
  //
  //   await request.send().then((value) {
  //     http.Response.fromStream(value).then((response) async {
  //       if (response.statusCode == 200) {
  //         var res = StripePayModel.fromJson(await handleResponse(response));
  //
  //         SetupPaymentSheetParameters setupPaymentSheetParameters = SetupPaymentSheetParameters(
  //           paymentIntentClientSecret: res.clientSecret.validate(),
  //           style: ThemeMode.light,
  //           appearance: PaymentSheetAppearance(colors: PaymentSheetAppearanceColors(primary: primaryColor)),
  //           applePay: PaymentSheetApplePay(merchantCountryCode: "${userStore.currencySymbol.toUpperCase()}"),
  //           googlePay: PaymentSheetGooglePay(merchantCountryCode: "${userStore.currencySymbol.toUpperCase()}", testEnv: true),
  //           merchantDisplayName: APP_NAME,
  //           customerId: userStore.userId.toString(),
  //         );
  //
  //         await Stripe.instance.initPaymentSheet(paymentSheetParameters: setupPaymentSheetParameters).then((value) async {
  //           await Stripe.instance.presentPaymentSheet().then((value) async {
  //             paymentConfirm();
  //           });
  //         }).catchError((e) {
  //           log("presentPaymentSheet ${e.toString()}");
  //         });
  //       }
  //       appStore.setLoading(false);
  //     }).catchError((e) {
  //       appStore.setLoading(false);
  //       toast(e.toString());
  //     });
  //   }).catchError((e) {
  //     appStore.setLoading(false);
  //     toast(e.toString());
  //   });
  // }

  ///PayStack Payment
  void payStackPayment(BuildContext context) async {
    appStore.setLoading(true);
    Charge charge = Charge()
      ..amount =
          (widget.price.toString().toDouble() * 100).toInt() // In base currency
      ..email = userStore.email.validate()
      ..currency = userStore.currencyCode.toUpperCase();
    charge.reference = _getReference();

    try {
      CheckoutResponse response = await plugin.checkout(context,
          method: method, charge: charge, fullscreen: false);
      payStackUpdateStatus(response.reference, response.message);
      if (response.message == "Success") {
        appStore.setLoading(false);
        paymentConfirm();
      } else {
        appStore.setLoading(false);

        toast(language.paymentFailed);
      }
    } catch (e) {
      appStore.setLoading(false);
      payStackShowMessage("Check console for error");
      rethrow;
    }
  }

  payStackUpdateStatus(String? reference, String message) {
    payStackShowMessage(message, const Duration(seconds: 7));
  }

  void payStackShowMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    toast(message);
    log(message);
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<String?> getPaypalAccessToken() async {
    String url = paypalValue['is_test'] == true
        ? 'https://api-m.sandbox.paypal.com/v1/oauth2/token'
        : 'https://api-m.paypal.com/v1/oauth2/token';
    String credentials =
        '${paypalValue['client_id']}:${paypalValue['client_secret']}';
    String encodedCredentials = base64Encode(utf8.encode(credentials));

    Map<String, String> headers = {
      'Authorization': 'Basic $encodedCredentials',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    Map<String, String> body = {
      'grant_type': 'client_credentials',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String accessToken = data['access_token'];
        return accessToken;
      } else {
        print('Failed to get token: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  /// Paypal Payment
  void payPalPayments() async {
    appStore.setLoading(true);
    var accessToken = await getPaypalAccessToken();
    String url = paypalValue['is_test'] == true
        ? 'https://api-m.sandbox.paypal.com/v2/checkout/orders'
        : 'https://api-m.paypal.com/v2/checkout/orders';
    Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    Map<String, dynamic> body = {
      'intent': 'CAPTURE',
      'purchase_units': [
        {
          'amount': {
            'currency_code': '${userStore.currencyCode.toUpperCase()}',
            'value': '${(widget.price.toString())}',
          },
          'description': 'Wallet Top UP',
        }
      ],
      'application_context': {
        'return_url': 'https://www.google.com',
        'cancel_url': 'https://login.yahoo.com',
        'shipping_preference': 'NO_SHIPPING',
      }
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        String orderId = data['id'];
        var link = paypalValue['is_test'] == true
            ? "https://www.sandbox.paypal.com/checkoutnow?token=${orderId}"
            : "https://www.paypal.com/checkoutnow?token=${orderId}";
        appStore.setLoading(false);
        launchScreen(
            navigatorKey.currentState!.overlay!.context,
            WebViewScreen(
                onClick: (msg) {
                  if (msg == "Success") {
                    paymentConfirm();
                  }
                },
                mInitialUrl: link));
      } else {
        toast("Payment failed: Invalid token or unsupported currency.");
        appStore.setLoading(false);
        return null;
      }
    } catch (e) {
      appStore.setLoading(false);
      return null;
    }
  }

  void flutterWaveCheckout() async {
    appStore.setLoading(true);
    final customer = Customer(
        name: userStore.username.validate(),
        phoneNumber: userStore.phoneNo.validate(),
        email: userStore.email.validate());

    final Flutterwave flutterwave = Flutterwave(
      context: context,
      publicKey: flutterWavePublicKey.validate(),
      currency: userStore.currencySymbol.validate().toLowerCase(),
      redirectUrl: "https://www.google.com",
      txRef: DateTime.now().millisecond.toString(),
      amount: widget.price.toString(),
      customer: customer,
      paymentOptions: "card, payattitude",
      customization: Customization(title: "Test Payment"),
      isTestMode: isPaytmTestType,
    );
    final ChargeResponse response = await flutterwave.charge();
    if (response.status == 'successful') {
      appStore.setLoading(false);
      paymentConfirm();
      print("${response.toJson()}");
    } else {
      appStore.setLoading(false);
      FlutterwaveViewUtils.showToast(context, "Transaction Failed");
    }
  }

  /// PayTabs Payment
  void payTabsPayment() {
    appStore.setLoading(true);
    FlutterPaytabsBridge.startCardPayment(generateConfig(), (event) {
      setState(() {
        if (event["status"] == "success") {
          var transactionDetails = event["data"];
          if (transactionDetails["isSuccess"]) {
            toast(language.transactionSuccessful);
            paymentConfirm();
          } else {
            toast(language.transactionFailed);
          }
          toast(language.transactionSuccessful);
        } else if (event["status"] == "error") {
          print("error");
        } else if (event["status"] == "event") {
          //
        }
        appStore.setLoading(false);
      });
    });
  }

  PaymentSdkConfigurationDetails generateConfig() {
    List<PaymentSdkAPms> apms = [];
    apms.add(PaymentSdkAPms.STC_PAY);
    var configuration = PaymentSdkConfigurationDetails(
        profileId: payTabsProfileId,
        serverKey: payTabsServerKey,
        clientKey: payTabsClientKey,
        screentTitle: language.payWithCard,
        amount: widget.price!.toDouble(),
        showBillingInfo: true,
        forceShippingInfo: false,
        currencyCode: userStore.currencySymbol.toUpperCase(),
        merchantCountryCode: userStore.currencySymbol.toUpperCase(),
        billingDetails: payTab.BillingDetails(
          userStore.username.validate(),
          userStore.email.validate(),
          userStore.phoneNo.validate(),
          '',
          '',
          '',
          '',
          '',
        ),
        alternativePaymentMethods: apms,
        linkBillingNameWithCardHolderName: true);

    var theme = IOSThemeConfigurations();

    theme.logoImage = ic_logo;

    configuration.iOSThemeConfigurations = theme;

    return configuration;
  }

// payment confirm
  Future<void> paymentConfirm() async {
    appStore.setLoading(true);
    Map req = {
      widget.isFromLimit == true ? "extra_property_limit_id" : "package_id":
          widget.id,
      "payment_status": "paid",
      "payment_type": selectedPaymentType,
      "txn_id": "",
      "transaction_detail": ""
    };
    widget.isFromLimit == true
        ? await purchaseExtraLimitApi(req).then((value) {
            getUSerDetail(context, userStore.userId).then((value) {
              setState(() {
                appStore.setLoading(false);
                LiveStream().emit(PAYMENT);
                finish(context);
                finish(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    return PaymentSuccessDialog(
                      () {},
                    );
                  },
                );
              });
            });
          })
        : await subscribePackageApi(req).then((value) async {
            getUSerDetail(context, userStore.userId).then((value) {
              setState(() {
                appStore.setLoading(false);
                LiveStream().emit(PAYMENT);
                finish(context);
                finish(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    return PaymentSuccessDialog(
                      () {},
                    );
                  },
                );
              });
            });
          }).catchError((e) {
            appStore.setLoading(false);
            print(e.toString());
          });
    appStore.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            appStore.isDarkModeOn ? Brightness.light : Brightness.light,
        systemNavigationBarIconBrightness:
            appStore.isDarkModeOn ? Brightness.light : Brightness.light,
      ),
      child: Scaffold(
        appBar:
            appBarWidget(language.payments, context1: context, titleSpace: 0),
        body: Stack(
          children: [
            paymentList.isNotEmpty
                ? AnimatedListView(
                    shrinkWrap: true,
                    itemCount: paymentList.length,
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemBuilder: (context, index) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: boxDecorationWithRoundedCorners(
                            backgroundColor: appStore.isDarkModeOn
                                ? cardDarkColor
                                : primaryExtraLight),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                                selectedPaymentType == paymentList[index].type
                                    ? ic_radio_fill
                                    : ic_radio,
                                color: primaryColor,
                                height: 24,
                                width: 24),
                            10.width,
                            Row(
                              children: [
                                cachedImage(paymentList[index].gatewayImage!,
                                    width: 45, height: 45, fit: BoxFit.contain),
                                12.width,
                                Text(
                                    paymentList[index]
                                        .title
                                        .validate()
                                        .capitalizeFirstLetter(),
                                    style: primaryTextStyle(),
                                    maxLines: 2),
                              ],
                            ).expand(),
                          ],
                        ),
                      ).onTap(() {
                        selectedPaymentType = paymentList[index].type;
                        setState(() {});
                      });
                    })
                : NoDataScreen().visible(!appStore.isLoading),
            Observer(
              builder: (context) {
                return Loader().center().visible(appStore.isLoading);
              },
            )
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(16),
          child: Visibility(
            visible: paymentList.isNotEmpty,
            child: AppButton(
              text: language.pay,
              color: primaryColor,
              onTap: () {
                if (selectedPaymentType == PAYMENT_TYPE_RAZORPAY) {
                  razorPayPayment();
                } else if (selectedPaymentType == PAYMENT_TYPE_STRIPE) {
                  stripePay();
                } else if (selectedPaymentType == PAYMENT_TYPE_PAYSTACK) {
                  payStackPayment(context);
                } else if (selectedPaymentType == PAYMENT_TYPE_PAYPAL) {
                  payPalPayments();
                } else if (selectedPaymentType == PAYMENT_TYPE_FLUTTERWAVE) {
                  flutterWaveCheckout();
                } else if (selectedPaymentType == PAYMENT_TYPE_PAYTABS) {
                  payTabsPayment();
                } else if (selectedPaymentType == PAYMENT_TYPE_PAYTM) {
                  // paytmPayment();
                } else if (selectedPaymentType == PAYMENT_TYPE_MYFATOORAH) {
                  myFatoorahPayment();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
