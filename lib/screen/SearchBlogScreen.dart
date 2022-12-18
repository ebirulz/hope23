import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_personal_blog/component/Personal/PersonalBlogItemWidget.dart';
import '../model/DefaultPostResponse.dart';
import '../network/RestApi.dart';
import '../utils/AppCommon.dart';
import '../utils/AppConstant.dart';
import '../utils/Extensions/AppTextField.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Loader.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/text_styles.dart';
import '../component/AppWidget.dart';
import '../component/Personal/PersonalFeatureComponent.dart';
import '../main.dart';

class SearchBlogScreen extends StatefulWidget {
  @override
  _SearchBlogScreenState createState() => _SearchBlogScreenState();
}

class _SearchBlogScreenState extends State<SearchBlogScreen> {
  TextEditingController searchCont = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<String> previousSearch = [];
  List<DefaultPostResponse> defaultPostResponseList = [];

  int page = 1;
  int numPage = 1;
  bool isLoading = false;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    appStore.setLoading(true);
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
        page++;
        loadBlogData();
      }
    });
  }

  void init() async {
    searchCont.text = "";
    loadBlogData();
  }

  Future<void> loadBlogData() async {
    isLoading = true;
    appStore.setLoading(true);
    blogFilterApi(page, searchText: searchCont.text).then((res) async {
      appStore.setLoading(false);
      isLoading = false;
      setState(() {});
      numPage = res.numPages.validate(value: 1);
      isLastPage = false;
      if (page == 1) {
        defaultPostResponseList.clear();
      }
      defaultPostResponseList.addAll(res.posts!);
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      isLoading = false;
      setState(() {});
      appStore.setLoading(false);
      apiErrorComponent(e, context);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.lblSearchBlogs, elevation: 0, showBack: true, textColor: Colors.white),
      body: Stack(
        children: [
          Column(
            children: [
              AppTextField(
                autoFocus: true,
                textFieldType: TextFieldType.OTHER,
                decoration: inputDecoration(context, label: language.lblSearchBlogs, prefixIcon: Icon(Ionicons.search_outline)),
                controller: searchCont,
                onChanged: (v) async {
                  loadBlogData();
                  setState(() {});
                },
                onFieldSubmitted: (c) {
                  if (getStringListAsync(searchList) != null) {
                    previousSearch = getStringListAsync(searchList)!;
                    if (previousSearch.contains(searchCont.text) == true) {
                      previousSearch.remove(searchCont.text);
                    } else
                      previousSearch.add(searchCont.text);
                    setValue(searchList, previousSearch);
                  } else {
                    previousSearch.add(searchCont.text);
                    setValue(searchList, previousSearch);
                  }
                  loadBlogData();
                  setState(() {});
                },
              ).paddingAll(16),
              if (searchCont.text.isNotEmpty)
                getStringAsync(CARD_LAYOUT) == LIST_LAYOUT || getStringAsync(CARD_LAYOUT) == DEFAULT_LAYOUT
                    ? ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(16),
                        itemCount: defaultPostResponseList.length,
                        itemBuilder: (_, index) {
                          DefaultPostResponse data = defaultPostResponseList[index];
                          if (index % 2 == 0)
                            return PersonalFeatureComponent(data, isSlider: false, isEven: true);
                          else
                            return PersonalFeatureComponent(data, isSlider: false, isEven: false);
                        },
                      ).expand()
                    : AnimationLimiter(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(16),
                          child: Wrap(
                            runSpacing: 12,
                            spacing: 12,
                            children: List.generate(
                              defaultPostResponseList.length,
                              (index) {
                                return AnimationConfiguration.staggeredGrid(
                                  duration: const Duration(milliseconds: 750),
                                  columnCount: 1,
                                  position: index,
                                  child: FlipAnimation(
                                    curve: Curves.linear,
                                    child: FadeInAnimation(
                                      child: PersonalBlogItemWidget(
                                        defaultPostResponseList[index],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ).expand(),
              if (getStringListAsync(searchList) != null && searchCont.text.isEmpty)
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: getStringListAsync(searchList)!.length,
                    itemBuilder: (_, i) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              searchCont.text = getStringListAsync(searchList)![i];
                              setState(() {});
                            },
                            child: Text(getStringListAsync(searchList)![i], style: secondaryTextStyle(), textAlign: TextAlign.start),
                          ),
                          IconButton(
                            onPressed: () {
                              log(getStringListAsync(searchList)![i]);
                              List<String> list = getStringListAsync(searchList)!;
                              list.removeAt(i);
                              setValue(searchList, list);
                              setState(() {});
                              log(getStringListAsync(searchList));
                            },
                            icon: Icon(Icons.clear),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      );
                    }).expand(),
            ],
          ),
          Loader().center().visible(appStore.isLoading)
        ],
      ),
    );
  }
}
