import 'package:flutter/material.dart';
import '../component/AppWidget.dart';
import '../component/OTPLoginComponent.dart';
import '../network/RestApi.dart';
import '../service/AuthService.dart';
import '../utils/AppCommon.dart';
import '../utils/AppConstant.dart';
import '../utils/Extensions/AppTextField.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/device_extensions.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/string_extensions.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/AppColor.dart';
import '../utils/AppImages.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../main.dart';
import 'DashboardScreen.dart';
import 'ForgotPasswordScreen.dart';
import 'SignUpScreen.dart';

class SignInScreen extends StatefulWidget {
  static String tag = '/SignInScreen';
  final bool? isDashboard;

  SignInScreen({this.isDashboard = false});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  GlobalKey<FormState> signInformKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController signInBtnController = RoundedLoadingButtonController();

  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();

  FocusNode passFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (getBoolAsync(isRemember)) {
      log(emailCon.text.toString());
      emailCon.text = getStringAsync(userEmail);
      passCon.text = getStringAsync(userPassword);
    }
  }

  Future<void> submit() async {
    hideKeyboard(context);
    if (signInformKey.currentState!.validate()) {
      signInformKey.currentState!.save();
      signInBtnController.start();
      Map<String, dynamic> req = {
        'username': emailCon.text.trim(),
        'password': passCon.text.trim(),
      };
      await logInApi(req).then((value) async {
        signInBtnController.success();
        DashboardScreen().launch(context, isNewTask: true);
      }).catchError((e) {
        toast(e.toString());
        signInBtnController.error();
        apiErrorComponent(e, context);
      }).whenComplete(
        () => signInBtnController.stop(),
      );
    }
  }

  googleLogin() async {
    appStore.setLoading(true);
    await signInWithGoogle().then((user) {
      DashboardScreen().launch(context, isNewTask: true);
    }).catchError((e) {
      toast(e.toString());
      //DashboardScreen().launch(context, isNewTask: true);
    });
    appStore.setLoading(false);
  }

  otpLogin(context) async {
    hideKeyboard(context);
    await showDialog(context: context, builder: (context) => OTPDialog(), barrierDismissible: false).catchError((e) {
      toast(e.toString());
    });
  }

  appleLogin() async {
    hideKeyboard(context);
    appStore.setLoading(true);
    await appleLogIn().then((value) {
      DashboardScreen().launch(context, isNewTask: true);
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  Widget mSocialWidget(img, Function onCall, {bool isMobile = false}) {
    return GestureDetector(
      onTap: () {
        onCall();
      },
      child: Container(
        height: 50,
        width: 50,
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        decoration: boxDecorationWithShadowWidget(borderRadius: BorderRadius.circular(defaultRadius),blurRadius: 5),
        child: isMobile == true ? Image.asset(img, width: 35, height: 35, fit: BoxFit.fill, color: primaryColor) : Image.asset(img, width: 35, height: 35, fit: BoxFit.fill),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cardColor,
      bottomNavigationBar: Container(
        color: context.cardColor,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(language.txtNoAccount, style: primaryTextStyle()),
            GestureDetector(
                child: Text(language.lblSignUp, style: TextStyle(fontSize: 18.0, decoration: TextDecoration.underline, color: appStore.isDarkMode ? Colors.white : primaryColor)).paddingLeft(4),
                onTap: () {
                  SignUpScreen().launch(context);
                })
          ],
        ),
      ),
      body: Form(
        key: signInformKey,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: context.height() * 0.5,
                    width: context.width(),
                    color: primaryColor,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: widget.isDashboard! ? 70 : 85),
                    child: Text(language.sigInWelcomeMsg, style: boldTextStyle(size: 28, color: Colors.white)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: context.height() * 0.25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(70)),
                      color: context.cardColor,
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(language.lblSignIn, style: boldTextStyle(size: 24)),
                        30.height,
                        AppTextField(
                          controller: emailCon,
                          nextFocus: passFocus,
                          autoFocus: false,
                          textFieldType: TextFieldType.EMAIL,
                          keyboardType: TextInputType.emailAddress,
                          errorThisFieldRequired: errorThisFieldRequired,
                          decoration: inputDecoration(context, label: language.lblUsername + " / " + language.lblEmail),
                        ),
                        16.height,
                        AppTextField(
                          controller: passCon,
                          focus: passFocus,
                          textFieldType: TextFieldType.PASSWORD,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (String? value) {
                            if (value.validate().isEmpty) return errorThisFieldRequired;
                            return null;
                          },
                          decoration: inputDecoration(context, label: language.lblPassword),
                          onFieldSubmitted: (c) {
                            submit();
                          },
                        ),
                        8.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CustomTheme(
                              child: Checkbox(
                                focusColor: primaryColor,
                                activeColor: primaryColor,
                                value: getBoolAsync(isRemember),
                                onChanged: (bool? value) async {
                                  await setValue(isRemember, value);
                                  setState(() {});
                                },
                              ),
                            ),
                            Text(language.btnRememberMe, style: secondaryTextStyle(size: 16)).expand(),
                            GestureDetector(
                                onTap: () {
                                  ForgotPasswordScreen().launch(context);
                                },
                                child: Text(language.btsForgotPassword, style: secondaryTextStyle(size: 16))),
                          ],
                        ),
                        24.height,
                        RoundedLoadingButton(
                          successIcon: Icons.done,
                          failedIcon: Icons.close,
                          borderRadius: defaultRadius,
                          child: Text(language.lblSignIn, style: boldTextStyle(color: Colors.white)),
                          controller: signInBtnController,
                          animateOnTap: false,
                          resetAfterDuration: true,
                          width: context.width(),
                          color: primaryColor,
                          onPressed: () {
                            submit();
                          },
                        ),
                        16.height,
                        Row(
                          children: [
                            Divider(endIndent: 10).expand(),
                            Text( language.lblOr, style: secondaryTextStyle()),
                            Divider(indent: 10).expand(),
                          ],
                        ),
                        16.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            mSocialWidget(ic_google, () {
                              googleLogin();
                            }),
                            12.width,
                            mSocialWidget(ic_mobile, () {
                              otpLogin(context);
                            }, isMobile: true),
                            12.width.visible(isAppleLoginEnable && isIos),
                            mSocialWidget(ic_apple, () {
                              appleLogin();
                            }).visible(isAppleLoginEnable && isIos),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                finish(context);
              },
            ).visible(widget.isDashboard == false).paddingTop(context.statusBarHeight + 4),
          ],
        ),
      ),
    );
  }
}
