import 'package:flutter/material.dart';
import '../model/WalkThroughModel.dart';
import '../utils/AppColor.dart';
import '../utils/AppCommon.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../main.dart';
import '../utils/AppImages.dart';
import 'ChooseTopicsScreen.dart';

class WalkThroughScreen extends StatefulWidget {
  static String tag = '/WalkThroughScreen';

  @override
  WalkThroughScreenState createState() => WalkThroughScreenState();
}

class WalkThroughScreenState extends State<WalkThroughScreen> {
  int? currentIndex = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  List<WalkThroughModel> walkThroughClass = [
    WalkThroughModel(
      text: "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs.",
      name: "Personal Blog",
      img: ic_walk1,
    ),
    WalkThroughModel(
      text: "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs.",
      name: "Choose Interested Topics",
      img: ic_walk2,
    ),
    WalkThroughModel(
      text: "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs.",
      name: "View Post",
      img: ic_walk3,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: Stack(
        children: [
          PageView.builder(
            itemCount: walkThroughClass.length,
            controller: pageController,
            itemBuilder: (context, i) {
              return Column(
                children: [
                  ClipPath(
                    clipper: CustomClipPath(),
                    child: Container(
                      height: context.height() * 0.6,
                      width: context.width(),
                      alignment: Alignment.center,
                      color: primaryColor,
                      child: Image.asset(
                        walkThroughClass[i].img.toString(),
                        fit: BoxFit.cover,
                        height: context.height() * 0.50,
                      ).paddingOnly(left: 16, right: 16),
                    ),
                  ),
                  20.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(walkThroughClass[currentIndex!.toInt()].name.toString(), style: boldTextStyle(size: 28)),
                      16.height,
                      Text(walkThroughClass[currentIndex!.toInt()].text.toString(), style: secondaryTextStyle(size: 16)),
                    ],
                  ).paddingOnly(left: 16, right: 16, top: 30),
                ],
              );
            },
            onPageChanged: (int i) {
              currentIndex = i;
              setState(() {});
            },
          ),
          Positioned(
            bottom: 30,
            right: 16,
            left: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dotIndicator(walkThroughClass, currentIndex, isPersonal: false).paddingTop(8),
                GestureDetector(
                  onTap: () {
                    if (currentIndex!.toInt() >= 2) {
                      ChooseTopicsScreen().launch(context);
                    } else {
                      pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.linearToEaseOut);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    decoration: boxDecorationWithRoundedCornersWidget(borderRadius: radius(defaultRadius), backgroundColor: primaryColor),
                    child: Text(currentIndex!.toInt() >= 2 ? language.btnGetStarted : language.btnNext, style: primaryTextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: context.statusBarHeight,
            right: 0,
            child: TextButton(
              onPressed: () {
                ChooseTopicsScreen().launch(context);
              },
              child: Text(language.lblSkip, style: boldTextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
