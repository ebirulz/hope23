import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mighty_personal_blog/screen/ChooseTopicsScreen.dart';
import '../screen/DashboardScreen.dart';
import '../utils/AppConstant.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/AppImages.dart';
import '../utils/Extensions/Widget_extensions.dart';

import '../main.dart';
import 'WalkThroughScreen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    Timer(const Duration(seconds: 15), () async {
      //Navigator.pushNamed(context,'/intro_screen',);
      //bool skipLogin = await _checkIfLoggedIn();
      dashboardStore.init().whenComplete(() {
        checkFirstSeen();
      });
    }
    );
  }

  Future checkFirstSeen() async {
    bool seen = (getBoolAsync('isFirstTime'));
    if (seen) {
      if(getStringListAsync(chooseTopicList)!=null && getStringListAsync(chooseTopicList)!.isNotEmpty) {
        DashboardScreen().launch(context, isNewTask: true);
      }else{
        ChooseTopicsScreen().launch(context,isNewTask: true);
      }
    } else {
      await setValue('isFirstTime', true);
      ChooseTopicsScreen().launch(context, isNewTask: true);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFd7effc),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(margin: EdgeInsets.all(16), child: Image.asset(ic_logo_splash, height: 250)),
          //Text(appName, style: boldTextStyle(size: 24)),
        ],
      ).center(),
    );
  }
}
