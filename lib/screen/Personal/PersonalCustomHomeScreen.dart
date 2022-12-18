import 'package:flutter/material.dart';
import 'package:mighty_personal_blog/component/Personal/PersonalBlogItemWidget.dart';
import '../../utils/Extensions/Widget_extensions.dart';
import '../../utils/Extensions/string_extensions.dart';
import '../../component/AppWidget.dart';
import '../../component/Personal/PersonalCustomCategoryComponent.dart';
import '../../component/Personal/PersonalFeatureComponent.dart';
import '../../component/Personal/PersonalVideoComponent.dart';
import '../../main.dart';
import '../../model/CustomDashboardResponse.dart';
import '../../network/RestApi.dart';
import '../../utils/AppConstant.dart';
import '../../utils/Extensions/Constants.dart';
import '../../utils/Extensions/HorizontalList.dart';
import '../../utils/Extensions/Loader.dart';

class PersonalCustomHomeScreen extends StatefulWidget {
  static String tag = '/PersonalCustomHomeScreen';

  @override
  PersonalCustomHomeScreenState createState() => PersonalCustomHomeScreenState();
}

class PersonalCustomHomeScreenState extends State<PersonalCustomHomeScreen> {
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

  Widget mHeading(String? title, {bool? isViewAll = true, int? id, var data}) {
    return Container(
      height: 65,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GradientText(
            title.validate().toUpperCase(),
            style: TextStyle(color: textPrimaryColorGlobal, letterSpacing: 2, fontSize: 50),
            gradient: LinearGradient(
              colors: appStore.isDarkMode
                  ? [
                      Colors.white12.withOpacity(.07),
                      Colors.white24.withOpacity(.05),
                    ]
                  : [
                      Colors.black12.withOpacity(.07),
                      Colors.black26.withOpacity(.05),
                    ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title.validate().toUpperCase(), style: TextStyle(color: textPrimaryColorGlobal, fontWeight: FontWeight.bold, fontSize: 26)),
              Text(language.btnMore, style: TextStyle(color: textPrimaryColorGlobal, fontWeight: FontWeight.normal, fontSize: 18)).onTap(() {}).visible(isViewAll == true)
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        await Future.delayed(Duration(seconds: 2));
      },
      child: FutureBuilder<List<CustomDashboardResponse>>(
        future: getCustomDashboard(),
        builder: (context, snap) {
          if (snap.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: List.generate(
                  snap.data!.length,
                  (index) {
                    CustomDashboardResponse? data;
                    data = snap.data![index];
                    return Column(
                      children: [
                        mHeading(data.title.validate(), isViewAll: data.viewAll, id: index, data: data.type),
                        if (data.type == postType)
                          data.displayOption == "slider"
                              ? HorizontalList(
                                  itemCount: data.data!.length,
                                  padding: EdgeInsets.all(16),
                                  itemBuilder: (_, index) {
                                    return PersonalBlogItemWidget(data!.data![index]);
                                  })
                              : ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: data.data!.length,
                                  padding: EdgeInsets.all(16),
                                  itemBuilder: (_, index) {
                                    if (index % 2 == 0)
                                      return PersonalFeatureComponent(data!.data![index], isSlider: false, isEven: true);
                                    else
                                      return PersonalFeatureComponent(data!.data![index], isSlider: false, isEven: false);
                                  }),
                        if (data.type == postVideoType)
                          data.displayOption == "slider"
                              ? HorizontalList(
                                  itemCount: data.data!.length,
                                  padding: EdgeInsets.all(16),
                                  itemBuilder: (_, i) {
                                    return PersonalVideoComponent(data!.data![i], isSlider: true);
                                  })
                              : ListView(
                                  shrinkWrap: true,
                                 // padding: BorderRadius.only(),
                                  physics: NeverScrollableScrollPhysics(),
                                  children: List.generate(
                                    data.data!.length,
                                    (index) {
                                      return PersonalVideoComponent(data!.data![index], isSlider: false).paddingOnly(bottom: 16);
                                    },
                                  ),
                                ).paddingSymmetric(horizontal: 16),
                        if (data.type == postCategoryType)
                          data.displayOption == "slider"
                              ? HorizontalList(
                                  itemCount: data.data!.length,
                                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
                                  itemBuilder: (_, index1) {
                                    return PersonalCustomCategoryComponent(data!.data![index1], isSlider: true);
                                  })
                              : Wrap(
                                  runSpacing: 18,
                                  spacing: 14,
                                  children: List.generate(
                                    data.data!.length,
                                    (index) {
                                      return PersonalCustomCategoryComponent(data!.data![index], isSlider: false);
                                    },
                                  ),
                                ).paddingSymmetric(horizontal: 16, vertical: 8),
                      ],
                    ).paddingOnly(bottom: 16);
                  },
                ),
              ).paddingOnly(top: 16),
            );
          }
          if (snap.hasError) {
            apiErrorComponent(snap.error, context);
          }
          return snapWidgetHelper(snap, loadingWidget: Loader().center());
        },
      ),
    );
  }
}
