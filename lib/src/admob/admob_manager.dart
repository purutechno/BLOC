import 'package:admob_flutter/admob_flutter.dart';

class AdmobManager {
  static bool _isTest = false;

  /** Test IDs **/
  static String test_app_id = "ca-app-pub-3940256099942544~3347511713";
  static String test_banner_id = "ca-app-pub-3940256099942544/6300978111";

  /** You real IDs **/
  static String app_id = "ca-app-pub-5485695454641044~6788182080";
  static String banner_id = "ca-app-pub-5485695454641044/7784608528";

  static String interstitial_id = "ca-app-pub-5485695454641044/9188318364";

  static Admob initAdMob() {
    print("initAdMob");
    return Admob.initialize(_isTest ? test_app_id : app_id);
  }

  static AdmobBanner bottomBanner = AdmobBanner(
    adUnitId: _isTest ? test_banner_id : banner_id,
    adSize: AdmobBannerSize.FULL_BANNER
  );

  static AdmobBanner finishBanner = AdmobBanner(
    adUnitId: _isTest ? test_banner_id : banner_id,
    adSize: AdmobBannerSize.FULL_BANNER,
  );
  static AdmobBanner mediumRectangle = AdmobBanner(
    adUnitId: _isTest ? test_banner_id : banner_id,
    adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
  );
  static AdmobBanner leaderBoard = AdmobBanner(
    adUnitId: _isTest ? test_banner_id : banner_id,
    adSize: AdmobBannerSize.LEADERBOARD,
  );
  // Intertestial ads
  static String test_interstitial_id = "ca-app-pub-3940256099942544/1033173712";
  static AdmobInterstitial interstitialAd = AdmobInterstitial(
  adUnitId: test_interstitial_id,
);
}