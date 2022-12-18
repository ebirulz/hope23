import 'package:flutter/material.dart';
import '../../main.dart';
import '../../model/DefaultPostResponse.dart';
import '../../utils/AppColor.dart';
import '../../utils/AppCommon.dart';
import '../../utils/AppConstant.dart';
import '../../utils/Extensions/Commons.dart';
import '../../utils/Extensions/Widget_extensions.dart';
import '../../utils/Extensions/context_extensions.dart';
import '../../utils/Extensions/decorations.dart';
import '../../utils/Extensions/int_extensions.dart';
import '../../utils/Extensions/string_extensions.dart';
import '../../utils/Extensions/text_styles.dart';
import '../../screen/Personal/PersonalDetailScreen.dart';
import '../../utils/Extensions/Colors.dart';
import '../AppWidget.dart';
import '../VideoPlayDialog.dart';

class PersonalFeatureComponent extends StatefulWidget {
  final DefaultPostResponse? featureData;
  final bool? isSlider;
  final bool? isEven;

  PersonalFeatureComponent(this.featureData, {this.isSlider, this.isEven});

  @override
  _PersonalFeatureComponentState createState() => _PersonalFeatureComponentState();
}

class _PersonalFeatureComponentState extends State<PersonalFeatureComponent> {
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
    return GestureDetector(
      onTap: () {
        widget.featureData!.postType == postVideoType ? VideoPlayDialog(widget.featureData!.videoType!, widget.featureData!.videoUrl!).launch(context) : PersonalDetailScreen(postId: widget.featureData!.iD).launch(context);
      },
      child: Container(
        width: context.width(),
        height: 210,
        margin: EdgeInsets.only(bottom: 16),
        decoration: boxDecorationWithShadowWidget(backgroundColor: context.cardColor, blurRadius: appStore.isDarkMode ? 0 : 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(width: 100, height: 210, color: primaryColor),
                Container(
                  margin: EdgeInsets.all(12),
                  height: 170,
                  width: 170,
                  decoration: boxDecorationWithShadowWidget(border: Border.all(color: Colors.white, width: 2)),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      commonCacheImageWidget(widget.featureData!.image.validate(), fit: BoxFit.cover,width: 170,height: 170),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: boxDecorationWithShadowWidget(backgroundColor: appStore.isDarkMode ? Colors.black38 : Colors.white38),
                        child: bookMarkComponent(widget.featureData!, context),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.play_circle_outline, color: Colors.white, size: 40).visible(widget.featureData!.postType == postVideoType),
              ],
            ).visible(widget.isEven != true),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.featureData!.postTitle!, style: boldTextStyle(size: 18), maxLines: 2, overflow: TextOverflow.ellipsis),
                8.height,
                Text(parseHtmlString(widget.featureData!.postContent!), maxLines: 3, overflow: TextOverflow.ellipsis, style: secondaryTextStyle()),
                12.height,
                Row(
                  children: [
                    Icon(Icons.add, size: 14, color: textSecondaryColor.withOpacity(0.6)),
                    4.width,
                    Text(language.explore, style: secondaryTextStyle(color: textSecondaryColor.withOpacity(0.6))),
                  ],
                )
              ],
            ).paddingOnly(right: 8, left: 16).expand(),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(width: 100, height: 210, color: primaryColor),
                Container(
                  margin: EdgeInsets.all(12),
                  height: 170,
                  width: 170,
                  decoration: boxDecorationWithShadowWidget(border: Border.all(color: Colors.white, width: 2)),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      commonCacheImageWidget(widget.featureData!.image.validate(), fit: BoxFit.cover,width: 170,height: 170),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: boxDecorationWithShadowWidget(backgroundColor: appStore.isDarkMode ? Colors.black38 : Colors.white38),
                        child: bookMarkComponent(widget.featureData!, context),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.play_circle_outline, color: Colors.white, size: 40).visible(widget.featureData!.postType == postVideoType),
              ],
            ).visible(widget.isEven == true),
          ],
        ),
      ),
    );
  }
}
