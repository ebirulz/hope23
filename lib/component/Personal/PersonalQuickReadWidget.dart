import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mighty_personal_blog/screen/manifesto.dart';
import '../../utils/AppColor.dart';
import '../../utils/Extensions/Widget_extensions.dart';
import '../../utils/Extensions/context_extensions.dart';
import '../../main.dart';
import '../../model/DefaultPostResponse.dart';
import '../../screen/QuickReadScreen.dart';
import '../../utils/Extensions/Constants.dart';
import '../../utils/Extensions/decorations.dart';
import '../../utils/Extensions/text_styles.dart';
import '../AppWidget.dart';

class PersonalQuickReadWidget extends StatefulWidget {
  final List<DefaultPostResponse>? list;

  PersonalQuickReadWidget(this.list);

  @override
  _PersonalQuickReadWidgetState createState() => _PersonalQuickReadWidgetState();
}

class _PersonalQuickReadWidgetState extends State<PersonalQuickReadWidget> {
  int pos = 0;
  Timer? time;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (dashboardStore.disableQuickview) return SizedBox();

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.4),
        boxShadow: defaultBoxShadow(blurRadius: 5),
      ),
      child: Container(
        width: context.width(),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: defaultBoxShadow(blurRadius: 5),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            GradientText(
              language.lblQuickLook.toUpperCase(),
              style: TextStyle(color: textPrimaryColorGlobal, letterSpacing: 2, fontSize: 50),
              gradient: LinearGradient(
                colors: [
                  Colors.black12.withOpacity(.07),
                  Colors.black26.withOpacity(.05),
                ],
              ),
            ),
            Column(
              children: [
                Text(language.lblQuickLook.toUpperCase(), style:TextStyle(color: textPrimaryColorGlobal, letterSpacing: 2, fontSize: 30)).paddingLeft(8),
                Text(language.lblQuickLookSubTitle, style: secondaryTextStyle(),textAlign: TextAlign.center),
              ],
            ).paddingSymmetric( vertical: 16,horizontal: 8),
          ],
        ),
      ).onTap(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const ManifestoScreen())
        );
      }),
    );
  }
}
