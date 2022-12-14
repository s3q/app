import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1978882800082850/8694792406';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1978882800082850/3372721493';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return '<YOUR_ANDROID_INTERSTITIAL_AD_UNIT_ID>';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return '<ca-app-pub-1978882800082850/8139875165>';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1978882800082850/5316923203';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}