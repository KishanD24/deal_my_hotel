import 'package:flutter/material.dart';

import 'LanguageDataConstant.dart';

class BaseLanguage {
  static BaseLanguage? of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage);

  String get seeAll => getContentValueFromKey(33);

  String get selectBudget => getContentValueFromKey(40);

  String get explorePropertiesBasedOnBHKType => getContentValueFromKey(37);

  String get nearByProperty => getContentValueFromKey(38);

  String get handpickedPropertiesForYou => getContentValueFromKey(39);

  String get explorePropertiesBasedOnBudget => getContentValueFromKey(41);

  String get ownerProperties => getContentValueFromKey(42);

  String get fullyFurnishedProperties => getContentValueFromKey(43);

  String get newsArticles => getContentValueFromKey(44);

  String get readWhatsHappeningInRealEstate => getContentValueFromKey(45);

  String get fetchingYourCurrentLocation => getContentValueFromKey(26);

  String get title_settings => getContentValueFromKey(158);

  String get title_language => getContentValueFromKey(219);

  String get category => getContentValueFromKey(75);

  String get favourite => getContentValueFromKey(148);

  String get privacyPolicy => getContentValueFromKey(206);

  String get termsCondition => getContentValueFromKey(207);

  String get noDataFound => getContentValueFromKey(222);

  String get noInternet => getContentValueFromKey(52);

  String get systemDefault => getContentValueFromKey(263);

  String get setting => getContentValueFromKey(158);

  String get Continue => getContentValueFromKey(78);

  String get cancel => getContentValueFromKey(264);

  String get yes => getContentValueFromKey(48);

  String get chooseTheme => getContentValueFromKey(264);

  String get description => getContentValueFromKey(99);

  String get getStarted => getContentValueFromKey(2);

  String get skip => getContentValueFromKey(1);

  String get language => getContentValueFromKey(242);

  String get country => getContentValueFromKey(113);

  String get city => getContentValueFromKey(116);

  String get address => getContentValueFromKey(111);

  String get save => getContentValueFromKey(170);

  String get selectPropertyType => getContentValueFromKey(232);

  String get email => getContentValueFromKey(175);

  String get chooseImage => getContentValueFromKey(180);

  String get search => getContentValueFromKey(67);

  String get useMyCurrentLocation => getContentValueFromKey(53);

  String get notification => getContentValueFromKey(46);

  String get filter => getContentValueFromKey(266);

  String get postedSince => getContentValueFromKey(63);

  String get anytime => getContentValueFromKey(267);

  String get location => getContentValueFromKey(64);

  String get applyFilter => getContentValueFromKey(268);

  String get fullyFurnished => getContentValueFromKey(269);

  String get resend => getContentValueFromKey(23);

  String get verify => getContentValueFromKey(24);

  String get edit => getContentValueFromKey(131);

  String get subscription => getContentValueFromKey(270);

  String get deleteAccount => getContentValueFromKey(160);

  String get logOut => getContentValueFromKey(162);

  String get firstName => getContentValueFromKey(171);

  String get lastName => getContentValueFromKey(173);

  String get phoneNumber => getContentValueFromKey(177);

  String get next => getContentValueFromKey(271);

  String get individual => getContentValueFromKey(272);

  String get verifyPhoneNumber => getContentValueFromKey(19);

  String get enterPhone => getContentValueFromKey(178);

  String get selectBHK => getContentValueFromKey(36);

  String get explorePropertiesBasedOnBHK => getContentValueFromKey(37);

  String get clearFilter => getContentValueFromKey(61);

  String get forSell => getContentValueFromKey(70);

  String get forRent => getContentValueFromKey(74);

  String get userNotFound => getContentValueFromKey(273);

  String get signIn => getContentValueFromKey(236);

  String get allowLocationPermission => getContentValueFromKey(274);

  String get light => getContentValueFromKey(275);

  String get dark => getContentValueFromKey(276);

  String get myProperty => getContentValueFromKey(156);

  String get lastSearch => getContentValueFromKey(277);

  String get searchAddress => getContentValueFromKey(256);

  String get delete => getContentValueFromKey(132);

  String get logoutMsg => getContentValueFromKey(163);

  String get editProfile => getContentValueFromKey(169);

  String get lastWeek => getContentValueFromKey(277);

  String get yesterday => getContentValueFromKey(278);

  String get chooseLocation => getContentValueFromKey(255);

  String get aboutApp => getContentValueFromKey(159);

  String get bhk => getContentValueFromKey(91);

  String get upTo => getContentValueFromKey(314);

  String get appTheme => getContentValueFromKey(220);

  String get premium => getContentValueFromKey(279);

  String get resultNotFound => getContentValueFromKey(27);

  String get alreadyHaveAccount => getContentValueFromKey(17);

  String get priceRange => getContentValueFromKey(62);

  String get aboutUs => getContentValueFromKey(200);

  String get enterYourMobileNumber => getContentValueFromKey(238);

  String get sell => getContentValueFromKey(280);

  String get rent => getContentValueFromKey(281);

  String get pg => getContentValueFromKey(60);

  String get addNew => getContentValueFromKey(230);

  String get noFoundData => getContentValueFromKey(222);

  String get enterTheConfirmationCodeWeSentTo => getContentValueFromKey(20);

  String get enterOTP => getContentValueFromKey(21);

  String get didntReceiveCode => getContentValueFromKey(22);

  String get enterValidOTP => getContentValueFromKey(25);

  String get success => getContentValueFromKey(282);

  String get failed => getContentValueFromKey(165);

  String get foundState => getContentValueFromKey(55);

  String get searchNotFound => getContentValueFromKey(283);

  String get searchMsg => getContentValueFromKey(57);

  String get searchLocation => getContentValueFromKey(311);

  String get recentSearch => getContentValueFromKey(54);

  String get enterFirstName => getContentValueFromKey(172);

  String get enterLastName => getContentValueFromKey(174);

  String get enterEmail => getContentValueFromKey(176);

  String get signUp => getContentValueFromKey(12);

  String get subscriptionPlans => getContentValueFromKey(183);

  String get active => getContentValueFromKey(184);

  String get history => getContentValueFromKey(185);

  String get subscriptionMsg => getContentValueFromKey(186);

  String get viewPlans => getContentValueFromKey(188);

  String get yourPlanValid => getContentValueFromKey(189);

  String get cancelSubscription => getContentValueFromKey(341);

  String get to => getContentValueFromKey(284);

  String get bePremiumGetUnlimitedAccess => getContentValueFromKey(248);

  String get enjoyUnlimitedAccessWithoutAdsAndRestrictions => getContentValueFromKey(249);

  String get subscribe => getContentValueFromKey(247);

  String get pleaseSelectPlantContinue => getContentValueFromKey(285);

  String get noData => getContentValueFromKey(254);

  String get searchResult => getContentValueFromKey(66);

  String get pgCoLiving => getContentValueFromKey(130);

  String get semiFurnished => getContentValueFromKey(145);

  String get unfurnished => getContentValueFromKey(146);

  String get extraFacilities => getContentValueFromKey(204);

  String get costOfLiving => getContentValueFromKey(134);

  String get NearestByGoogle => getContentValueFromKey(147);

  String get securityDeposit => getContentValueFromKey(105);

  String get maintenanceCharges => getContentValueFromKey(109);

  String get brokerage => getContentValueFromKey(137);

  String get totalExtraCost => getContentValueFromKey(138);

  String get viewOnMap => getContentValueFromKey(140);

  String get congratulations => getContentValueFromKey(208);

  String get yourPropertySubmittedSuccessfully => getContentValueFromKey(209);

  String get previewProperty => getContentValueFromKey(210);

  String get backToHome => getContentValueFromKey(211);

  String get iWantTo => getContentValueFromKey(286);

  String get followUs => getContentValueFromKey(201);

  String get areYouA => getContentValueFromKey(86);

  String get selectCategory => getContentValueFromKey(87);

  String get propertyName => getContentValueFromKey(88);

  String get furnishType => getContentValueFromKey(92);

  String get squareFeetArea => getContentValueFromKey(94);

  String get ageOfProperty => getContentValueFromKey(96);

  String get year => getContentValueFromKey(97);

  String get price => getContentValueFromKey(101);

  String get premiumProperty => getContentValueFromKey(124);

  String get chooseOnMap => getContentValueFromKey(112);

  String get paymentFailed => getContentValueFromKey(287);

  String get submit => getContentValueFromKey(79);

  String get enterPropertyName => getContentValueFromKey(89);

  String get enterSquareFeetArea => getContentValueFromKey(95);

  String get enterAgeOfProperty => getContentValueFromKey(98);

  String get writeSomethingHere => getContentValueFromKey(100);

  String get enterPrice => getContentValueFromKey(102);

  String get enterSecurityDeposit => getContentValueFromKey(106);

  String get enterBrokerage => getContentValueFromKey(108);

  String get enterMaintenanceCharge => getContentValueFromKey(110);

  String get state => getContentValueFromKey(115);

  String get addProperty => getContentValueFromKey(77);

  String get addMainPicture => getContentValueFromKey(118);

  String get addOtherPicture => getContentValueFromKey(119);

  String get addOtherPictures => getContentValueFromKey(120);

  String get videoUrl => getContentValueFromKey(121);

  String get enterVideoUrl => getContentValueFromKey(123);

  String get pleaseSelectCategory => getContentValueFromKey(80);

  String get pleaseSelectMainPicture => getContentValueFromKey(82);

  String get pleaseSelectOtherPicture => getContentValueFromKey(83);

  String get camera => getContentValueFromKey(179);

  String get pleaseSelectBHK => getContentValueFromKey(84);

  String get mobileNumber => getContentValueFromKey(237);

  String get boostYourProperty => getContentValueFromKey(231);

  String get alreadyBoostedYourProperty => getContentValueFromKey(288);

  String get boost => getContentValueFromKey(289);

  String get boostMsg => getContentValueFromKey(290);

  String get payments => getContentValueFromKey(291);

  String get myProfile => getContentValueFromKey(150);

  String get yourCurrentPlan => getContentValueFromKey(151);

  String get addPicture => getContentValueFromKey(117);

  String get viewPropertyLimit => getContentValueFromKey(250);

  String get addPropertyLimit => getContentValueFromKey(252);

  String get advertisementLimit => getContentValueFromKey(253);

  String get unlimited => getContentValueFromKey(191);

  String get advertisement => getContentValueFromKey(154);

  String get contactInfo => getContentValueFromKey(155);

  String get limitExceeded => getContentValueFromKey(292);

  String get limitMsg => getContentValueFromKey(293);

  String get purchase => getContentValueFromKey(223);

  String get paymentSuccessfullyDone => getContentValueFromKey(294);

  String get paymentSuccessfullyMsg => getContentValueFromKey(295);

  String get pleaseSelectLimit => getContentValueFromKey(224);

  String get limit => getContentValueFromKey(225);

  String get contactInfoLimit => getContentValueFromKey(227);

  String get addAdvertisementLimit => getContentValueFromKey(228);

  String get clearMsg => getContentValueFromKey(47);

  String get mailto => getContentValueFromKey(296);

  String get no => getContentValueFromKey(49);

  String get addPropertyHistory => getContentValueFromKey(239);

  String get advertisementHistory => getContentValueFromKey(297);

  String get seenOn => getContentValueFromKey(166);

  String get addRequiredAmenityMessage => getContentValueFromKey(298);

  String get enter => getContentValueFromKey(299);

  String get copiedToClipboard => getContentValueFromKey(300);

  String get updateProperty => getContentValueFromKey(301);

  String get selectFurnishedType => getContentValueFromKey(93);

  String get priceDuration => getContentValueFromKey(103);

  String get selectPriceDuration => getContentValueFromKey(104);

  String get pleaseChooseAddressFromMap => getContentValueFromKey(114);

  String get pleaseAddAmenities => getContentValueFromKey(126);

  String get pleaseSelectPriceDuration => getContentValueFromKey(81);

  String get pleaseSelectAddress => getContentValueFromKey(85);

  String get advertisementProperties => getContentValueFromKey(202);

  String get clearConversion => getContentValueFromKey(51);

  String get aiBot => getContentValueFromKey(50);

  String get addProperties => getContentValueFromKey(205);

  String get chatGpt => getContentValueFromKey(28);

  String get selectCity => getContentValueFromKey(31);

  String get properties => getContentValueFromKey(233);

  String get checkoutNewsArticles => getContentValueFromKey(245);

  String get pay => getContentValueFromKey(164);

  String get gallery => getContentValueFromKey(141);

  String get contactInfoDetails => getContentValueFromKey(181);

  String get propertyContactInfo => getContentValueFromKey(235);

  String get deletePropertyMsg => getContentValueFromKey(133);

  String get property => getContentValueFromKey(143);

  String get found => getContentValueFromKey(68);

  String get estates => getContentValueFromKey(69);

  String get tapToView => getContentValueFromKey(182);

  String get cancelSubscriptionMsg => getContentValueFromKey(340);

  String get cancelledOn => getContentValueFromKey(342);

  String get paymentVia => getContentValueFromKey(343);

  String get deleteAccountMessage => getContentValueFromKey(153);

  String get inquiryFor => getContentValueFromKey(168);

  String get rentProperty => getContentValueFromKey(302);

  String get sellProperty => getContentValueFromKey(303);

  String get pgColivingProperty => getContentValueFromKey(304);

  String get chatbotQue1 => getContentValueFromKey(305);

  String get chatbotQue2 => getContentValueFromKey(306);

  String get chatbotQue3 => getContentValueFromKey(307);

  String get tooManyRequestsPleaseTryAgain => getContentValueFromKey(308);

  String get howCanIHelpYou => getContentValueFromKey(309);

  String get pleaseWait => getContentValueFromKey(312);

  String get confirmAddress => getContentValueFromKey(313);

  String get invalidOtp => getContentValueFromKey(316);

  String get transactionSuccessful => getContentValueFromKey(317);

  String get transactionFailed => getContentValueFromKey(318);

  String get viewPropertyContactHistory => getContentValueFromKey(319);

  String get tapToViewContactInfo => getContentValueFromKey(320);

  String get somethingWentWrong => getContentValueFromKey(259);

  String get WALK1_TITLE => getContentValueFromKey(3);

  String get WALK2_TITLE => getContentValueFromKey(4);

  String get WALK3_TITLE => getContentValueFromKey(5);

  String get WALK1_TITLE1 => getContentValueFromKey(6);

  String get WALK2_TITLE2 => getContentValueFromKey(7);

  String get WALK3_TITLE3 => getContentValueFromKey(8);

  String get WALK1_TITLE_1 => getContentValueFromKey(9);

  String get WALK2_TITLE_2 => getContentValueFromKey(10);

  String get WALK3_TITLE_3 => getContentValueFromKey(11);

  String get thisFieldIsRequired => getContentValueFromKey(321);

  String get errorNotAllow => getContentValueFromKey(322);

  String get owner => getContentValueFromKey(323);

  String get broker => getContentValueFromKey(324);

  String get builder => getContentValueFromKey(325);

  String get agent => getContentValueFromKey(326);

  String get pressBackAgainToExit => getContentValueFromKey(327);

  String get propertyHasBeenSaveSuccessfully => getContentValueFromKey(328);

  String get planHasExpired => getContentValueFromKey(329);

  String get theProvidedPhoneNumberIsNotValid => getContentValueFromKey(330);

  String get phoneVerificationDone => getContentValueFromKey(331);

  String get invalidPhoneNumber => getContentValueFromKey(332);

  String get codeSent => getContentValueFromKey(333);

  String get testPayment => getContentValueFromKey(335);

  String get payWithCard => getContentValueFromKey(336);

  String get daily => getContentValueFromKey(334);

  String get monthly => getContentValueFromKey(337);

  String get quarterly => getContentValueFromKey(338);

  String get yearly => getContentValueFromKey(339);
}
