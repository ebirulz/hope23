import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../model/CategoryResponse.dart';
import '../network/RestApi.dart';
import '../screen/DashboardScreen.dart';
import '../utils/AppColor.dart';
import '../utils/AppCommon.dart';
import '../utils/AppConstant.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/Loader.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/string_extensions.dart';
import '../utils/Extensions/text_styles.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../component/AppWidget.dart';
import '../main.dart';

class ChooseTopicsScreen extends StatefulWidget {
  @override
  _ChooseTopicsScreenState createState() => _ChooseTopicsScreenState();
}

class _ChooseTopicsScreenState extends State<ChooseTopicsScreen> {
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  List<CategoryResponse>? catResponse = [];
  List<String> selectedId = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    log(getStringListAsync(chooseTopicList));
    getCategoryList();
  }

  getCategoryList() async {
    appStore.setLoading(true);
    await getCategory(0).then((value) {
      catResponse = value;
      appStore.setLoading(false);
      setState(() {});
      log(catResponse);
    }).catchError((e) {
      appStore.setLoading(false);
      log(e.toString());
      apiErrorComponent(e, context);
    });
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
      appBar: appBarWidget(language.chooseTopics, textColor: Colors.white, showBack: true),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 75),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(language.chooseTopics, style: boldTextStyle(size: 24)),
                4.height,
                Text(language.chooseTopicsOptions, style: secondaryTextStyle()),
                20.height,
                AnimationLimiter(
                  child: Wrap(
                    runSpacing: 12,
                    spacing: 12,
                    children: List.generate(
                      catResponse!.length,
                      (index) {
                        CategoryResponse data = catResponse![index];
                        return AnimationConfiguration.staggeredGrid(
                          duration: const Duration(milliseconds: 250),
                          columnCount: 1,
                          position: index,
                          child: FlipAnimation(
                            curve: Curves.linear,
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: (() {
                                  if (getStringListAsync(chooseTopicList) != null) {
                                    selectedId = getStringListAsync(chooseTopicList)!;
                                    if (selectedId.contains(data.catID!.toString()) == true) {
                                      selectedId.remove(data.catID!.toString());
                                    } else
                                      selectedId.add(data.catID!.toString());
                                    setValue(chooseTopicList, selectedId);
                                  } else {
                                    selectedId.add(data.catID!.toString());
                                    setValue(chooseTopicList, selectedId);
                                  }
                                  setState(() {});
                                }),
                                child: SizedBox(
                                  width: (context.width() - 56) / 3,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      commonCacheImageWidget(data.image.validate(), height: 120, width: (context.width() - 48) / 3, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
                                      Container(height: 120, decoration: boxDecorationWithShadowWidget(backgroundColor: Colors.black.withOpacity(0.25), borderRadius: radius(defaultRadius))),
                                      Positioned(
                                        bottom: 8,
                                        left: 10,
                                        child: Text(data.name.validate(), style: boldTextStyle(color: Colors.white,size: 15), maxLines: 2, overflow: TextOverflow.ellipsis),
                                      ),
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: Icon(Icons.check_circle, color: Colors.white).visible(getStringListAsync(chooseTopicList) != null ? getStringListAsync(chooseTopicList)!.contains(data.catID!.toString()) : false),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ).visible(catResponse!.isNotEmpty),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: RoundedLoadingButton(
              successIcon: Icons.done,
              failedIcon: Icons.close,
              borderRadius: defaultRadius,
              child: Text(language.btnContinue, style: boldTextStyle(color: Colors.white)),
              animateOnTap: false,
              resetDuration: 3.seconds,
              resetAfterDuration: true,
              width: context.width(),
              color: primaryColor,
              onPressed: () {
                if (getStringListAsync(chooseTopicList) != null && getStringListAsync(chooseTopicList)!.length >= 3)
                  DashboardScreen().launch(context, isNewTask: true);
                else
                  toast(language.msgChooseTopic);
              },
              controller: btnController,
            ).visible(catResponse!.isNotEmpty),
          ),
          Loader().center().visible(appStore.isLoading)
        ],
      ),
    );
  }
}
