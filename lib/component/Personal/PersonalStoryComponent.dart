import 'package:flutter/material.dart';
import '../../model/DefaultPostResponse.dart';
import '../../utils/Extensions/Widget_extensions.dart';
import '../../utils/Extensions/context_extensions.dart';
import '../../utils/Extensions/string_extensions.dart';

import '../../utils/AppColor.dart';
import '../../utils/AppImages.dart';
import '../../utils/Extensions/decorations.dart';

class PersonalStoryComponent extends StatefulWidget {
  static String tag = '/FitnessStoryComponent';
  final DefaultPostResponse mPost;
  final Function? onCall;

  PersonalStoryComponent(this.mPost, {this.onCall});

  @override
  PersonalStoryComponentState createState() => PersonalStoryComponentState();
}

class PersonalStoryComponentState extends State<PersonalStoryComponent> {
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
    return Container(
      width: 80,
      height: 80,
      margin: EdgeInsets.only(right: 6),
      decoration: boxDecorationWithRoundedCornersWidget(boxShape: BoxShape.circle, border: Border.all(width: 2, color: primaryColor)),
      child: widget.mPost.image.isEmptyOrNull
          ? CircleAvatar(backgroundColor: context.cardColor, backgroundImage: AssetImage(ic_placeHolder)).cornerRadiusWithClipRRect(85).paddingAll(2)
          : CircleAvatar(backgroundColor: context.cardColor, backgroundImage: NetworkImage(widget.mPost.image!.validate())).cornerRadiusWithClipRRect(85).paddingAll(2),
    ).onTap(() {
      widget.onCall!.call();
    });
  }
}
