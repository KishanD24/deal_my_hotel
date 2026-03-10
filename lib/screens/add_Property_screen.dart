import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import '../components/app_bar_components.dart';
import '../components/drop_down_component.dart';
import '../components/radio_component.dart';
import '../components/required_validation.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/bool_extensions.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../screens/subscribe_screen.dart';
import '../screens/success_property_add_screen.dart';
import '../utils/colors.dart';
import '../components/AmenityTextFiledComponent.dart';
import '../components/checkbox_Component.dart';
import '../extensions/animatedList/animated_wrap.dart';
import '../extensions/app_button.dart';
import '../extensions/app_text_field.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/horizontal_list.dart';
import '../extensions/loader_widget.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/base_response.dart';
import '../models/category_list_model.dart';
import '../models/dynamic_model.dart';
import '../models/place_address_model.dart';
import '../models/property_details_model.dart';
import '../network/RestApis.dart';
import '../network/network_utills.dart';
import '../utils/app_common.dart';
import '../utils/constants.dart';
import '../utils/images.dart';
import 'google_map_screen.dart';

class AddPropertyScreen extends StatefulWidget {
  final bool? updateProperty;
  final int? pId;
  final int? propertyFor;
  final PropertyDetailsModel? updatePropertyData;

  AddPropertyScreen(
      {this.propertyFor,
      this.updateProperty = false,
      this.pId,
      this.updatePropertyData});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  GlobalKey<FormState> mSecondComponentFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> mThirdComponentFormKey = GlobalKey<FormState>();

  TextEditingController propertyNameController = TextEditingController();
  TextEditingController brokerageController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController depositController = TextEditingController();
  TextEditingController mChargesController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController videoUrlController = TextEditingController();
  TextEditingController ageOfPropertyController = TextEditingController();
  TextEditingController mapLocation = TextEditingController();

  FocusNode propertyNameFocus = FocusNode();
  FocusNode brokerageFocus = FocusNode();
  FocusNode areaCFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  FocusNode depositFocus = FocusNode();
  FocusNode mChargesFocus = FocusNode();
  FocusNode countryFocus = FocusNode();
  FocusNode stateFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode videoUrlFocus = FocusNode();
  FocusNode ageOfPropertyFocus = FocusNode();
  FocusNode mapFocus = FocusNode();

  List<CategoryData> categoryData = [];
  List<ABC> listTest = [];
  ABC? selectedValue;

  getList() {
    listTest.add(ABC(0, language.daily, DURATION_DAILY));
    listTest.add(ABC(1, language.monthly, DURATION_MONTHLY));
    listTest.add(ABC(2, language.quarterly, DURATION_QUARTERLY));
    listTest.add(ABC(3, language.yearly, DURATION_YEARLY));
  }

  List<String> propertySellerType = [OWNER, BROKER, BUILDER];
  List<String> bhkList = List.generate(
    100,
    (index) => (index + 1).toString(),
  );

  // List<String> bhkList = [
  //   "1",
  //   "2",
  //   "3",
  //   "4",
  //   "5",
  //   "6",
  //   "7",
  //   "8",
  //   "9",
  //   "10",
  // ];

  List<String> furnishedTypeList = [UNFURNISHED, FULLY, SEMI];
  List<AmenityName> amenityValueData = [];
  List<AmenityName>? newAmenityValueData;
  List<AmenityDynamicModel> dynamicAmenityList = [];
  List<String> selectedImages = [];
  List<XFile>? imageFileList = [];
  List<String> existingImages = [];
  List<String> priceDuration = [
    DURATION_DAILY,
    DURATION_MONTHLY,
    DURATION_QUARTERLY,
    DURATION_YEARLY
  ];

  // List<String> priceDuration = [DURATION_DAILY, DURATION_MONTHLY, DURATION_QUARTERLY, DURATION_YEARLY];
  String? mUserType;
  String? mFurnishedType;
  String? priceDurationValue;

  int sellerType = 0;
  int? furnishedType;
  int page = 1;
  int? numPage;
  int? selectedCategoryId;
  int? selectedBhkIndex;

  bool isLastPage = false;
  bool isAmenityIsEmpty = false;
  bool isPremium = false;
  bool isCategoryChanged = false;

  XFile? imageMain;
  String? mainImagePath;
  Uint8List? mainImage;
  String? mainImageName;

  PropertyDetailsModel? updatePropertyData;
  num? latitude;
  num? longitude;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    selectedBhkIndex = bhkList.first.toInt();
    mFurnishedType = furnishedTypeList.first.validate();
    furnishedType = furnishedTypeList.first.toInt();

    getList();

    priceDurationValue = listTest.first.value.validate();

