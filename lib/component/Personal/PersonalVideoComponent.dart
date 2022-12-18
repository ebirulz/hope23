import 'package:flutter/material.dart';
import 'package:mighty_personal_blog/component/VideoPlayDialog.dart';
import 'package:mighty_personal_blog/main.dart';
import '../../model/DefaultPostResponse.dart';
import '../../utils/AppCommon.dart';
import '../../utils/Extensions/Widget_extensions.dart';
import '../../utils/Extensions/context_extensions.dart';
import '../../utils/Extensions/decorations.dart';
import '../../utils/Extensions/int_extensions.dart';
import '../../utils/Extensions/string_extensions.dart';
import '../../utils/Extensions/text_styles.dart';

import '../../utils/Extensions/Commons.dart';

class PersonalVideoComponent extends StatefulWidget {
  static String tag = '/FitnessVideoComponent';

  final DefaultPostResponse mPost;
  final bool? isSlider;

  PersonalVideoComponent(this.mPost, {this.isSlider = false});

  @override
  PersonalVideoComponentState createState() => PersonalVideoComponentState();
}

class PersonalVideoComponentState extends State<PersonalVideoComponent> {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        VideoPlayDialog(widget.mPost.videoType!, widget.mPost.videoUrl!).launch(context);
      },
      child: Container(
        decoration: boxDecorationWithShadowWidget(backgroundColor: context.cardColor, blurRadius: appStore.isDarkMode ? 0 : 5),
        width: widget.isSlider == true ? context.width() * 0.7 : context.width(),
        child: Column(
          children: [
            8.height,
            Text(widget.mPost.postTitle.validate(), style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
            8.height,
            Stack(
              alignment: Alignment.center,
              children: [
                commonCacheImageWidget(widget.mPost.image.toString(), fit: BoxFit.cover, height: 150, width: widget.isSlider == true ? context.width() * 0.7 : context.width()),
                Icon(Icons.play_circle_outline, color: Colors.white, size: 30),
              ],
            ),
            Text(parseHtmlString(widget.mPost.postContent.validate()), style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center)
                .paddingSymmetric(horizontal: 8).visible(widget.mPost.postContent.validate().isNotEmpty),
          ],
        ),
      ),
    );
  }
}
