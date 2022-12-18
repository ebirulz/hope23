import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../utils/Extensions/Widget_extensions.dart';

import '../AppImages.dart';

/// Circular Loader Widget
class Loader extends StatefulWidget {
  final Color? color;

  @Deprecated('accentColor is now deprecated and not being used. use defaultLoaderAccentColorGlobal instead')
  final Color? accentColor;
  final Decoration? decoration;
  final int? size;
  final double? value;
  final Animation<Color?>? valueColor;

  Loader({
    this.color,
    this.decoration,
    this.size,
    this.value,
    this.valueColor,
    this.accentColor,
  });

  @override
  LoaderState createState() => LoaderState();
}

class LoaderState extends State<Loader> {
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
    return  Lottie.asset(ic_loader,height: 120,width: 120).center();
  }
}
