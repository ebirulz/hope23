import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../AppTheme.dart';
import '../model/FontSizeModel.dart';
import '../screen/NoInternetScreen.dart';
import '../screen/SplashScreen.dart';
import '../store/BookMarkStore/BookMarkStore.dart';
import '../store/PostDetailStore/PostDetailStore.dart';
import '../store/UserStore/UserStore.dart';
import '../store/app_store.dart';
import '../utils/AppCommon.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/device_extensions.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/string_extensions.dart';
import '../utils/AppConstant.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import 'language/AppLocalizations.dart';
import 'language/BaseLanguage.dart';
import 'model/DefaultPostResponse.dart';
import 'store/DashboardStore/DashboardStore.dart';
import 'model/LanguageDataModel.dart';

AppStore appStore = AppStore();
UserStore userStore = UserStore();
PostDetailStore postDetailStore = PostDetailStore();
DashboardStore dashboardStore = DashboardStore();
BookMarkStore bookMarkStore = BookMarkStore();

FontSizeModel? fontSize;
List<FontSizeModel> fontSizes = FontSizeModel.fontSizes();

bool isCurrentlyOnNoInternet = false;
late BaseLanguage language;
late SharedPreferences sharedPreferences;

List<LanguageDataModel> localeLanguageList = [];

Color defaultLoaderBgColorGlobal = Colors.white;
Color? defaultLoaderAccentColorGlobal;

LanguageDataModel? selectedLanguageDataModel;
int passwordLengthGlobal = 6;
Timer? rewardTimer;

final navigatorKey = GlobalKey<NavigatorState>();
final GoogleTranslator translator = GoogleTranslator();

Future<void> initialize({
  double? defaultDialogBorderRadius,
  List<LanguageDataModel>? aLocaleLanguageList,
  String? defaultLanguage,
}) async {
  sharedPreferences = await SharedPreferences.getInstance();
  defaultAppButtonShapeBorder = RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius));
  localeLanguageList = aLocaleLanguageList ?? [];
  selectedLanguageDataModel = getSelectedLanguageModel(defaultLanguage: defaultLanguage);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();

  await setValue(baseURL, mDomainUrl);

  if (isMobile) {
    await Firebase.initializeApp().then((value) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    });
    await OneSignal.shared.setAppId(mOneSignalAppId);
    OneSignal.shared.consentGranted(true);
    OneSignal.shared.promptUserForPushNotificationPermission();
    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      event.complete(event.notification);
    });
    final status = await OneSignal.shared.getDeviceState();
    print(status!.userId);
  }

  if (getBoolAsync(IS_FREE_TRIAL_START)) {
    appStore.setSurveyStatus();
    await setValue(IS_SURVEY, true);
    startTimer();
  }

  await initialize(aLocaleLanguageList: languageList());
  defaultSetting();
  // appStore.setLanguage(getStringAsync(sharedPref.selectedLanguage, defaultValue: defaultValues.defaultLanguage));
  appStore.setLanguage(DEFAULT_LANGUAGE);

  setLogInValue();
  if (!isWeb) {
    int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
    if (themeModeIndex == appThemeMode.themeModeLight) {
      appStore.setDarkMode(false);
    } else if (themeModeIndex == appThemeMode.themeModeDark) {
      appStore.setDarkMode(true);
    }
  }
  String bookMarkList = getStringAsync(BOOKMARK_LIST);
  if (bookMarkList.isNotEmpty) {
    bookMarkStore.addAllBookMarkItem(jsonDecode(bookMarkList).map<DefaultPostResponse>((e) => DefaultPostResponse.fromJson(e)).toList());
  }else{
    if(userStore.isLoggedIn) {
      bookMarkStore.getBookMarkItem(page: 1);
    }
  }
  fontSize = fontSizes.firstWhere((element) => element.fontSize == getIntAsync(fontSizePref, defaultValue: 16));
  appStore.setNotification(getBoolAsync(notificationOn));
  if (getStringAsync(CARD_LAYOUT).isEmptyOrNull) {
    setValue(CARD_LAYOUT, DEFAULT_LAYOUT);
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((e) {
      if (e == ConnectivityResult.none) {
        log('not connected');
        isCurrentlyOnNoInternet = true;
        push(NoInternetScreen());
      } else {
        if (isCurrentlyOnNoInternet) {
          pop();
          isCurrentlyOnNoInternet = false;
          toast('Internet is connected.');
        }
        log('connected');
      }
    });

  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        title: appName,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        scrollBehavior: SBehavior(),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: SplashScreen(),
        supportedLocales: LanguageDataModel.languageLocales(),
        localizationsDelegates: [AppLocalizations(), GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguage.validate(value: DEFAULT_LANGUAGE)),
      ),
    );
  }
}
