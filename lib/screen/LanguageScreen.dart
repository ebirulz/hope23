import 'package:flutter/material.dart';
import '../model/LanguageDataModel.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/string_extensions.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/AppColor.dart';

import '../main.dart';
import '../utils/AppCommon.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
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
    return Scaffold(
      appBar: appBarWidget(language.lblSelectLanguage, textColor: Colors.white),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Wrap(
          runSpacing: 16,
          spacing: 16,
          children: List.generate(localeLanguageList.length, (index) {
            LanguageDataModel data = localeLanguageList[index];
            return Container(
              width: (context.width() - 48) / 2,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultRadius),
                  color: getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE) == data.languageCode.validate()
                      ? appStore.isDarkMode
                          ? primaryColor
                          : primaryColor.withOpacity(0.2)
                      : context.scaffoldBackgroundColor,
                  border: Border.all(color: getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE) == data.languageCode.validate() ? primaryColor : context.dividerColor)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(data.flag.validate(), width: 34),
                  12.width,
                  Text('${data.name.validate()}', style: boldTextStyle(),maxLines: 2).expand(),
                ],
              ).paddingAll(12),
            ).onTap(
              () async {
                setValue(SELECTED_LANGUAGE_CODE, data.languageCode);
                selectedLanguageDataModel = data;
                appStore.setLanguage(data.languageCode!, context: context);
                setState(() {});
                finish(context, true);
              },
              borderRadius: radius(defaultRadius),
            );
          }),
        ),
      ),
      bottomNavigationBar: showBannerAds(),
    );
  }
}
