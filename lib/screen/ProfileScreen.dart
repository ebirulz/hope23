import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_personal_blog/service/AuthService.dart';
import '../component/CustomSettingItemWidget.dart';
import '../component/DialogComponent.dart';
import '../main.dart';
import '../network/RestApi.dart';
import '../screen/ChooseTopicsScreen.dart';
import '../screen/EditProfileScreen.dart';
import '../screen/SelectThemeScreen.dart';
import '../screen/SignInScreen.dart';
import '../screen/WebViewScreen.dart';
import '../utils/AppColor.dart';
import '../utils/AppCommon.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/device_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/AppConstant.dart';
import '../utils/AppImages.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import '../component/PollSurveyButtonWidget.dart';
import '../model/FontSizeModel.dart';
import 'AboutUsScreen.dart';
import 'ChangePasswordScreen.dart';
import 'LanguageScreen.dart';

class ProfileScreen extends StatefulWidget {
  static String tag = '/ProfileScreen';

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  List<String> cardLayoutList = [DEFAULT_LAYOUT, LIST_LAYOUT, GRID_LAYOUT];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWidget(language.profile, elevation: 0, showBack: false, textColor: Colors.white),
      backgroundColor: context.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    decoration: boxDecorationWithRoundedCornersWidget(boxShape: BoxShape.circle, backgroundColor: context.cardColor, border: Border.all(color: appStore.isDarkMode ? Colors.white70 : Colors.black12)),
                    child: userStore.profileImage.isNotEmpty
                        ? CircleAvatar(backgroundColor: context.cardColor, backgroundImage: NetworkImage(userStore.profileImage), maxRadius: 35)
                        : CircleAvatar(backgroundColor: context.cardColor, backgroundImage: AssetImage(ic_profile), maxRadius: 35))
                    .paddingOnly(top: 16, bottom: 16),
                12.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.height,
                    Text(userStore.fName + " " + userStore.lName, style: boldTextStyle(size: 20)),
                    Text(userStore.email, style: secondaryTextStyle()),
                    8.height,
                  ],
                ).expand(),
                12.width,
                Icon(Icons.navigate_next, color: Colors.grey),
              ],
            )
                .onTap(() async {
              bool? res = await EditProfileScreen().launch(context);
              if (res ?? false) setState(() {});
            })
                .paddingSymmetric(horizontal: 16)
                .visible(userStore.isLoggedIn),
            Divider(thickness: 10).visible(userStore.isLoggedIn),
            CustomSettingItemWidget(
              title: language.lblChooseTopic,
              leading: Icon(Ionicons.checkmark_circle_outline, color: primaryColor),
              onTap: () {
                ChooseTopicsScreen().launch(context);
              },
              trailing: Icon(Icons.navigate_next, color: Colors.grey),
            ),
            Divider(height: 5),
            if (!appStore.isSurvey) PollSurveyButtonWidget(),
            Divider(height: 5).visible(!appStore.isSurvey),
            CustomSettingItemWidget(
              title: language.lblChangePassword,
              leading: Icon(Ionicons.ios_key_outline, color: primaryColor),
              onTap: () {
                ChangePasswordScreen().launch(context);
              },
              trailing: Icon(Icons.navigate_next, color: Colors.grey),
            ).visible(userStore.isLoggedIn && !getBoolAsync(isSocial) && !getBoolAsync(isOtp)),
            Divider(height: 5).visible(userStore.isLoggedIn && !getBoolAsync(isSocial) && !getBoolAsync(isOtp)),
            CustomSettingItemWidget(
              title: language.lblSelectLanguage,
              leading: Icon(Ionicons.language_outline, color: primaryColor),
              trailing: Icon(Icons.navigate_next, color: Colors.grey),
              onTap: () async {
                hideKeyboard(context);
                bool res = await LanguageScreen().launch(context);
                if (res == true) setState(() {});
              },
            ),
            Divider(height: 5),
            CustomSettingItemWidget(
              title: language.lblSelectTheme,
              leading: Icon(MaterialCommunityIcons.theme_light_dark, color: primaryColor),
              trailing: Icon(Icons.navigate_next, color: Colors.grey),
              onTap: () async {
                hideKeyboard(context);
                bool res = await SelectThemeScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                if (res == true) setState(() {});
              },
            ),
            Divider(height: 5),
            CustomSettingItemWidget(
              leading: Icon(FontAwesome.font, color: primaryColor, size: 22),
              paddingAfterLeading: 20,
              title: language.lblChooseTextSize,
              trailing: DropdownButton<FontSizeModel>(
                items: fontSizes.map((e) {
                  return DropdownMenuItem<FontSizeModel>(child: Text('${e.title}', style: primaryTextStyle(size: 14)), value: e);
                }).toList(),
                dropdownColor: context.cardColor,
                value: fontSize,
                isDense: true,
                underline: SizedBox(),
                onChanged: (FontSizeModel? v) async {
                  hideKeyboard(context);
                  await setValue(fontSizePref, v!.fontSize);
                  fontSize = fontSizes.firstWhere((element) => element.fontSize == getIntAsync(fontSizePref, defaultValue: 16));
                  setState(() {});
                },
              ),
              onTap: () {
                //
              },
            ),
            Divider(height: 5),
            CustomSettingItemWidget(
              title: language.lblEnableDisablePushNotification,
              leading: Icon(MaterialCommunityIcons.bell_outline, color: primaryColor),
              onTap: () async {},
              trailing: Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  activeColor: primaryColor,
                  value: appStore.isNotificationOn,
                  onChanged: (v) {
                    appStore.setNotification(v);
                    setState(() {});
                  },
                ).withHeight(10),
              ),
            ),
            Divider(height: 5),
            CustomSettingItemWidget(
              title: language.cardLayout,
              leading: Icon(Icons.list_alt, color: primaryColor),
              onTap: () async {},
              trailing: DropdownButton<String>(
                items: cardLayoutList.map((e) {
                  return DropdownMenuItem<String>(child: Text('$e', style: primaryTextStyle(size: 14)), value: e);
                }).toList(),
                dropdownColor: context.cardColor,
                value: getStringAsync(CARD_LAYOUT, defaultValue: DEFAULT_LAYOUT),
                isDense: true,
                underline: SizedBox(),
                onChanged: (String? v) async {
                  hideKeyboard(context);
                  await setValue(CARD_LAYOUT, v);
                  setState(() {});
                },
              ),
            ),
            Divider(thickness: 10),
            CustomSettingItemWidget(
              title: language.lblShare + " " + appName,
              leading: Icon(Ionicons.share_social_outline, color: primaryColor),
              trailing: Icon(Icons.navigate_next, color: Colors.grey),
              onTap: () {
                PackageInfo.fromPlatform().then((value) {
                  Share.share('Share $appName app\n$playStoreBaseURL${value.packageName}');
                });
              },
            ),
            Divider(height: 5),
            CustomSettingItemWidget(
              title: language.lblRateUs,
              leading: Icon(AntDesign.staro, color: primaryColor),
              trailing: Icon(Icons.navigate_next, color: Colors.grey),
              onTap: () {
                PackageInfo.fromPlatform().then((value) {
                  String package = '';
                  if (isAndroid) package = value.packageName;

                  mLaunchUrl('${storeBaseURL()}$package');
                });
              },
            ),
            Divider(height: 5),
            CustomSettingItemWidget(
              title: language.lblPrivacyPolicy,
              leading: Icon(Ionicons.document_text_outline, color: primaryColor),
              trailing: Icon(Icons.navigate_next, color: Colors.grey),
              onTap: () {
                if (dashboardStore.privacyPolicy.isNotEmpty)
                  WebViewScreen(name: language.lblPrivacyPolicy, url: dashboardStore.privacyPolicy).launch(context);
                else
                  toast(language.txtURLEmpty);
              },
            ),
            Divider(height: 5),
            CustomSettingItemWidget(
              title: language.lblTermsCondition,
              leading: Icon(Ionicons.document_text_outline, color: primaryColor),
              trailing: Icon(Icons.navigate_next, color: Colors.grey),
              onTap: () async {
                if (dashboardStore.termCondition.isNotEmpty)
                  WebViewScreen(name: language.lblTermsCondition, url: dashboardStore.termCondition).launch(context);
                else
                  toast(language.txtURLEmpty);
              },
            ),
            Divider(height: 5),
            CustomSettingItemWidget(
              title: language.lblAboutUs,
              leading: Icon(Ionicons.md_information_circle_outline, color: primaryColor),
              trailing: Icon(Icons.navigate_next, color: Colors.grey),
              onTap: () {
                hideKeyboard(context);
                AboutUsScreen().launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
              },
            ),
            Divider(height: 5),
            CustomSettingItemWidget(
              onTap: () {
                SignInScreen().launch(context);
              },
              paddingAfterLeading: 18,
              title: language.lblSignIn,
              leading: Icon(MaterialIcons.login, color: primaryColor, size: 22),
              trailing: Icon(Icons.navigate_next, color: Colors.grey),
            ).visible(!userStore.isLoggedIn),
            CustomSettingItemWidget(
              title: language.deleteAccount,
              titleTextStyle: primaryTextStyle(color: Colors.red),
              leading: Icon(Icons.delete_outline_outlined, color: Colors.red),
              onTap: () {
                showDialogBox(context, language.deleteAccountMsg, onCall: () {
                  deleteUser(userStore.email, userStore.password);
                  logout(context);
                  setState(() { });
                }, onCancelCall: () {
                  finish(context);
                });
              },
            ).visible(userStore.isLoggedIn && getBoolAsync(isSocial) || getBoolAsync(isOtp)),
            Divider(height: 5).visible(userStore.isLoggedIn && getBoolAsync(isSocial) || getBoolAsync(isOtp)),
            CustomSettingItemWidget(
              onTap: () {
                showDialogBox(context, language.logOutTxt, onCall: () {
                  logout(context);
                  setState(() {});
                }, onCancelCall: () {
                  finish(context);
                });
              },
              paddingAfterLeading: 18,
              title: language.lblLogOut,
              titleTextStyle: primaryTextStyle(color: Colors.red),
              leading: Icon(SimpleLineIcons.logout, size: 22, color: Colors.red),
            ).visible(userStore.isLoggedIn),
            8.height,
          ],
        ),
      ),
    );
  }
}
