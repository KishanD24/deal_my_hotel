import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../components/app_bar_components.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../utils/colors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../extensions/shared_pref.dart';
import '../utils/app_common.dart';
import '../utils/constants.dart';
import '../utils/images.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  Widget mSocialOption(var value, {var color}) {
    return Image.asset(value, height: 30, width: 30, color: color).paddingAll(8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.aboutUs, context1: context, titleSpace: 0),
      bottomNavigationBar: Container(
        height: 130,
        child: Column(
          children: [
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (_, snap) {
                if (snap.hasData) {
                  return Text('v${snap.data!.version.validate()}', style: secondaryTextStyle());
                }
                return SizedBox();
              },
            ),
            16.height,
            Text(language.followUs, style: primaryTextStyle(size: 14)),
            2.height,
            SizedBox(
              height: 50,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      mSocialOption(ic_facebook)
                          .onTap(() {
                            launchUrls(getStringAsync(FACEBOOK_URL));
                          })
                          .paddingOnly(left: 16, right: 16)
                          .visible(getStringAsync(FACEBOOK_URL).isNotEmpty),
                      mSocialOption(ic_instagram)
                          .onTap(() {
                            launchUrls(getStringAsync(INSTAGRAM_URL));
                          })
                          .paddingRight(16)
                          .visible(getStringAsync(INSTAGRAM_URL).isNotEmpty),
                      mSocialOption(ic_twitter)
                          .onTap(() {
                            launchUrls(getStringAsync(TWITTER_URL));
                          })
                          .paddingRight(16)
                          .visible(getStringAsync(TWITTER_URL).isNotEmpty),
                      mSocialOption(ic_linkedin)
                          .onTap(() {
                            launchUrls(getStringAsync(LINKED_URL));
                          })
                          .paddingRight(16)
                          .visible(getStringAsync(LINKED_URL).isNotEmpty),
                    ],
                  ),
                ],
              ),
            ),
            2.height,
            Text(getStringAsync(SITE_COPYRIGHT), style: secondaryTextStyle(size: 12), maxLines: 1).visible(getStringAsync(SITE_COPYRIGHT).isNotEmpty),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            4.height,
            Text(getStringAsync(SITE_NAME), style: boldTextStyle(color: primaryColor, size: 18)),
            10.height,
            Text(getStringAsync(SITE_DESCRIPTION), style: primaryTextStyle()),
            16.height,
            Row(
              children: [
                Icon(MaterialIcons.mail_outline, color: textSecondaryColorGlobal),
                8.width,
                Text(getStringAsync(CONTACT_EMAIL), style: secondaryTextStyle()).onTap(() {
                  commonLaunchUrl(language.mailto + getStringAsync(CONTACT_EMAIL));
                }),
              ],
            ).visible(getStringAsync(CONTACT_EMAIL).isNotEmpty),
            16.height,
            Row(
              children: [
                Icon(MaterialIcons.support_agent, color: textSecondaryColorGlobal),
                8.width,
                Text(getStringAsync(HELP_SUPPORT), style: secondaryTextStyle()),
              ],
            ).visible(getStringAsync(HELP_SUPPORT).isNotEmpty),
            16.height,
            Row(
              children: [
                Icon(Ionicons.md_call_outline, color: textSecondaryColorGlobal),
                8.width,
                Text(getStringAsync(CONTACT_NUMBER), style: secondaryTextStyle()),
              ],
            ).visible(getStringAsync(CONTACT_NUMBER).isNotEmpty),
          ],
        ),
      ).paddingSymmetric(horizontal: 16),
    );
  }
}
