import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage? of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage);

  String get lblOldPassword;

  String get lblChangePassword;

  String get lblSkip;

  String get btnGetStarted;

  String get btnNext;

  String get btnMore;

  String get lblFeaturedBlog;

  String get lblNoBlogAvailable;

  String get lblCategories;

  String get lblBookMark;

  String get dltBookMarkTxt;

  String get emptyBookMarkTxt;

  String get btnDelete;

  String get btnRemove;

  String get lblChooseTopic;

  String get lblSelectLanguage;

  String get lblSelectTheme;

  String get lblShare;

  String get lblRateUs;

  String get lblTermsCondition;

  String get lblPrivacyPolicy;

  String get txtURLEmpty;

  String get lblAboutUs;

  String get lblSignIn;

  String get logOutTxt;

  String get lblLogOut;

  String get lblEditProfile;

  String get lblFirstName;

  String get lblLastName;

  String get lblUpdate;

  String get lblChooseInterest;

  String get txtChooseTopic;

  String get btnContinue;

  String get msgChooseTopic;

  String get msgPasswordIncorrect;

  String get lblNewPassword;

  String get lblConfirmPassword;

  String get passLengthMsg;

  String get oldPassNotMatchMsg;

  String get passNotMatch;

  String get btnUpdatePassword;

  String get lblLight;

  String get lblDark;

  String get lblSystemDefault;

  String get lblFollowUs;

  String get lblWebsite;

  String get lblCopyright;

  String get txtNoAccount;

  String get lblSignUp;

  String get sigInWelcomeMsg;

  String get msgInvalidEnterEmail;

  String get lblEmail;

  String get lblPassword;

  String get btnRememberMe;

  String get btsForgotPassword;

  String get lblOr;

  String get msgHaveAccount;

  String get msgSignUp;

  String get lblUsername;

  String get lblComments;

  String get msgDltComment;

  String get lblResetYourPassword;

  String get msgForgotPass;

  String get btnResetPassword;

  String get lblSearchBlogs;

  String get lblAuthorBy;

  String get lblAddComments;

  String get lblLikes;

  String get lblNoPostContent;

  String get lblCategory;

  String get lblRelatablePost;

  String get msgEmptyComment;

  String get lblSubmit;

  String get lblCancel;

  String get lblYes;

  String get msgOtpLogin;

  String get lblMobileNumber;

  String get btnSendOTP;

  String get lblEnterReceiveOTP;

  String get lblConfirm;

  String get lblExplore;

  String get lblPolyFishText;

  String get lblPolyFishTextForOneDay;

  String get lblSuggestForYou;

  String get lblRecentBlog;

  String get lblSeeAll;

  String get lblChooseTree;

  String get lblMultipleDemo;

  String get lblSelectBlogType;

  String get lblQuickLook;

  String get lblQuickLookSubTitle;

  String get lblBy;

  String get lblReadMore;

  String get lblChooseTextSize;

  String get lblEnableDisablePushNotification;

  String get explore;

  String get noComments;

  String get internetNotWorking;

  String get profile;

  String get cardLayout;

  String get deleteAccount;

  String get deleteAccountMsg;

  String get chooseTopics;

  String get chooseTopicsOptions;
}
