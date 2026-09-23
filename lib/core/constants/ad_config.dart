/// Dedicated Ads Configuration File
///
/// When you are ready to integrate Google Mobile Ads or another ad network,
/// you only need to configure your App IDs and Ad Unit IDs in this single file.
class AdConfig {
  /// Toggle to enable or disable all ads globally across the app
  static const bool adsEnabled = false;

  /// Test Mode flag (set to true during development to prevent policy violations)
  static const bool isTestMode = true;

  // ==========================================
  // Android Ad Unit IDs
  // Replace these with your real AdMob Ad Unit IDs when ready for production
  // ==========================================
  static const String androidAppId = 'ca-app-pub-3940256099942544~3347511713'; // Test App ID
  static const String androidBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111'; // Test Banner
  static const String androidInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712'; // Test Interstitial
  static const String androidRewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917'; // Test Rewarded

  // ==========================================
  // iOS Ad Unit IDs
  // Replace these with your real AdMob Ad Unit IDs for iOS
  // ==========================================
  static const String iosAppId = 'ca-app-pub-3940256099942544~1458602516'; // Test App ID
  static const String iosBannerAdUnitId = 'ca-app-pub-3940256099942544/2934735716'; // Test Banner
  static const String iosInterstitialAdUnitId = 'ca-app-pub-3940256099942544/4411468910'; // Test Interstitial
  static const String iosRewardedAdUnitId = 'ca-app-pub-3940256099942544/1712485313'; // Test Rewarded

  // Peaceful Experience Policy: Never show ads during active Jaap chanting sessions.
  static const bool allowAdsOnCounterScreen = false;
  static const bool allowAdsOnHistoryScreen = true;
  static const bool allowAdsOnSettingsScreen = true;
}
