import 'package:flutter/material.dart';
import '../network/RestApi.dart';
import '../utils/AppCommon.dart';
import '../utils/AppConstant.dart';
import '../utils/Extensions/AppTextField.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/string_extensions.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/AppColor.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../component/AppWidget.dart';
import '../main.dart';
import 'DashboardScreen.dart';

class SignUpScreen extends StatefulWidget {
  static String tag = '/SignUpScreen';
  final String? phoneNumber;

  SignUpScreen({this.phoneNumber});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController confirmPasswordCont = TextEditingController();

  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (widget.phoneNumber.validate().isNotEmpty) {
      userNameCont.text = widget.phoneNumber.validate();
      passwordCont.text = widget.phoneNumber.validate();
      confirmPasswordCont.text = widget.phoneNumber.validate();
    } else {
      userNameCont.text = "";
      passwordCont.text = "";
      confirmPasswordCont.text = "";
    }
  }

  Future<void> submit() async {
    hideKeyboard(context);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      btnController.start();
      await signUp(
        firstName: firstNameCont.text.trim(),
        lastName: lastNameCont.text.trim(),
        userLogin: widget.phoneNumber ?? userNameCont.text.trim(),
        userEmail: emailCont.text.validate(),
        password: widget.phoneNumber ?? passwordCont.text,
      ).then((value) async {
        btnController.success();
        if (widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty)
          setValue(isOtp, true);
        else
          setValue(isOtp, false);
        DashboardScreen().launch(context, isNewTask: true);
      }).catchError((error) {
        toast(error.toString());
        btnController.error();
        apiErrorComponent(error, context);
      }).whenComplete(
        () => btnController.stop(),
      );
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
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
            Text(language.msgHaveAccount, style: primaryTextStyle()),
            Container(
              margin: EdgeInsets.only(left: 4),
              child: GestureDetector(
                  child: Text(language.lblSignIn, style: TextStyle(fontSize: 18.0, decoration: TextDecoration.underline, color: appStore.isDarkMode ? Colors.white : primaryColor)),
                  onTap: () {
                    finish(context);
                  }),
            )
          ],
        ),
      ),
      body: Form(
        key: formKey,
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
                    padding: EdgeInsets.only(left: 16,right: 16,top: 85,bottom: 16),
                    child: Text(language.msgSignUp, style: boldTextStyle(size: 28, color: Colors.white)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: context.height() * 0.25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(70)),
                      color: context.cardColor,
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(language.lblSignUp, style: boldTextStyle(size: 24)),
                        30.height,
                        Row(
                          children: [
                            AppTextField(
                              controller: firstNameCont,
                              focus: firstNameFocus,
                              autoFocus: false,
                              nextFocus: lastNameFocus,
                              textFieldType: TextFieldType.NAME,
                              validator: (String? value) {
                                if (value.validate().isEmpty) return errorThisFieldRequired;
                                return null;
                              },
                              decoration: inputDecoration(context, label: language.lblFirstName),
                            ).expand(),
                            16.width,
                            AppTextField(
                              controller: lastNameCont,
                              nextFocus: userNameFocus,
                              focus: lastNameFocus,
                              textFieldType: TextFieldType.NAME,
                              validator: (String? value) {
                                if (value.validate().isEmpty) return errorThisFieldRequired;
                                return null;
                              },
                              decoration: inputDecoration(context, label: language.lblLastName),
                            ).expand(),
                          ],
                        ),
                        16.height,
                        AppTextField(
                          controller: userNameCont,
                          nextFocus: emailFocus,
                          readOnly: widget.phoneNumber.isEmptyOrNull ? false : true,
                          focus: userNameFocus,
                          textFieldType: TextFieldType.USERNAME,
                          validator: (String? value) {
                            if (value.validate().isEmpty) return errorThisFieldRequired;
                            return null;
                          },
                          decoration: inputDecoration(context, label: language.lblUsername),
                        ),
                        16.height,
                        AppTextField(
                          controller: emailCont,
                          focus: emailFocus,
                          nextFocus: passwordFocus,
                          textFieldType: TextFieldType.EMAIL,
                          keyboardType: TextInputType.emailAddress,
                          errorInvalidEmail: language.msgInvalidEnterEmail,
                          errorThisFieldRequired: errorThisFieldRequired,
                          validator: (String? value) {
                            if (value.validate().isEmpty) return errorThisFieldRequired;
                            return null;
                          },
                          decoration: inputDecoration(context, label: language.lblEmail),
                        ),
                        16.height,
                        AppTextField(
                          controller: passwordCont,
                          nextFocus: confirmPasswordFocus,
                          focus: passwordFocus,
                          readOnly: widget.phoneNumber.isEmptyOrNull ? false : true,
                          textFieldType: TextFieldType.PASSWORD,
                          validator: (String? value) {
                            if (value.validate().isEmpty) return errorThisFieldRequired;
                            return null;
                          },
                          decoration: inputDecoration(context, label: language.lblPassword),
                        ),
                        16.height,
                        AppTextField(
                          focus: confirmPasswordFocus,
                          controller: confirmPasswordCont,
                          readOnly: widget.phoneNumber.isEmptyOrNull ? false : true,
                          textFieldType: TextFieldType.PASSWORD,
                          validator: (String? value) {
                            if (value.validate().isEmpty) return errorThisFieldRequired;
                            return null;
                          },
                          decoration: inputDecoration(context, label: language.lblConfirmPassword),
                        ),
                        24.height,
                        RoundedLoadingButton(
                          successIcon: Icons.done,
                          failedIcon: Icons.close,
                          borderRadius: defaultRadius,
                          child: Text(language.lblSignUp, style: boldTextStyle(color: Colors.white)),
                          controller: btnController,
                          animateOnTap: false,
                          resetAfterDuration: true,
                          width: context.width(),
                          color: primaryColor,
                          onPressed: () {
                            submit();
                          },
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
            ).paddingTop(context.statusBarHeight + 4),
          ],
        ),
      ),
    );
  }
}
