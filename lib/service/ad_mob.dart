import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'package:metext/utils/secrets.dart';

class AdService {
  Future<bool> initialize() async {
    return await FirebaseAdMob.instance
        .initialize(appId: await Secrets.getAdmobAppId());
  }

  InterstitialAd getInterstitial() {
    return _loadInterstitialAd();
  }

  final MobileAdTargetingInfo _targetingInfo = MobileAdTargetingInfo(
    keywords: ['text', 'book', 'school'],
    testDevices: [],
  );

  _loadInterstitialAd() {
    return InterstitialAd(
      adUnitId: kReleaseMode
          ? 'ca-app-pub-7145772846945296/3188657897'
          : InterstitialAd.testAdUnitId,
      targetingInfo: _targetingInfo,
    );
  }
}
