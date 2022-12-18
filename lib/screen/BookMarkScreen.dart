import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mighty_personal_blog/utils/Extensions/shared_pref.dart';
import '../component/Personal/PersonalBlogItemWidget.dart';
import '../utils/AppColor.dart';
import '../utils/AppConstant.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/Loader.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/text_styles.dart';
import '../component/Personal/PersonalFeatureComponent.dart';
import '../main.dart';
import '../component/NoDataWidget.dart';

class BookMarkScreen extends StatefulWidget {
  static String tag = '/SavedScreen';

  @override
  BookMarkScreenState createState() => BookMarkScreenState();
}

class BookMarkScreenState extends State<BookMarkScreen> {
  ScrollController scrollController = ScrollController();
  int page = 1;
  int numPage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
        page++;
        bookMarkStore.getBookMarkItem(page: page);
      }
    });
  }

  init() async {
    //   appStore.setLoading(true);
    // bookMarkStore.getBookMarkItem(page: 1);
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget slideLeftBackground() {
    return Container(
      decoration: boxDecorationWithRoundedCornersWidget(backgroundColor: primaryColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(defaultRadius), bottomLeft: Radius.circular(defaultRadius))),
      margin: EdgeInsets.only(bottom: 16),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            20.width,
            Icon(Icons.delete, color: Colors.white),
            Text(" " + language.btnRemove, style: primaryTextStyle(size: 18, color: Colors.white), textAlign: TextAlign.right),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWidget(language.lblBookMark, elevation: 0, showBack: false, textColor: Colors.white),
      body: Observer(builder: (context) {
        return Stack(
          children: [
            if (userStore.isLoggedIn)
              getStringAsync(CARD_LAYOUT) == DEFAULT_LAYOUT || getStringAsync(CARD_LAYOUT) == LIST_LAYOUT
                  ? AnimationLimiter(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: bookMarkStore.bookMarkPost.length,
                        padding: EdgeInsets.all(16),
                        itemBuilder: (_, index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            columnCount: 1,
                            child: SlideAnimation(
                              horizontalOffset: 50.0,
                              verticalOffset: 20.0,
                              child: FadeInAnimation(
                                  child: index % 2 == 0
                                      ? PersonalFeatureComponent(bookMarkStore.bookMarkPost[index], isSlider: false, isEven: true)
                                      : PersonalFeatureComponent(bookMarkStore.bookMarkPost[index], isSlider: false, isEven: false)),
                            ),
                          );
                        },
                      ).visible(!appStore.isLoading),
                    )
                  : AnimationLimiter(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Wrap(
                          runSpacing: 12,
                          spacing: 12,
                          children: List.generate(
                            bookMarkStore.bookMarkPost.length,
                            (index) {
                              return AnimationConfiguration.staggeredGrid(
                                duration: const Duration(milliseconds: 750),
                                columnCount: 1,
                                position: index,
                                child: FlipAnimation(
                                  curve: Curves.linear,
                                  child: FadeInAnimation(
                                    child: PersonalBlogItemWidget(bookMarkStore.bookMarkPost[index]),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
            NoDataWidget(language.emptyBookMarkTxt).center().visible(!appStore.isLoading && bookMarkStore.bookMarkPost.isEmpty),
            Loader().center().visible(appStore.isLoading)
          ],
        );
      }),
    );
  }
}
