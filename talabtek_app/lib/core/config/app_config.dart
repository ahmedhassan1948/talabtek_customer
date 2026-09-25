import 'package:flutter/foundation.dart';

class AppConfig {
  static const String appName = 'طلبك';
  static const String appNameEn = 'Talabtek';
  static const String version = '1.0.0';
  static const String buildNumber = '1';
  
  // API Configuration
  static const String baseUrl = 'https://talabtek.com/api';
  static const String adminBaseUrl = 'https://talabtek.com/admin';
  static const String ordersEndpoint = '/order/list/all';
  static const String restaurantsEndpoint = '/restaurant/list';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String restaurantsCollection = 'restaurants';
  static const String categoriesCollection = 'categories';
  static const String productsCollection = 'products';
  static const String ordersCollection = 'orders';
  static const String driversCollection = 'drivers';
  static const String notificationsCollection = 'notifications';
  static const String chatsCollection = 'chats';
  static const String reviewsCollection = 'reviews';
  static const String addressesCollection = 'addresses';
  static const String paymentsCollection = 'payments';
  static const String couponsCollection = 'coupons';
  static const String walletTransactionsCollection = 'wallet_transactions';
  
  // Map Configuration
  static const double defaultMapZoom = 15.0;
  static const double minMapZoom = 10.0;
  static const double maxMapZoom = 20.0;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
  
  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  
  // OTP
  static const int otpLength = 6;
  static const Duration otpTimeout = Duration(minutes: 2);
  static const Duration otpResendDelay = Duration(seconds: 60);
  
  // Delivery
  static const double defaultDeliveryFee = 5.0;
  static const double freeDeliveryThreshold = 50.0;
  static const int maxDeliveryDistanceKm = 25;
  
  // App Settings
  static const bool enableGuestMode = true;
  static const bool enableWallet = true;
  static const bool enableLoyaltyPoints = true;
  static const int loyaltyPointsPerSar = 1;
  
  // Feature Flags
  static const bool enableFlashSales = true;
  static const bool enableScheduledOrders = true;
  static const bool enableGroupOrders = false;
  static const bool enableSubscription = false;
  
  // Debug
  static const bool enableLogging = kDebugMode;
  static const bool enablePerformanceMonitoring = kReleaseMode;
  static const bool enableCrashReporting = kReleaseMode;
}