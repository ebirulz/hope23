import 'package:flutter/material.dart';
import 'package:mighty_personal_blog/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_personal_blog/utils/Extensions/context_extensions.dart';
import 'package:mighty_personal_blog/utils/Extensions/live_stream.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../screen/ProfileScreen.dart';
import '../screen/BookMarkScreen.dart';
import '../screen/SignInScreen.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/AppColor.dart';
import '../main.dart';
import '../utils/Extensions/Commons.dart';
import 'CategoryScreen.dart';
import 'Personal/PersonalDashboardScreen.dart';
import 'Personal/PersonalDetailScreen.dart';

class DashboardScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  BuildContext? testContext;

  List<Widget> widgets = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
    LiveStream().on('UpdateFragment', (p0) {
      widgets.clear();
      init();
      setState(() { });
    });
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) async {
      try {
        PersonalDetailScreen(postId: int.parse(result.notification.additionalData!['ID'].toString())).launch(getContext);
      } catch (e) {
        log(e.toString());
      }
    });
  }

  init() async {
    widgets.add(PersonalDashboardScreen());
    widgets.add(CategoryScreen());
    widgets.add(userStore.isLoggedIn ? BookMarkScreen() : SignInScreen(isDashboard: true));
    widgets.add(ProfileScreen());
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget tabItem(var pos, {var activeIcon,var icon}) {
      return GestureDetector(
        onTap: () {
          setState(() {
            currentIndex = pos;
            setState(() {});
          });
        },
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(currentIndex == pos ? activeIcon : icon,
                  color: currentIndex == pos
                      ? appStore.isDarkMode
                          ? Colors.white
                          : primaryColor
                      : textSecondaryColor),
              currentIndex == pos
                  ? Container(
                      height: 5,
                      width: 5,
                      margin: EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: appStore.isDarkMode ? Colors.white : primaryColor),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: widgets[currentIndex],
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: context.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(color: shadowColorGlobal, blurRadius: 2, spreadRadius: 1, offset: Offset(0, 1.0)),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              tabItem(0, activeIcon: Icons.home,icon:Icons.home_outlined),
              tabItem(1, activeIcon: Icons.category,icon:Icons.category_outlined),
              tabItem(2, activeIcon: Icons.bookmark,icon:Icons.bookmark_border),
              tabItem(3, activeIcon: Icons.person,icon:Icons.person_outlined),
            ],
          ),
        ),
      ),
    );
  }
}
