import 'package:flutter/material.dart';
import '../component/CategoryComponent.dart';
import '../model/CategoryResponse.dart';
import '../network/RestApi.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Widget_extensions.dart';

import '../component/AppWidget.dart';
import '../main.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
    return Scaffold(
      appBar: customAppBarWidget(language.lblCategories, elevation: 0, showBack: false, textColor: Colors.white),
      body: FutureBuilder<List<CategoryResponse>>(
        future: getCategory(0),
        builder: (context, snap) {
          if (snap.hasData) {
            return SingleChildScrollView(
              child: CategoryComponent(data: snap.data),
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
