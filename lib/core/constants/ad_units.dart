/// Dedicated Ad Units & Monetization Configuration
///
/// Use this dedicated file to manage all Ad Unit IDs (AdMob / AppLovin / Unity)
/// when ready for production release.
///
/// NOTE: Currently `adsEnabled` is set to `false`, so this file will NOT affect
/// or interrupt any existing code or user experience.
class AdUnits {
  /// Master toggle to enable/disable ads across the entire app
  static const bool adsEnabled = false;

  /// Enable test mode during development/testing to avoid AdMob policy violations
  static const bool isTestMode = true;

  // ===========================================================================
  // ANDROID ADMOB AD UNIT IDs
  // Replace the placeholder IDs below with your real AdMob Ad Unit IDs:
  // ===========================================================================

  /// Android AdMob Application ID (Defined in AndroidManifest.xml)
  static const String androidAppId = 'ca-app-pub-3940256099942544~3347511713';

  /// Android Banner Ad Unit ID (For non-chanting views like History/Settings footer)
  static const String androidBannerId = 'ca-app-pub-3940256099942544/6300978111';

  /// Android Interstitial Ad Unit ID (Optional, shown between major transitions)
  static const String androidInterstitialId = 'ca-app-pub-3940256099942544/1033173712';

  /// Android Rewarded Ad Unit ID (Optional, e.g. for unlocking special themes)
  static const String androidRewardedId = 'ca-app-pub-3940256099942544/5224354917';

  /// Android App Open Ad Unit ID (Optional, displayed during cold app starts)
  static const String androidAppOpenId = 'ca-app-pub-3940256099942544/9257395921';

  /// Android Native Ad Unit ID
  static const String androidNativeId = 'ca-app-pub-3940256099942544/2247696110';

  // ===========================================================================
  // IOS ADMOB AD UNIT IDs
  // Replace the placeholder IDs below with your real AdMob iOS IDs:
  // ===========================================================================

  /// iOS AdMob Application ID (Defined in Info.plist)
  static const String iosAppId = 'ca-app-pub-3940256099942544~1458602516';

  /// iOS Banner Ad Unit ID
  static const String iosBannerId = 'ca-app-pub-3940256099942544/2934735716';

  /// iOS Interstitial Ad Unit ID
  static const String iosInterstitialId = 'ca-app-pub-3940256099942544/4411468910';

  /// iOS Rewarded Ad Unit ID
  static const String iosRewardedId = 'ca-app-pub-3940256099942544/1712485313';

  /// iOS App Open Ad Unit ID
  static const String iosAppOpenId = 'ca-app-pub-3940256099942544/5575463023';

  /// iOS Native Ad Unit ID
  static const String iosNativeId = 'ca-app-pub-3940256099942544/3986624511';

  // ===========================================================================
  // PLACEMENT POLICIES (Preserves Peaceful Spiritual Experience)
  // ===========================================================================

  /// Strict rule: Never display ads during active Jaap chanting sessions
  static const bool allowAdsOnCounter = false;

  /// Allow banner ads on non-active views
  static const bool allowAdsOnHistory = true;
  static const bool allowAdsOnSettings = true;
}
