import 'package:flutter/material.dart';
import '../extensions/app_button.dart';
import '../extensions/colors.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../screens/add_Property_screen.dart';
import '../utils/colors.dart';
import '../utils/images.dart';

import '../extensions/system_utils.dart';
import '../models/add_property_model.dart';

class AddPropertyDialog extends StatefulWidget {
  const AddPropertyDialog({super.key});

  @override
  State<AddPropertyDialog> createState() => _AddPropertyDialogState();
}

class _AddPropertyDialogState extends State<AddPropertyDialog> {
  List<AddPropertyModel> propertyForList = [];

  int propertyFor = 0;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    getList();
  }

  getList() {
    propertyForList.add(AddPropertyModel(language.rentProperty, ic_rate, false));
    propertyForList.add(AddPropertyModel(language.sellProperty, ic_sell, false));
    // propertyForList.add(AddPropertyModel(language.pgColivingProperty, ic_bed, false));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: appStore.isDarkModeOn ? Colors.black : Colors.white,
      shape: dialogShape(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(language.iWantTo, style: primaryTextStyle(size: 24)),
              Icon(Icons.close, size: 28).onTap(() {
                finish(context);
              }),
            ],
          ),
          20.height,
          SizedBox(
            height: context.height() * 0.3,
            width: double.maxFinite,
            child: ListView.builder(
                itemCount: propertyForList.length,
                itemBuilder: (context, i) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: boxDecorationWithRoundedCorners(
                        borderRadius: radius(12),
                        backgroundColor: selectedIndex != i
                            ? appStore.isDarkModeOn
                                ? cardDarkColor
                                : primaryExtraLight
                            : primaryColor),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(selectedIndex != i ? ic_radio : ic_radio_fill, height: 20, width: 20, color: selectedIndex != i ? primaryColor : Colors.white),
                        10.width,
                        Image.asset(
                          propertyForList[i].img.validate(),
                          height: 25,
                          width: 25,
                          color: appStore.isDarkModeOn
                              ? Colors.white
                              : selectedIndex != i
                                  ? primaryColor
                                  : Colors.white,
                        ),
                        10.width,
                        Text(
                          propertyForList[i].title.validate(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: primaryTextStyle(
                              size: 18,
                              color: selectedIndex != i
                                  ? appStore.isDarkModeOn
                                      ? Colors.white
                                      : Colors.black
                                  : Colors.white),
                        ).expand(),
                      ],
                    ),
                  ).paddingBottom(20).onTap(() {
                    selectedIndex = i;
                    if (selectedIndex == 0) {
                      propertyFor = 0;
                    } else if (selectedIndex == 1) {
                      propertyFor = 1;
                    } else {
                      propertyFor = 2;
                    }
                    setState(() {});
                  });
                }),
          ),
          30.height,
          AppButton(
            padding: EdgeInsets.zero,
            text: language.Continue,
            width: context.width(),
            color: primaryColor,
            textColor: Colors.white,
            onTap: () {
              appStore.addPropertyIndex = 0;
              AddPropertyScreen(propertyFor: propertyFor).launch(context);
            },
          ),
        ],
      ),
    );
  }
}
