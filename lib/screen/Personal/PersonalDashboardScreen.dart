import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_personal_blog/utils/Extensions/Constants.dart';
import 'package:mighty_personal_blog/utils/Extensions/context_extensions.dart';
import '../../utils/Extensions/Widget_extensions.dart';

import '../../main.dart';
import '../../utils/AppConstant.dart';
import '../../utils/Extensions/Commons.dart';
import '../SearchBlogScreen.dart';
import 'PersonalCustomHomeScreen.dart';
import 'PersonalHomeScreen.dart';

class PersonalDashboardScreen extends StatefulWidget {
  static String tag = '/FitnessDashboardScreen';

  @override
  PersonalDashboardScreenState createState() => PersonalDashboardScreenState();
}

class PersonalDashboardScreenState extends State<PersonalDashboardScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    log("Personal");
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset('assets/appbar_logo.png', width: 250,),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              SearchBlogScreen().launch(context);
            },
            icon: Icon(Ionicons.search, color: context.iconColor),
          )
        ],
      ),
        /*appBar: appBarWidget(
          appName,
          showBack: false,
          center: true,
          color: context.scaffoldBackgroundColor,
          titleTextStyle: TextStyle(color: textPrimaryColorGlobal, fontWeight: FontWeight.bold, fontSize: 30),
          actions: [
            IconButton(
              onPressed: () {
                SearchBlogScreen().launch(context);
              },
              icon: Icon(Ionicons.search, color: context.iconColor),
            )
          ],
        ),*/
        body: dashboardStore.enableCustomDashboard ? PersonalCustomHomeScreen() : PersonalHomeScreen());
  }
}
