import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../../extensions/colors.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../utils/colors.dart';

AppBar appBarWidget(
  String title, {
  Widget? titleWidget,
  List<Widget>? actions,
  Color? color,
  bool center = true,
  Color? textColor,
  double titleSpace = 16,
  int textSize = 18,
  bool showBack = true,
  bool showFilter = true,
  bool showCart = true,
  Color? shadowColor,
  Color? bgColor,
  double? elevation,
  Widget? backWidget,
  @Deprecated('Use systemOverlayStyle instead') Brightness? brightness,
  SystemUiOverlayStyle? systemUiOverlayStyle,
  TextStyle? titleTextStyle,
  PreferredSizeWidget? bottom,
  Widget? flexibleSpace,
  required BuildContext context1,
}) {
  return AppBar(
      titleSpacing: titleSpace,
      centerTitle: false,
      title: titleWidget ?? Text(title, style: titleTextStyle ?? (boldTextStyle(color: appStore.isDarkModeOn ? selectIconColor : scaffoldColorDark, size: textSize))),
      actions: actions,
      automaticallyImplyLeading: showBack,
      backgroundColor: appStore.isDarkModeOn ? bgColor ?? scaffoldColorDark : bgColor ?? whiteColor,
      leading: showBack
          ? (backWidget ??
              Icon(appStore.selectedLanguage == 'ar' ? MaterialIcons.arrow_forward_ios : Octicons.chevron_left, color: primaryColor, size: appStore.selectedLanguage == 'ar' ? 20 : 28).onTap(() {
                Navigator.pop(context1);
              }))
          : null,
      shadowColor: viewLineColor,
      elevation: elevation ?? 0,
      systemOverlayStyle: systemUiOverlayStyle,
      bottom: bottom,
      flexibleSpace: flexibleSpace);
}
