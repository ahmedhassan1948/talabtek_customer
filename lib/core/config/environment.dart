import 'package:flutter/foundation.dart';

class Environment {
  static const String _defaultBaseUrl = 'https://talabtek.com/api';
  static const String _defaultAdminBaseUrl = 'https://talabtek.com/admin';

  // Firebase
  static String get firebaseAndroidApiKey => const String.fromEnvironment('FIREBASE_ANDROID_API_KEY', defaultValue: '');
  static String get firebaseAndroidAppId => const String.fromEnvironment('FIREBASE_ANDROID_APP_ID', defaultValue: '');
  static String get firebaseIosApiKey => const String.fromEnvironment('FIREBASE_IOS_API_KEY', defaultValue: '');
  static String get firebaseIosAppId => const String.fromEnvironment('FIREBASE_IOS_APP_ID', defaultValue: '');
  static String get firebaseProjectId => const String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: '');
  static String get firebaseSenderId => const String.fromEnvironment('FIREBASE_SENDER_ID', defaultValue: '');

  // Google Maps
  static String get googleMapsApiKey => const String.fromEnvironment('GOOGLE_MAPS_API_KEY', defaultValue: 'AIzaSyDEWmI4Gi9sxaf2o1GsM_m0xmXB9T93Yc8');

  // Admin API
  static String get adminApiBaseUrl => const String.fromEnvironment('ADMIN_API_BASE_URL', defaultValue: _defaultAdminBaseUrl);
  static String get adminApiKey => const String.fromEnvironment('ADMIN_API_KEY', defaultValue: '');

  // App Config
  static String get appName => const String.fromEnvironment('APP_NAME', defaultValue: 'طلبك');
  static String get appVersion => const String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0');
  static String get appBuildNumber => const String.fromEnvironment('APP_BUILD_NUMBER', defaultValue: '1');
  static String get defaultLanguage => const String.fromEnvironment('DEFAULT_LANGUAGE', defaultValue: 'ar');
  static String get defaultCountry => const String.fromEnvironment('DEFAULT_COUNTRY', defaultValue: 'SA');
  static String get currency => const String.fromEnvironment('CURRENCY', defaultValue: 'SAR');

  // Feature Flags
  static bool get enableGuestMode => const bool.fromEnvironment('ENABLE_GUEST_MODE', defaultValue: true);
  static bool get enableWallet => const bool.fromEnvironment('ENABLE_WALLET', defaultValue: true);
  static bool get enableLoyalty => const bool.fromEnvironment('ENABLE_LOYALTY', defaultValue: true);
  static bool get enableFlashSales => const bool.fromEnvironment('ENABLE_FLASH_SALES', defaultValue: true);
  static bool get enableScheduledOrders => const bool.fromEnvironment('ENABLE_SCHEDULED_ORDERS', defaultValue: true);

  // Delivery
  static double get defaultDeliveryFee => double.tryParse(const String.fromEnvironment('DEFAULT_DELIVERY_FEE', defaultValue: '5.0')) ?? 5.0;
  static double get freeDeliveryThreshold => double.tryParse(const String.fromEnvironment('FREE_DELIVERY_THRESHOLD', defaultValue: '50.0')) ?? 50.0;
  static int get maxDeliveryDistanceKm => int.tryParse(const String.fromEnvironment('MAX_DELIVERY_DISTANCE_KM', defaultValue: '25')) ?? 25;

  // OTP
  static int get otpLength => int.tryParse(const String.fromEnvironment('OTP_LENGTH', defaultValue: '6')) ?? 6;
  static int get otpTimeoutMinutes => int.tryParse(const String.fromEnvironment('OTP_TIMEOUT_MINUTES', defaultValue: '2')) ?? 2;
  static int get otpResendDelaySeconds => int.tryParse(const String.fromEnvironment('OTP_RESEND_DELAY_SECONDS', defaultValue: '60')) ?? 60;

  // Cache
  static int get cacheExpirationHours => int.tryParse(const String.fromEnvironment('CACHE_EXPIRATION_HOURS', defaultValue: '24')) ?? 24;
  static int get maxCacheSizeMb => int.tryParse(const String.fromEnvironment('MAX_CACHE_SIZE_MB', defaultValue: '100')) ?? 100;

  // Payment
  static String get madaMerchantId => const String.fromEnvironment('MADA_MERCHANT_ID', defaultValue: '');
  static String get stripePublishableKey => const String.fromEnvironment('STRIPE_PUBLISHABLE_KEY', defaultValue: '');
  static String get applePayMerchantId => const String.fromEnvironment('APPLE_PAY_MERCHANT_ID', defaultValue: '');

  // Social
  static String get googleClientId => const String.fromEnvironment('GOOGLE_CLIENT_ID', defaultValue: '');
  static String get appleTeamId => const String.fromEnvironment('APPLE_TEAM_ID', defaultValue: '');
  static String get appleKeyId => const String.fromEnvironment('APPLE_KEY_ID', defaultValue: '');
  static String get applePrivateKey => const String.fromEnvironment('APPLE_PRIVATE_KEY', defaultValue: '');

  // Analytics
  static bool get firebaseAnalyticsEnabled => const bool.fromEnvironment('FIREBASE_ANALYTICS_ENABLED', defaultValue: true);
  static bool get crashlyticsEnabled => const bool.fromEnvironment('CRASHLYTICS_ENABLED', defaultValue: true);

  // API Base URLs
  static String get apiBaseUrl => const String.fromEnvironment('API_BASE_URL', defaultValue: _defaultBaseUrl);

  // Validation
  static bool get isFirebaseConfigured => firebaseProjectId.isNotEmpty && firebaseProjectId != 'YOUR_PROJECT_ID';
  static bool get isGoogleMapsConfigured => googleMapsApiKey.isNotEmpty && googleMapsApiKey != 'YOUR_GOOGLE_MAPS_API_KEY';
  static bool get isAdminApiConfigured => adminApiKey.isNotEmpty;

  static void validateConfiguration() {
    final errors = <String>[];
    
    if (!isFirebaseConfigured) {
      errors.add('Firebase غير مُعد: تأكد من FIREBASE_PROJECT_ID');
    }
    
    if (!isGoogleMapsConfigured) {
      errors.add('Google Maps غير مُعد: تأكد من GOOGLE_MAPS_API_KEY');
    }
    
    if (!isAdminApiConfigured) {
      errors.add('Admin API غير مُعد: تأكد من ADMIN_API_KEY');
    }

    if (errors.isNotEmpty && kDebugMode) {
      print('⚠️ تحذيرات التكوين:');
      for (final error in errors) {
        print('  - $error');
      }
    }
  }
}