    setUpdatePropertyData();
    await getPropertyCategory();
    print("---" + priceDurationValue.toString());
    setState(() {});
  }

  //region update property data
  setUpdatePropertyData() {
    if (widget.updateProperty.validate()) {
      updatePropertyData = widget.updatePropertyData;
      propertyNameController.text = updatePropertyData!.data!.name.toString();
      selectedBhkIndex = updatePropertyData!.data!.bhk;
      priceDurationValue =
          updatePropertyData!.data!.priceDuration.capitalizeFirstLetter();

      areaController.text = updatePropertyData!.data!.sqft.toString();
      ageOfPropertyController.text =
          updatePropertyData!.data!.ageOfProperty.toString();
      descriptionController.text =
          updatePropertyData!.data!.description.toString();
      priceController.text = updatePropertyData!.data!.price.toString();
      depositController.text =
          updatePropertyData!.data!.securityDeposit.toString();
      brokerageController.text = updatePropertyData!.data!.brokerage.toString();
      mChargesController.text =
          updatePropertyData!.data!.maintenance.toString();
      mapLocation.text = updatePropertyData!.data!.address.toString();
      countryController.text = updatePropertyData!.data!.country.toString();
      stateController.text = updatePropertyData!.data!.state.toString();
      cityController.text = updatePropertyData!.data!.city.toString();
      mainImagePath = updatePropertyData!.data!.propertyImage.toString();
      videoUrlController.text =
          updatePropertyData!.data!.videoUrl.toString().isEmptyOrNull
              ? " "
              : updatePropertyData!.data!.videoUrl.toString();
      newAmenityValueData = updatePropertyData!.propertyAmenityValue!;
      furnishedType = updatePropertyData!.data!.furnishedType;
      isPremium = updatePropertyData!.data!.premiumProperty == 1 ? true : false;
      updatePropertyData!.data!.propertyGallary!.forEach((element) {
        selectedImages.add(element);
        existingImages.add(element);
      });
      latitude = updatePropertyData!.data!.latitude.toDouble();
      longitude = updatePropertyData!.data!.longitude.toDouble();
      setState(() {});
    }
  }

  //endregion

  // region Add Properties Api
  Future saveProperty() async {
    hideKeyboard(context);
    appStore.setLoading(true);

    MultipartRequest multiPartRequest = !widget.updateProperty.validate()
        ? await getMultiPartRequest('property-save')
        : await getMultiPartRequest('property-update/${widget.pId}');
    multiPartRequest.fields['name'] = propertyNameController.text;
    multiPartRequest.fields['category_id'] = selectedCategoryId.toString();
    if (widget.propertyFor == 0 || widget.propertyFor == 2)
      multiPartRequest.fields['price_duration'] =
          priceDurationValue!.toLowerCase();
    multiPartRequest.fields['price'] = priceController.text;
    multiPartRequest.fields['furnished_type'] = furnishedType.toString();
    multiPartRequest.fields['saller_type'] = sellerType.toString();
    multiPartRequest.fields['property_for'] = widget.propertyFor.toString();
    multiPartRequest.fields['age_of_property'] = ageOfPropertyController.text;
    multiPartRequest.fields['maintenance'] = mChargesController.text;
    multiPartRequest.fields['security_deposit'] = depositController.text;
    multiPartRequest.fields['brokerage'] = brokerageController.text;
    multiPartRequest.fields['bhk'] = selectedBhkIndex.toString();
    multiPartRequest.fields['sqft'] = areaController.text;
    multiPartRequest.fields['description'] = descriptionController.text;
    multiPartRequest.fields['country'] = countryController.text;
    multiPartRequest.fields['state'] = stateController.text;
    multiPartRequest.fields['city'] = cityController.text;
    multiPartRequest.fields['latitude'] = latitude.toString();
    multiPartRequest.fields['longitude'] = longitude.toString();
    multiPartRequest.fields['address'] = mapLocation.text;
    multiPartRequest.fields['video_url'] = videoUrlController.text;
    multiPartRequest.fields['status'] = PROPERTY_ACTIVE;
    multiPartRequest.fields['premium_property'] = isPremium == true ? '1' : '0';
    isAmenityIsEmpty = false;
    dynamicAmenityList.forEach((element) {
      if (!element.dynamicAmenityValue.toString().isEmptyOrNull) {
        if (element.dynamicAmenityValue is String) {
          multiPartRequest
                  .fields['amenity_' + element.dynamicAmenityId.toString()] =
              element.dynamicAmenityValue;
          log(multiPartRequest
              .fields['amenity_' + element.dynamicAmenityId.toString()]);
        } else if (element.dynamicAmenityValue is List) {
          List data = [];
          data.add(element.dynamicAmenityValue);
          multiPartRequest
                  .fields['amenity_' + element.dynamicAmenityId.toString()] =
              data.toString().replaceAll('[[', '[').replaceAll(']]', ']');
          log(multiPartRequest
              .fields['amenity_' + element.dynamicAmenityId.toString()]);
        }
      } else if (element.dynamicAmenityValue.toString().isEmptyOrNull) {
        isAmenityIsEmpty = true;
      }
      setState(() {});
    });
    if (isAmenityIsEmpty) {
      // toast(language.addRequiredAmenityMessage);
      appStore.setLoading(false);
    }

    if (imageMain != null) {
      if (!mainImage!.contains('https'))
        multiPartRequest.files.add(MultipartFile.fromBytes(
            'property_image', mainImage!,
            filename: mainImageName));
    }

    for (var i = 0; i < existingImages.length; i++) {
      multiPartRequest.fields['property_gallary[]'] = existingImages[i];
    }
    for (var i = 0; i < selectedImages.length; i++) {
      if (!selectedImages[i].contains('https')) {
        var file = File(selectedImages[i]);
        multiPartRequest.files.add(
          MultipartFile.fromBytes(
              'property_gallary[]', await file.readAsBytes(),
              filename: 'image$i.jpg'),
        );
      }
    }

    if (!isAmenityIsEmpty) {
      multiPartRequest.headers.addAll(buildHeaderTokens());
      sendMultiPartRequest(
        multiPartRequest,
        onSuccess: (data) async {
          if ((data as String).isJson()) {
            EPropertyBaseResponse res =
                EPropertyBaseResponse.fromJson(jsonDecode(data));
            appStore.setLoading(false);
            if (res.message == "Property has been save successfully") {
              toast(res.message.toString());
              SuccessPropertyScreen(propertyId: res.propertyId).launch(context);
              appStore.addPropertyIndex = 0;
            } else if (res.message == "Plan Has Expired") {
              toast(res.message.toString());

              SubscribeScreen().launch(context);
            } else {
              toast(res.message.toString());

              appStore.addPropertyIndex = 0;
              finish(context, true);
            }
          }
          isAmenityIsEmpty = false;
        },
        onError: (error) {
          log(multiPartRequest.toString());
          toast(error.toString());
        },
      ).catchError((e) {
        toast(e.toString());
      }).whenComplete(() => appStore.setLoading(false));
    } else {
      isAmenityIsEmpty = false;
      toast(language.addRequiredAmenityMessage);
      setState(() {});
    }
  }

  //end region

  Future<void> getPropertyCategory() async {
    appStore.setLoading(true);
    await getCategory().then((value) {
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        categoryData.clear();
      }
      categoryData = value.data!;
      if (widget.updateProperty.validate()) {
        categoryData.contains(updatePropertyData!.data!.categoryId);
        selectedCategoryId = updatePropertyData!.data!.categoryId;
      }
      setState(() {});
    }).catchError((e) {
      print("Error is " + e.toString());
      isLastPage = true;
    }).whenComplete(() => appStore.setLoading(false));
  }

  addSelectedCategoryData() {
    for (int i = 0; i < categoryData.length; i++) {
      if (selectedCategoryId == categoryData[i].id) {
        amenityValueData = categoryData[i].amenityName!;
      }
      setState(() {});
    }
    dynamicAmenityList.clear();
    if (!widget.updateProperty.validate()) {
      isCategoryChanged = false;
      amenityValueData.forEach((element) {
        AmenityDynamicModel dynamicModel = AmenityDynamicModel();
        dynamicModel.dynamicAmenityId = element.id;
        dynamicAmenityList.add(dynamicModel);
      });
    } else {
      if (selectedCategoryId == updatePropertyData!.data!.categoryId) {
        isCategoryChanged = false;
        if (newAmenityValueData == [] && newAmenityValueData!.isEmpty) {
          newAmenityValueData = updatePropertyData!.propertyAmenityValue!;
        }
        newAmenityValueData!.forEach((element) {
          AmenityDynamicModel dynamicModel = AmenityDynamicModel();
          dynamicModel.dynamicAmenityId = element.amenityId;
          dynamicModel.dynamicAmenityValue = element.value;
          dynamicAmenityList.add(dynamicModel);
        });
      } else {
        isCategoryChanged = true;
        amenityValueData.forEach((element) {
          AmenityDynamicModel dynamicModel = AmenityDynamicModel();
          dynamicModel.dynamicAmenityId = element.id;
          dynamicAmenityList.add(dynamicModel);
        });
        // newAmenityValueData!.clear();
      }
    }
    dynamicAmenityList.forEach((element) {
      log("=======Dynamic Amenity List ${element.toJson().toString()}");
    });
  }

  ///SelectSingleImage
  Future getImage() async {
    imageMain = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);
    mainImagePath = imageMain!.path;
    mainImage = await imageMain!.readAsBytes();
    mainImageName = imageMain!.name;

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: appBarWidget(
          widget.updateProperty.validate()
              ? language.updateProperty
              : language.addProperty,
          context1: context,
          titleSpace: 0,
          showBack: true,
          actions: [
            Text("${appStore.addPropertyIndex + 1}" + "/" + "3",
                    style: secondaryTextStyle())
                .paddingOnly(right: 30, top: 15),
          ],
          backWidget: Icon(Octicons.chevron_left, color: primaryColor, size: 28)
              .onTap(() {
            print(appStore.addPropertyIndex.toString());
            setState(() {
              if (appStore.addPropertyIndex == 0) {
                finish(context);
                finish(context);
              } else {
                appStore.addPropertyIndex--;
              }
            });
          }),
          elevation: 0,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(3, (i) {
                    return Container(
                      alignment: Alignment.center,
                      height: 3,
                      width: context.width() / 3.5,
                      decoration: boxDecorationWithRoundedCorners(
                          backgroundColor: appStore.addPropertyIndex >= i
                              ? primaryColor
                              : dividerColor),
                    );
                  }).toList(),
                ).paddingSymmetric(horizontal: 12),
                ListView(
                  children: [
                    if (appStore.addPropertyIndex == 0) addPropertyComponent1(),
                    if (appStore.addPropertyIndex == 1) addPropertyComponent2(),
                    if (appStore.addPropertyIndex == 2) addPropertyComponent3(),
                  ],
                ).expand()
              ],
            ),
            Loader().center().visible(appStore.isLoading),
          ],
        ),
        bottomNavigationBar: AppButton(
          text: appStore.addPropertyIndex == 0 || appStore.addPropertyIndex == 1
              ? language.Continue
              : language.submit,
          width: context.width(),
          color: primaryColor,
          textColor: Colors.white,
          onTap: () {
            if (appStore.addPropertyIndex == 0) {
              if (selectedCategoryId != null) {
                appStore.addPropertyIndex = 1;
              } else {
                toast(language.pleaseSelectCategory);
              }
            } else if (appStore.addPropertyIndex == 1) {
              if (mSecondComponentFormKey.currentState!.validate()) {
                if (widget.propertyFor == 0 || widget.propertyFor == 2) {
                  if (priceDurationValue != null &&
                      selectedImages.isNotEmpty &&
                      mainImagePath != null &&
                      selectedBhkIndex != null &&
                      latitude != null &&
                      longitude != null &&
                      mapLocation.text.isNotEmpty) {
                    appStore.addPropertyIndex = 2;
                  } else {
                    if (priceDurationValue.isEmptyOrNull)
                      toast(language.pleaseSelectPriceDuration);
                    if (mainImagePath.isEmptyOrNull)
                      toast(language.pleaseSelectMainPicture);
                    if (selectedImages.isEmpty)
                      toast(language.pleaseSelectOtherPicture);
                    if (selectedBhkIndex == null)
                      toast(language.pleaseSelectBHK);
                    if (mapLocation.text.isEmpty)
                      toast(language.pleaseSelectAddress);
                  }
                } else {
                  if (selectedImages.isNotEmpty &&
                      mainImagePath != null &&
                      selectedBhkIndex != null) {
                    appStore.addPropertyIndex = 2;

                    setState(() {});
                  } else {
                    if (mainImagePath == null)
                      toast(language.pleaseSelectMainPicture);
                    if (selectedImages.isEmpty)
                      toast(language.pleaseSelectOtherPicture);
                    if (selectedBhkIndex == null)
                      toast(language.pleaseSelectBHK);
                  }
                }
              }
              log('Selected index $selectedCategoryId');
              addSelectedCategoryData();
            } else {
              if (mThirdComponentFormKey.currentState!.validate()) {
                saveProperty();
              }
            }
            setState(() {});
          },
        ).paddingOnly(right: 16, bottom: 16, left: 16, top: 0),
      );
    });
  }

  //region Add property steps

  Widget addPropertyComponent1() {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.height,
            Text(language.areYouA, style: primaryTextStyle()),
            10.height,
            DropdownButtonFormField<String>(
                dropdownColor:
                    appStore.isDarkModeOn ? cardDarkColor : selectIconColor,
                items: propertySellerType
                    .map(
                      (value) => DropdownMenuItem<String>(
                        child: Text(value, style: primaryTextStyle()),
                        value: value,
                      ),
                    )
                    .toList(),
                isExpanded: false,
                isDense: true,
                borderRadius: radius(),
                decoration: defaultInputDecoration(context),
                value: sellerType == 0
                    ? OWNER
                    : sellerType == 1
                        ? BROKER
                        : sellerType == 2
                            ? BUILDER
                            : mUserType,
                onChanged: (String? value) {
                  mUserType = value.validate();
                  if (mUserType == OWNER) {
                    sellerType = 0;
                  } else if (mUserType == BROKER) {
                    sellerType = 1;
                  } else {
                    sellerType = 2;
                  }
                  setState(() {});
                  print("====" + sellerType.toString());
                  print("====" + propertySellerType.toString());
                }),
            20.height,
            Text(language.selectCategory, style: primaryTextStyle()),
            20.height,
            AnimatedWrap(
              runSpacing: 16,
              spacing: 16,
              children: List.generate(
                categoryData.length,
                (i) {
                  return Container(
                    width: context.width() * 0.42,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: categoryData[i].id == selectedCategoryId
                          ? primaryColor
                          : appStore.isDarkModeOn
                              ? cardDarkColor
                              : primaryExtraLight,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        cachedImage(categoryData[i].categoryImage,
                                height: 30, width: 30, fit: BoxFit.fill)
                            .cornerRadiusWithClipRRect(8),
                        10.width,
                        Text(categoryData[i].name.toString(),
                                style: secondaryTextStyle(
                                    size: 16,
                                    color:
                                        categoryData[i].id == selectedCategoryId
                                            ? Colors.white
                                            : grayColor))
                            .expand(),
                      ],
                    ),
                  ).onTap(() {
                    selectedCategoryId = categoryData[i].id!;
                    setState(() {});
                  });
                },
              ),
            )
          ],
        ).visible(!appStore.isLoading).paddingSymmetric(horizontal: 16)
      ],
    );
  }

  Widget addPropertyComponent2() {
    return SingleChildScrollView(
      child: Form(
        key: mSecondComponentFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.height,
            RequiredValidationText(
                required: true, titleText: language.propertyName),
            10.height,
            AppTextField(
              controller: propertyNameController,
              focus: propertyNameFocus,
              textFieldType: TextFieldType.NAME,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.go,
              decoration: defaultInputDecoration(context,
                  label: language.enterPropertyName),
            ),
            20.height,
            RequiredValidationText(
                required: true, titleText: language.selectBHK),
            10.height,
            HorizontalList(
              itemCount: bhkList.length,
              itemBuilder: (BuildContext context, int i) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  decoration: boxDecorationWithRoundedCorners(
                      borderRadius: BorderRadius.circular(8.0),
                      backgroundColor: selectedBhkIndex == bhkList[i].toInt()
                          ? primaryColor
                          : appStore.isDarkModeOn
                              ? cardDarkColor
                              : primaryExtraLight),
                  child: Text(bhkList[i].toString() + " " + language.bhk,
                          style: primaryTextStyle(
                              color: selectedBhkIndex == bhkList[i].toInt()
                                  ? Colors.white
                                  : grayColor))
                      .center(),
                ).onTap(() {
                  selectedBhkIndex = bhkList[i].toInt();
                  setState(() {});
                });
              },
            ),
            20.height,
            RequiredValidationText(
                required: true, titleText: language.furnishType),
            10.height,
            DropdownButtonFormField(
              hint:
                  Text(language.selectFurnishedType, style: primaryTextStyle()),
              items: furnishedTypeList
                  .map((value) => DropdownMenuItem<String>(
                      child: Text(value, style: primaryTextStyle()),
                      value: value))
                  .toList(),
              isExpanded: false,
              isDense: true,
              borderRadius: radius(),
              decoration: defaultInputDecoration(context),
              value: furnishedType == 0
                  ? UNFURNISHED
                  : furnishedType == 1
                      ? FULLY
                      : furnishedType == 2
                          ? SEMI
                          : mFurnishedType,
              onChanged: (String? value) {
                mFurnishedType = value.validate();

                if (mFurnishedType == UNFURNISHED) {
                  furnishedType = 0;
                } else if (mFurnishedType == FULLY) {
                  furnishedType = 1;
                } else {
                  furnishedType = 2;
                }
                setState(() {});
              },
            ),
            20.height,
            RequiredValidationText(
                required: true, titleText: language.squareFeetArea),
            10.height,
            AppTextField(
              isValidationRequired: true,
              textInputAction: TextInputAction.go,
              controller: areaController,
              focus: areaCFocus,
              textFieldType: TextFieldType.NAME,
              keyboardType: TextInputType.name,
              decoration: defaultInputDecoration(context,
                  label: language.enterSquareFeetArea),
            ),
            20.height,
            RequiredValidationText(
                required: true,
                titleText: language.ageOfProperty + language.year),
            10.height,
            AppTextField(
              isValidationRequired: true,
              textInputAction: TextInputAction.go,
              controller: ageOfPropertyController,
              focus: ageOfPropertyFocus,
              textFieldType: TextFieldType.NUMBER,
              keyboardType: TextInputType.number,
              decoration: defaultInputDecoration(context,
                  label: language.enterAgeOfProperty),
            ),
            20.height,
            RequiredValidationText(
                required: true, titleText: language.description),
            10.height,
            AppTextField(
              isValidationRequired: true,
              textInputAction: TextInputAction.go,
              controller: descriptionController,
              focus: descriptionFocus,
              textFieldType: TextFieldType.MULTILINE,
              keyboardType: TextInputType.multiline,
              decoration: defaultInputDecoration(context,
                  label: language.writeSomethingHere),
              minLines: 3,
              maxLines: 3,
            ),
            20.height,
            RequiredValidationText(required: true, titleText: language.price),
            10.height,
            AppTextField(
              textInputAction: TextInputAction.go,
              controller: priceController,
              focus: priceFocus,
              textFieldType: TextFieldType.NUMBER,
              keyboardType: TextInputType.number,
              decoration: defaultInputDecoration(
                context,
                label: language.enterPrice,
              ),
            ),
            20.height,
            if (widget.propertyFor == 0 || widget.propertyFor == 2)
              RequiredValidationText(
                  required: true, titleText: language.priceDuration),
            10
                .height
                .visible(widget.propertyFor == 0 || widget.propertyFor == 2),
            // if (widget.propertyFor == 0 || widget.propertyFor == 2)
            //   DropdownButtonFormField(
            //     hint: Text(language.selectPriceDuration, style: primaryTextStyle()),
            //     items: priceDuration.map((value) => DropdownMenuItem<String>(child: Text(value, style: primaryTextStyle()), value: value)).toList(),
            //     isExpanded: false,
            //     isDense: true,
            //     borderRadius: radius(),
            //     decoration: defaultInputDecoration(context),
            //     value: priceDurationValue,
            //     onChanged: (String? value) {
            //       priceDurationValue = value.validate();
            //       // priceDurationValueSend = priceDurationValue!.toLowerCase();
            //       print("Price Duration Value" + priceDurationValue.toString());
            //
            //       setState(() {});
            //     },
            //   ).visible(widget.propertyFor == 0 || widget.propertyFor == 2),
            if (widget.propertyFor == 0 || widget.propertyFor == 2)
              DropdownButtonFormField<ABC>(
                  hint: Text(language.selectPriceDuration,
                      style: primaryTextStyle()),
                  items: listTest
                      .map((ABC testss) => DropdownMenuItem<ABC>(
                          child: Text(testss.title.validate(),
                              style: primaryTextStyle()),
                          value: testss))
                      .toList(),
                  isExpanded: false,
                  isDense: true,
                  borderRadius: radius(),
                  decoration: defaultInputDecoration(context),
                  value: selectedValue,
                  onChanged: (ABC? value) {
                    selectedValue = value;
                    priceDurationValue = value!.value.validate();

                    print(
                        "Price Duration Value" + priceDurationValue.toString());
                    print("Price Duration Value" + selectedValue.toString());

                    setState(() {});
                  }),

            20
                .height
                .visible(widget.propertyFor == 0 || widget.propertyFor == 2),
            RequiredValidationText(
                required: true, titleText: language.securityDeposit),
            10.height,
            AppTextField(
              textInputAction: TextInputAction.go,
              controller: depositController,
              focus: depositFocus,
              textFieldType: TextFieldType.NUMBER,
              keyboardType: TextInputType.number,
              decoration: defaultInputDecoration(context,
                  label: language.enterSecurityDeposit),
            ),
            20.height,
            RequiredValidationText(
                required: true, titleText: language.brokerage),
            10.height,
            AppTextField(
              textInputAction: TextInputAction.go,
              controller: brokerageController,
              focus: brokerageFocus,
              textFieldType: TextFieldType.NUMBER,
              keyboardType: TextInputType.number,
              decoration: defaultInputDecoration(context,
                  label: language.enterBrokerage),
            ),
            20.height,
            RequiredValidationText(
                required: true, titleText: language.maintenanceCharges),
            10.height,
            AppTextField(
              textInputAction: TextInputAction.go,
              controller: mChargesController,
              focus: mChargesFocus,
              textFieldType: TextFieldType.NUMBER,
              keyboardType: TextInputType.number,
              decoration: defaultInputDecoration(context,
                  label: language.enterMaintenanceCharge),
            ),
            20.height,
            RequiredValidationText(required: true, titleText: language.address),
            10.height,
            GestureDetector(
              onTap: () async {
                PlaceAddressModel? res = await GoogleMapScreen(
                  onAddress: address,
                  cityCountryState: cityStateCountry,
                  isFromMap: true,
                  onLatLong: latLongFunction,
                ).launch(context);
                if (res != null) {}
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: appStore.isDarkModeOn
                        ? cardDarkColor
                        : primaryExtraLight,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.my_location, color: grayColor),
                    10.width,
                    Text(language.chooseOnMap, style: secondaryTextStyle()),
                  ],
                ),
              ),
            ),
            10.height,
            AppTextField(
              isValidationRequired: true,
              maxLines: 3,
              controller: mapLocation,
              focus: mapFocus,
              textFieldType: TextFieldType.OTHER,
              keyboardType: TextInputType.streetAddress,
              decoration: defaultInputDecoration(context),
            ).visible(mapLocation.text.isNotEmpty),
            10.height.visible(mapLocation.text.isNotEmpty),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    readOnly: mapLocation.text.isEmpty ? true : false,
                    isValidationRequired: true,
                    textInputAction: TextInputAction.go,
                    textStyle: primaryTextStyle(),
                    controller: countryController,
                    focus: countryFocus,
                    textFieldType: TextFieldType.NAME,
                    keyboardType: TextInputType.streetAddress,
                    decoration: defaultInputDecoration(context,
                        label: language.country),
                    onTap: () async {
                      if (mapLocation.text.isEmpty) {
                        toast(language.pleaseChooseAddressFromMap);
                      }
                    },
                  ),
                ),
                10.width,
                Expanded(
                  child: AppTextField(
                    readOnly: mapLocation.text.isEmpty ? true : false,
                    isValidationRequired: true,
                    textInputAction: TextInputAction.go,
                    controller: stateController,
                    focus: stateFocus,
                    textFieldType: TextFieldType.NAME,
                    keyboardType: TextInputType.streetAddress,
                    decoration:
                        defaultInputDecoration(context, label: language.state),
                    onTap: () async {
                      if (mapLocation.text.isEmpty) {
                        toast(language.pleaseChooseAddressFromMap);
                      }
                    },
                  ),
                ),
              ],
            ),
            10.height,
            AppTextField(
              readOnly: mapLocation.text.isEmpty ? true : false,
              isValidationRequired: true,
              textInputAction: TextInputAction.go,
              controller: cityController,
              focus: cityFocus,
              textFieldType: TextFieldType.NAME,
              keyboardType: TextInputType.streetAddress,
              decoration: defaultInputDecoration(context, label: language.city),
              onTap: () async {
                if (mapLocation.text.isEmpty) {
                  toast(language.pleaseChooseAddressFromMap);
                }
              },
            ),
            20.height,
            RequiredValidationText(
                required: true, titleText: language.addPicture),
            10.height,
            if (mainImagePath != null)
              Stack(
                children: [
                  mainImagePath!.contains('https')
                      ? cachedImage(
                          height: context.height() * 0.25,
                          fit: BoxFit.cover,
                          width: context.width(),
                          mainImagePath.validate(),
                        ).cornerRadiusWithClipRRect(8).center()
                      : Image.file(
                          height: context.height() * 0.25,
                          fit: BoxFit.cover,
                          width: context.width(),
                          File(mainImagePath.validate()),
                        ).cornerRadiusWithClipRRect(8).center(),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: boxDecorationWithRoundedCorners(
                          boxShape: BoxShape.circle),
                      child: Icon(Icons.close, color: Colors.red, size: 12)
                          .onTap(() {
                        mainImagePath = null;
                        setState(() {});
                      }),
                    ),
                  )
                ],
              ),
            if (mainImagePath.isEmptyOrNull) 10.height,
            if (mainImagePath.isEmptyOrNull)
              GestureDetector(
                onTap: () {
                  getImage();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: DottedBorder(
                    color: Colors.grey,
                    dashPattern: [6, 3],
                    child: Container(
                      height: 50,
                      decoration: boxDecorationWithRoundedCorners(
                          borderRadius: BorderRadius.circular(8),
                          backgroundColor: appStore.isDarkModeOn
                              ? cardDarkColor
                              : primaryExtraLight),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(ic_gallery,
                              height: 24, width: 24, color: grayColor),
                          10.width,
                          Text(language.addMainPicture,
                              style: secondaryTextStyle()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            20.height,
            RequiredValidationText(
                required: true, titleText: language.addOtherPicture),
            10.height,
            if (selectedImages.isNotEmpty)
              AnimatedWrap(
                itemCount: selectedImages.length,
                runSpacing: 16,
                spacing: 16,
                children: List.generate(selectedImages.length, (i) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      selectedImages[i].contains('https')
                          ? cachedImage(selectedImages[i].toString(),
                                  width: (context.width() - 64) / 3,
                                  height: 100,
                                  fit: BoxFit.cover)
                              .cornerRadiusWithClipRRect(8)
                          : Image.file(
                                  fit: BoxFit.fill,
                                  width: (context.width() - 64) / 3,
                                  height: 100,
                                  File(selectedImages[i].toString()))
                              .cornerRadiusWithClipRRect(8),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: boxDecorationWithRoundedCorners(
                              boxShape: BoxShape.circle),
                          child: Icon(Icons.close, color: Colors.red, size: 12)
                              .onTap(() {
                            selectedImages.removeAt(i);
                            setState(() {});
                          }),
                        ),
                      )
                    ],
                  );
                }),
              ).visible(selectedImages.isNotEmpty),
            10.height,
            GestureDetector(
              onTap: () async {
                List<XFile> image = await ImagePicker().pickMultiImage();
                imageFileList!.addAll(image);
                imageFileList!.forEach((image) {
                  selectedImages.add(image.path);
                });
                imageFileList!.clear();
                setState(() {});
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: DottedBorder(
                  color: Colors.grey,
                  dashPattern: [6, 3],
                  child: Container(
                    height: 50,
                    decoration: boxDecorationWithRoundedCorners(
                        borderRadius: BorderRadius.circular(8),
                        backgroundColor: appStore.isDarkModeOn
                            ? cardDarkColor
                            : primaryExtraLight),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(ic_gallery,
                            height: 24, width: 24, color: grayColor),
                        10.width,
                        Text(language.addOtherPictures,
                            style: secondaryTextStyle()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            20.height,
            RequiredValidationText(
                required: false, titleText: language.videoUrl),
            5.height,
            AppTextField(
                textInputAction: TextInputAction.done,
                isValidationRequired: false,
                controller: videoUrlController,
                focus: videoUrlFocus,
                textFieldType: TextFieldType.URL,
                keyboardType: TextInputType.url,
                decoration: defaultInputDecoration(context,
                    label: language.enterVideoUrl)),
            20.height,
            Row(
              children: [
                Text(language.premiumProperty,
                        style: primaryTextStyle(size: 18))
                    .expand(),
                CupertinoSwitch(
                  thumbColor: primaryExtraLight,
                  activeColor: primaryColor,
                  value: isPremium,
                  onChanged: (bool val) {
                    isPremium = val;
                    setState(() {});
                  },
                ),
              ],
            ),
            22.height,
          ],
        ).paddingSymmetric(horizontal: 16),
      ),
    );
  }

  Widget addPropertyComponent3() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Form(
            key: mThirdComponentFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.height,
                Text(language.extraFacilities, style: primaryTextStyle()),
                20.height,
                ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: amenityValueData.length,
                    itemBuilder: (context, i) {
                      return ExpansionTile(
                        shape: dialogShape(8),
                        backgroundColor: appStore.isDarkModeOn
                            ? cardDarkColor
                            : primaryExtraLight,
                        collapsedBackgroundColor: appStore.isDarkModeOn
                            ? cardDarkColor
                            : primaryExtraLight,
                        title: Text(amenityValueData[i].name.toString(),
                            style: primaryTextStyle()),
                        children: [
                          if (amenityValueData[i].type == AMENITY_TYPE_TEXT_BOX)
                            AmenityTextFiledComponent(
                              amenityID: amenityValueData[i].id,
                              amenityValueData: amenityValueData[i].name,
                              isUpdate: widget.updateProperty,
                              amenityType: AMENITY_TYPE_TEXT_BOX,
                              onUpdate: updateRadioBtnData,
                              updatedValue: (newAmenityValueData != null &&
                                          newAmenityValueData!.isNotEmpty) &&
                                      !isCategoryChanged.validate()
                                  ? newAmenityValueData![i].value
                                  : '',
                            ),
                          if (amenityValueData[i].type == AMENITY_TYPE_TEXTAREA)
                            AmenityTextFiledComponent(
                              amenityID: amenityValueData[i].id,
                              amenityType: AMENITY_TYPE_TEXTAREA,
                              amenityValueData: amenityValueData[i].name,
                              isUpdate: widget.updateProperty,
                              onUpdate: updateRadioBtnData,
                              updatedValue: (newAmenityValueData != null &&
                                          newAmenityValueData!.isNotEmpty) &&
                                      !isCategoryChanged.validate()
                                  ? newAmenityValueData![i].value
                                  : '',
                            ),
                          if (amenityValueData[i].type == AMENITY_TYPE_DROPDOWN)
                            DropDownComponent(
                              dropdownValues: amenityValueData[i].value,
                              amenityId: amenityValueData[i].id,
                              onUpdate: updateRadioBtnData,
                              isUpdateProperty: widget.updateProperty,
                              selectedDropDownValue: (newAmenityValueData !=
                                              null &&
                                          newAmenityValueData!.isNotEmpty) &&
                                      !isCategoryChanged.validate()
                                  ? newAmenityValueData![i].value
                                  : '',
                            ),
                          if (amenityValueData[i].type ==
                              AMENITY_TYPE_RADIO_BUTTON)
                            RadioComponent(
                              radioValues: amenityValueData[i].value,
                              amenityId: amenityValueData[i].id,
                              onUpdate: updateRadioBtnData,
                              isUpdateProperty:
                                  widget.updateProperty.validate(),
                              selectedRadioValue: (newAmenityValueData !=
                                              null &&
                                          newAmenityValueData!.isNotEmpty) &&
                                      !isCategoryChanged.validate()
                                  ? newAmenityValueData![i].value
                                  : '',
                            ),
                          if (amenityValueData[i].type == AMENITY_TYPE_CHECKBOX)
                            CheckBoxComponent(
                                checkboxValues: amenityValueData[i].value,
                                amenityId: amenityValueData[i].id,
                                pId: widget.pId,
                                isUpdateProperty: widget.updateProperty,
                                newCheckboxValues: (newAmenityValueData !=
                                                null &&
                                            newAmenityValueData!.isNotEmpty) &&
                                        !isCategoryChanged.validate()
                                    ? newAmenityValueData![i].value
                                    : [],
                                onUpdate: updateCheckBoxData),
                          if (amenityValueData[i].type == AMENITY_TYPE_NUMBER)
                            AmenityTextFiledComponent(
                              amenityID: amenityValueData[i].id,
                              amenityValueData: amenityValueData[i].name,
                              isUpdate: widget.updateProperty,
                              onUpdate: updateRadioBtnData,
                              amenityType: AMENITY_TYPE_NUMBER,
                              updatedValue: (newAmenityValueData != null &&
                                          newAmenityValueData!.isNotEmpty) &&
                                      !isCategoryChanged.validate()
                                  ? newAmenityValueData![i].value
                                  : '',
                            ),
                        ],
                      )
                          .cornerRadiusWithClipRRect(8.0)
                          .paddingSymmetric(vertical: 8);
                    }),
                20.height,
              ],
            ).paddingSymmetric(horizontal: 16),
          ),
          // Loader().center().visible(appStore.isLoading)
        ],
      ),
    );
  }

  //endregion

  //region Update Amenity Value Functions

  void updateCheckBoxData(List<String>? checkboxList, int? id) {
    if (checkboxList!.isNotEmpty) {
      for (int i = 0; i < checkboxList.length; i++) {
        AmenityDynamicModel a = AmenityDynamicModel();
        a.dynamicAmenityId = id;
        a.dynamicAmenityValue = checkboxList;
        dynamicAmenityList
            .removeWhere((element) => element.dynamicAmenityId == id);
        log('================${a.toJson()}');

        dynamicAmenityList.add(a);
        if (checkboxList.isEmpty) {
          toast(language.pleaseAddAmenities);
        }
        setState(() {});
      }
    } else {
      toast(language.pleaseAddAmenities);
    }

    setState(() {});
  }

  void updateRadioBtnData(id, value) {
    dynamicAmenityList.removeWhere((element) => element.dynamicAmenityId == id);

    AmenityDynamicModel a = AmenityDynamicModel();
    a.dynamicAmenityId = id;
    a.dynamicAmenityValue = value;
    log('================${a.toJson()}');
    dynamicAmenityList.add(a);
    if (value.toString().isEmptyOrNull) {
      toast(language.pleaseAddAmenities);
    }
  }

//endregion

//region Address get
  latLongFunction(num? mapLatitude, num? mapLongitude) {
    latitude = mapLatitude;
    longitude = mapLongitude;
    log('"latitude $latitude  longitude $longitude"');
    if (mapLocation.text.isEmpty) {
      cityController.clear();
      stateController.clear();
      countryController.clear();
    }

    setState(() {});
  }

  address(String? finalMapAddress) {
    mapLocation.text = finalMapAddress.toString();
    print("Final Location Is From Properties Screen ==>" +
        mapLocation.toString());
    setState(() {});
  }

  cityStateCountry(String? city, String? state, String? country) {
    if (mapLocation.text.isNotEmpty) {
      cityController.text = city.toString();
      stateController.text = state.toString();
      countryController.text = country.toString();
      print("CITY" +
          cityController.text.toString() +
          stateController.text.toString() +
          countryController.text.toString());
    }
    setState(() {});
  }
//endregion
}

class ABC {
  int? id;
  String? title;
  String? value;

  ABC(this.id, this.title, this.value);
}
