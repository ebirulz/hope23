import 'package:flutter/material.dart';
import '../../component/Personal/PersonalQuickReadWidget.dart';
import '../../model/DefaultResponse.dart';
import '../../utils/Extensions/Constants.dart';
import '../../utils/Extensions/HorizontalList.dart';
import '../../utils/Extensions/Loader.dart';
import '../../utils/Extensions/Widget_extensions.dart';
import '../../utils/Extensions/context_extensions.dart';
import '../../utils/Extensions/int_extensions.dart';
import '../../utils/Extensions/string_extensions.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../component/AppWidget.dart';
import '../../component/Personal/PersonalBlogItemWidget.dart';
import '../../component/Personal/PersonalFeatureComponent.dart';
import '../../component/Personal/PersonalStoryComponent.dart';
import '../../component/Personal/PersonalSuggestForYouComponent.dart';
import '../../main.dart';
import '../../model/DefaultPostResponse.dart';
import '../../network/RestApi.dart';
import '../../utils/AppCommon.dart';
import '../../utils/AppConstant.dart';
import '../../utils/AppImages.dart';
import '../../utils/Extensions/shared_pref.dart';
import '../StoryViewScreen.dart';
import '../ViewAllScreen.dart';

class PersonalHomeScreen extends StatefulWidget {
  static String tag = '/PersonalHomeScreen';

  @override
  PersonalHomeScreenState createState() => PersonalHomeScreenState();
}

class PersonalHomeScreenState extends State<PersonalHomeScreen> with SingleTickerProviderStateMixin {
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();
  List<DefaultPostResponse> blogList = [];
  Future<DefaultResponse>? mGetData;
  int? currentIndex = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    mGetData = getDefaultDashboard();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget mHeading(String? title, String? viewAll, {String? data}) {
    return Container(
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GradientText(
            title.validate().toUpperCase(),
            style: TextStyle(color: textPrimaryColorGlobal, letterSpacing: 2, fontSize: 40),
            gradient: LinearGradient(
              colors: appStore.isDarkMode ? [
                Colors.white12.withOpacity(.07),
                Colors.white24.withOpacity(.05),
              ] : [
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
              Text(title.validate().toUpperCase(), style: TextStyle(color: textPrimaryColorGlobal, letterSpacing: 1, fontWeight: FontWeight.bold, fontSize: 26)),
              Text(language.btnMore, style: TextStyle(color: textSecondaryColorGlobal, fontWeight: FontWeight.normal, fontSize: 18))
            ],
          ),
        ],
      ).onTap((){
        ViewAllScreen(name: viewAll, catData: data, text: data.validate().isNotEmpty ? language.lblSuggestForYou : "").launch(context);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        await Future.delayed(Duration(seconds: 2));
      },
      child: FutureBuilder<DefaultResponse>(
        future: mGetData!,
        builder: (context, snap) {
          if (snap.hasData) {
            blogList.clear();
            snap.data!.category!.forEach((element) {
              Iterable it = element.blog!;
              it.map((e) => blogList.add(e)).toList();
            });
            log(blogList.toString());
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      16.height,
                      HorizontalList(
                          itemCount: snap.data!.storyPost!.length,
                          padding: EdgeInsets.only(left: 16),
                          itemBuilder: (_, index) {
                            return PersonalStoryComponent(
                              snap.data!.storyPost![index],
                              onCall: () {
                                StoryViewScreen(list: snap.data!.storyPost!).launch(context);
                              },
                            );
                          }),
                    ],
                  ).visible(snap.data!.storyPost != null && snap.data!.storyPost!.isNotEmpty),
                  Column(
                    children: [
                      16.height,
                      mHeading(language.lblSuggestForYou, 'by_category', data: getStringListAsync(chooseTopicList).toString()),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(ic_personal_bg, width: context.width(), height: context.height() * 0.3, fit: BoxFit.cover),
                          SizedBox(
                            height: context.height() * 0.45,
                            child: PageView.builder(
                              itemCount: blogList.length,
                              controller: pageController,
                              itemBuilder: (context, i) {
                                return PersonalSuggestForYouComponent(blogList[i]);
                              },
                              onPageChanged: (int i) {
                                currentIndex = i;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      dotIndicator(blogList, currentIndex, isPersonal: true).paddingTop(0),
                    ],
                  ).visible(blogList.isNotEmpty),
                  PersonalQuickReadWidget(snap.data!.recentPost!).visible(snap.data!.recentPost != null && snap.data!.recentPost!.isNotEmpty),
                  Column(
                    children: [
                      mHeading(language.lblRecentBlog, language.lblRecentBlog),
                      getStringAsync(CARD_LAYOUT) == DEFAULT_LAYOUT
                          ? HorizontalList(
                              itemCount: snap.data!.recentPost!.length,
                              padding: EdgeInsets.all(16),
                              itemBuilder: (_, index) {
                                return PersonalBlogItemWidget(snap.data!.recentPost![index]);
                              })
                          : getStringAsync(CARD_LAYOUT) == GRID_LAYOUT
                              ? Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: snap.data!.recentPost!.map((item) {
                                    return PersonalBlogItemWidget(item);
                                  }).toList(),
                                )
                              : ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: snap.data!.recentPost!.length,
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  itemBuilder: (_, index) {
                                    if (index % 2 == 0)
                                      return PersonalFeatureComponent(snap.data!.recentPost![index], isSlider: false, isEven: true);
                                    else
                                      return PersonalFeatureComponent(snap.data!.recentPost![index], isSlider: false, isEven: false);
                                  }),
                    ],
                  ).visible(snap.data!.recentPost != null && snap.data!.recentPost!.isNotEmpty),
                  Column(
                    children: [
                      16.height,
                      mHeading(language.lblFeaturedBlog, language.lblFeaturedBlog),
                      getStringAsync(CARD_LAYOUT) == DEFAULT_LAYOUT || getStringAsync(CARD_LAYOUT) == LIST_LAYOUT
                          ? ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: snap.data!.featurePost!.length,
                              padding: EdgeInsets.only(left: 16, right: 16),
                              itemBuilder: (_, index) {
                                if (index % 2 == 0)
                                  return PersonalFeatureComponent(snap.data!.featurePost![index], isSlider: false, isEven: true);
                                else
                                  return PersonalFeatureComponent(snap.data!.featurePost![index], isSlider: false, isEven: false);
                              })
                          : Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: snap.data!.featurePost!.map((item) {
                                return PersonalBlogItemWidget(item);
                              }).toList(),
                            ),
                    ],
                  ).visible(snap.data!.featurePost != null && snap.data!.featurePost!.isNotEmpty),
                  16.height,
                ],
              ),
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
