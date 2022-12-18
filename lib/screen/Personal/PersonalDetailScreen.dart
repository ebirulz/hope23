import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../../component/Personal/PersonalBlogItemWidget.dart';
import '../../main.dart';
import '../../model/BlogDetailResponse.dart';
import '../../network/RestApi.dart';
import '../../screen/SignInScreen.dart';
import '../../utils/AppColor.dart';
import '../../utils/AppCommon.dart';
import '../../utils/Extensions/Constants.dart';
import '../../utils/Extensions/HorizontalList.dart';
import '../../utils/Extensions/Widget_extensions.dart';
import '../../utils/Extensions/context_extensions.dart';
import '../../utils/Extensions/decorations.dart';
import '../../utils/Extensions/int_extensions.dart';
import '../../utils/Extensions/string_extensions.dart';
import '../../utils/Extensions/text_styles.dart';
import 'package:share_plus/share_plus.dart';
import '../../component/AppWidget.dart';
import '../../component/HtmlWidget.dart';
import '../../component/ReadAloudDialog.dart';
import '../../utils/Extensions/Commons.dart';
import '../ViewAllScreen.dart';

class PersonalDetailScreen extends StatefulWidget {
  static String tag = '/PersonalDetailScreen';
  final int? postId;

  PersonalDetailScreen({this.postId});

  @override
  PersonalDetailScreenState createState() => PersonalDetailScreenState();
}

class PersonalDetailScreenState extends State<PersonalDetailScreen> {
  bool? isLike;

  Future<BlogDetailResponse>? mGetDetail;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    loadInterstitialAds();
    mGetDetail = getBlogDetail(widget.postId!);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    showInterstitialAds();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<BlogDetailResponse>(
        future: mGetDetail,
        builder: (context, snap) {
          if (snap.hasData) {
            return Stack(
              alignment: Alignment.bottomRight,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackButton(),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  likeDislike(widget.postId.validate(), context, onCall: () {
                                    setState(() {
                                      mGetDetail = getBlogDetail(widget.postId!);
                                    });
                                  });
                                },
                                icon: Icon(snap.data!.isLike! ? Icons.favorite : Icons.favorite_border, color: snap.data!.isLike != true ? context.iconColor : primaryColor)),
                            IconButton(
                              onPressed: () {
                                Share.share('Share ${snap.data!.postTitle} \n\n$playStoreBaseURL${snap.data!.shareUrl}');
                              },
                              icon: Icon(Ionicons.share_social_outline, color: context.iconColor),
                            ),
                            ReadAloudDialog(parseHtmlString(snap.data!.postContent)).fit(),
                          ],
                        )
                      ],
                    ).paddingTop(context.statusBarHeight + 4),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //title
                          8.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(height: 100, width: 40, color: primaryColor).paddingTop(8),
                              10.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  8.height,
                                  Container(
                                    width: 250,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                    ),
                                    child:Text(
                                        parseHtmlString(snap.data!.postTitle.validate().toUpperCase()),
                                        style: TextStyle(fontSize: 20, color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ).expand(),
                            ],
                          ).paddingSymmetric(horizontal: 16, vertical: 8),
                          // Load image
                          SizedBox(
                            width: context.width(),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.bottomRight,
                              children: [
                                commonCacheImageWidget(snap.data!.image.validate(), fit: BoxFit.cover, height: context.height() * 0.35, width: context.height()),
                                if (snap.data!.postDate.validate().isNotEmpty)
                                  Positioned(
                                    right: -20,
                                    bottom: -20,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(snap.data!.humanTimeDiff.validate().toUpperCase(), style: TextStyle(fontSize: 20, color: textPrimaryColorGlobal, fontWeight: FontWeight.bold)),
                                        ).paddingBottom(10),
                                        Container(height: 130, width: 40, color: primaryColor),
                                      ],
                                    ),
                                  ),
                              ],
                            ).paddingOnly(top: 16, right: 16),
                          ).paddingSymmetric(horizontal: 16),
                          24.height,

                          // Tag
                          if (snap.data!.tags != null && snap.data!.tags!.isNotEmpty)
                            Wrap(
                              runSpacing: 4,
                              children: List.generate(
                                snap.data!.tags!.length,
                                (index) {
                                  Tags data = snap.data!.tags![index];
                                  return GestureDetector(
                                    onTap: (() {
                                      ViewAllScreen(name: 'by_tag', text: data.name.validate(), tagId: data.termId).launch(context);
                                      setState(() {});
                                    }),
                                    child: Container(
                                        padding: EdgeInsets.all(8),
                                        margin: EdgeInsets.only(right: 8),
                                        decoration: boxDecorationWithShadowWidget(backgroundColor: primaryColor, borderRadius: radius(8)),
                                        child: Text(data.name.validate() + " ", style: secondaryTextStyle(color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                  );
                                },
                              ),
                            ).paddingOnly(left: 16, bottom: 16, top: 16).visible(snap.data!.tags != null && snap.data!.tags!.isNotEmpty),
                          8.height.visible(snap.data!.tags == null && snap.data!.tags!.isEmpty),
                          //Description
                          HtmlWidget(postContent: snap.data!.postContent.validate()).paddingOnly(left: 16, right: 16),

                          //related post
                          if (snap.data!.relatedNews!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                16.height,
                                Text(language.lblRelatablePost, style: boldTextStyle(size: 18)).paddingSymmetric(horizontal: 16),
                                HorizontalList(
                                    itemCount: snap.data!.relatedNews!.length,
                                    padding: EdgeInsets.all(16),
                                    itemBuilder: (_, index) {
                                      return PersonalBlogItemWidget(snap.data!.relatedNews![index]);
                                    }),
                              ],
                            ).visible(snap.data!.relatedNews!.isNotEmpty && snap.data!.relatedNews != null),
                        ],
                      ),
                    ).expand(),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20, right: 16),
                  padding: EdgeInsets.all(12),
                  decoration: boxDecorationWithShadowWidget(backgroundColor: context.cardColor, blurRadius: 10, boxShape: BoxShape.circle),
                  child: Observer(builder: (context) {
                    return bookMarkStore.isItemInBookMark(widget.postId.validate()) ? Icon(Ionicons.bookmark, color: primaryColor) : Icon(Ionicons.bookmark_outline, color: context.iconColor);
                  }),
                ).onTap(() {
                  if (userStore.isLoggedIn) {
                    addToBookMark(snap.data!);
                    setState(() {});
                  } else {
                    SignInScreen().launch(context);
                  }
                })
              ],
            );
          }
          if (snap.hasError) {
            apiErrorComponent(snap.error, context);
          }
          return snapWidgetHelper(snap);
        },
      ),
    );
  }
}
