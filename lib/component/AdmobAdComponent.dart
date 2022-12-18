import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mighty_personal_blog/utils/Extensions/device_extensions.dart';
import '../utils/AppConstant.dart';
import '../main.dart';

InterstitialAd? interstitialAd;

adShow() async {
  if (interstitialAd == null) {
    print('Warning: attempt to show interstitial before loaded.');
    return;
  }
  interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) => print('ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      print('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      createInterstitialAd();
    },
  );
  interstitialAd!.show();
}

void createInterstitialAd() {
  InterstitialAd.load(
      adUnitId: kReleaseMode ? getInterstitialAdUnitId()! : (isAndroid ? adMobInterstitialId : adMobInterstitialIdIos),
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
          interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          interstitialAd = null;
        },
      ));
}

String? getBannerAdUnitId() {
  if (Platform.isIOS) {
    return dashboardStore.bannerIdIos.isNotEmpty ? dashboardStore.bannerIdIos : adMobBannerIdIos;
  } else if (Platform.isAndroid) {
    return dashboardStore.bannerId.isNotEmpty ? dashboardStore.bannerId : adMobBannerId;
  }
  return null;
}

String? getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return dashboardStore.interstitialIdIos.isNotEmpty ? dashboardStore.interstitialIdIos : adMobInterstitialIdIos;
  } else if (Platform.isAndroid) {
    return dashboardStore.interstitialId.isNotEmpty ? dashboardStore.interstitialId : adMobInterstitialId;
  }
  return null;
}
