import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mighty_personal_blog/utils/AppConstant.dart';
import 'package:mighty_personal_blog/utils/Extensions/Constants.dart';
import '../main.dart';
import '../model/CategoryResponse.dart';
import '../screen/SubCategoryScreen.dart';
import '../utils/AppImages.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/string_extensions.dart';

import '../utils/Extensions/text_styles.dart';

class CategoryComponent extends StatefulWidget {
  final List<CategoryResponse>? data;

  CategoryComponent({this.data});

  @override
  _CategoryComponentState createState() => _CategoryComponentState();
}

class _CategoryComponentState extends State<CategoryComponent> {
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
    return AnimationLimiter(
      child: getStringAsync(CARD_LAYOUT) == DEFAULT_LAYOUT || getStringAsync(CARD_LAYOUT) == GRID_LAYOUT
          ? Wrap(
              runSpacing: 12,
              spacing: 12,
              children: List.generate(
                widget.data!.length,
                (index) {
                  CategoryResponse data = widget.data![index];
                  return AnimationConfiguration.staggeredGrid(
                    duration: const Duration(milliseconds: 750),
                    columnCount: 1,
                    position: index,
                    child: FlipAnimation(
                      curve: Curves.linear,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: (() {
                            SubCategoryScreen(
                              catName: data.catName,
                              catId: data.catID,
                            ).launch(context);
                          }),
                          child: Container(
                            decoration: boxDecorationWithShadowWidget(blurRadius: 1, borderRadius: BorderRadius.circular(defaultRadius), backgroundColor: context.cardColor),
                            width: (context.width() - 56) / 3,
                            padding: EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: boxDecorationWithShadowWidget(backgroundColor: appStore.isDarkMode ? Colors.white70 : Colors.white10, boxShape: BoxShape.circle),
                                  child: Container(
                                      padding: EdgeInsets.all(1),
                                      decoration: boxDecorationWithShadowWidget(backgroundColor: context.cardColor, boxShape: BoxShape.circle),
                                      child: !data.image.validate().isEmptyOrNull
                                          ? CircleAvatar(backgroundColor: context.cardColor, backgroundImage: NetworkImage(data.image.validate()), maxRadius: 40)
                                          : CircleAvatar(backgroundColor: context.cardColor, backgroundImage: AssetImage(ic_placeHolder), maxRadius: 40)),
                                ),
                                6.height,
                                Text(data.name.validate(), style: boldTextStyle(size: 15), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ).paddingAll(16)
          : ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              physics: ScrollPhysics(),
              children: List.generate(
                widget.data!.length,
                (index) {
                  CategoryResponse data = widget.data![index];
                  return AnimationConfiguration.staggeredGrid(
                    columnCount: 1,
                    position: index,
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      verticalOffset: 20.0,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: (() {
                            SubCategoryScreen(
                              catName: data.catName,
                              catId: data.catID,
                            ).launch(context);
                          }),
                          child: Container(
                            decoration: boxDecorationWithShadowWidget(
                              blurRadius: 1,
                              borderRadius: BorderRadius.circular(defaultRadius),
                              backgroundColor: context.cardColor,
                            ),
                             padding: EdgeInsets.all(10),
                            height: 80,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: boxDecorationWithShadowWidget(backgroundColor: appStore.isDarkMode ? Colors.white70 : Colors.white10, boxShape: BoxShape.circle),
                                  child: Container(
                                      padding: EdgeInsets.all(1),
                                      decoration: boxDecorationWithShadowWidget(backgroundColor: context.cardColor, boxShape: BoxShape.circle),
                                      child: !data.image.validate().isEmptyOrNull
                                          ? CircleAvatar(backgroundColor: context.cardColor, backgroundImage: NetworkImage(data.image.validate()), maxRadius: 30)
                                          : CircleAvatar(backgroundColor: context.cardColor, backgroundImage: AssetImage(ic_placeHolder), maxRadius: 30)),
                                ),
                                16.width,
                                Text(data.name.validate(), style: boldTextStyle(size: 16), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).paddingOnly(bottom: 16);
                },
              ),
            ),
    );
  }
}
