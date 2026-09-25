import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'طلبك';
  static const String appNameEn = 'Talabtek';
  
  // Locales
  static const Locale defaultLocale = Locale('ar', 'SA');
  static const List<Locale> supportedLocales = [
    Locale('ar', 'SA'),
    Locale('en', 'US'),
  ];
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'current_user';
  static const String guestModeKey = 'guest_mode';
  static const String languageKey = 'app_language';
  static const String themeKey = 'app_theme';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String fcmTokenKey = 'fcm_token';
  static const String lastLocationKey = 'last_location';
  static const String favoriteAddressesKey = 'favorite_addresses';
  static const String savedPaymentMethodsKey = 'saved_payment_methods';
  static const String walletBalanceKey = 'wallet_balance';
  static const String loyaltyPointsKey = 'loyalty_points';
  
  // Routes
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String authRoute = '/auth';
  static const String loginRoute = '/auth/login';
  static const String registerRoute = '/auth/register';
  static const String otpRoute = '/auth/otp';
  static const String forgotPasswordRoute = '/auth/forgot-password';
  static const String homeRoute = '/home';
  static const String restaurantRoute = '/restaurant/:id';
  static const String productDetailRoute = '/product/:id';
  static const String cartRoute = '/cart';
  static const String checkoutRoute = '/checkout';
  static const String paymentRoute = '/payment';
  static const String orderTrackingRoute = '/order/tracking/:id';
  static const String orderHistoryRoute = '/orders';
  static const String orderDetailRoute = '/order/:id';
  static const String profileRoute = '/profile';
  static const String addressesRoute = '/profile/addresses';
  static const String addAddressRoute = '/profile/addresses/add';
  static const String editAddressRoute = '/profile/addresses/edit/:id';
  static const String paymentMethodsRoute = '/profile/payment-methods';
  static const String walletRoute = '/profile/wallet';
  static const String notificationsRoute = '/notifications';
  static const String supportRoute = '/support';
  static const String chatRoute = '/support/chat/:id';
  static const String settingsRoute = '/settings';
  static const String favoritesRoute = '/favorites';
  static const String searchRoute = '/search';
  static const String categoryRoute = '/category/:id';
  
  // Regex Patterns
  static final RegExp phoneRegex = RegExp(r'^(\+966|0)?5\d{8}$');
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
  
  // Validation Messages
  static const String requiredField = 'هذا الحقل مطلوب';
  static const String invalidPhone = 'رقم الهاتف غير صحيح';
  static const String invalidEmail = 'البريد الإلكتروني غير صحيح';
  static const String weakPassword = 'كلمة المرور يجب أن تكون 8 أحرف على الأقل وتحتوي على حروف وأرقام';
  static const String passwordsNotMatch = 'كلمات المرور غير متطابقة';
  
  // Categories
  static const List<Map<String, dynamic>> mainCategories = [
    {'id': 'restaurants', 'name': 'مطاعم', 'icon': 'restaurant', 'color': 0xFFFF6B35},
    {'id': 'supermarkets', 'name': 'سوبرماركت', 'icon': 'shopping_cart', 'color': 0xFF4CAF50},
    {'id': 'pharmacies', 'name': 'صيدليات', 'icon': 'local_pharmacy', 'color': 0xFF2196F3},
    {'id': 'medical', 'name': 'مستلزمات طبية', 'icon': 'healing', 'color': 0xFF9C27B0},
    {'id': 'parcels', 'name': 'توصيل طرود', 'icon': 'local_shipping', 'color': 0xFF795548},
  ];
  
  // Order Status
  static const List<String> orderStatuses = [
    'pending',
    'confirmed',
    'preparing',
    'ready',
    'picked_up',
    'delivering',
    'delivered',
    'cancelled',
  ];
  
  static const Map<String, String> orderStatusLabels = {
    'pending': 'في الانتظار',
    'confirmed': 'تم التأكيد',
    'preparing': 'جاري التحضير',
    'ready': 'جاهز للاستلام',
    'picked_up': 'تم استلام الطلب',
    'delivering': 'في الطريق إليك',
    'delivered': 'تم التوصيل',
    'cancelled': 'ملغي',
  };
  
  // Payment Methods
  static const List<Map<String, dynamic>> paymentMethods = [
    {'id': 'cash', 'name': 'نقداً عند الاستلام', 'icon': 'payments', 'enabled': true},
    {'id': 'mada', 'name': 'مدى', 'icon': 'credit_card', 'enabled': true},
    {'id': 'visa', 'name': 'Visa / Mastercard', 'icon': 'credit_card', 'enabled': true},
    {'id': 'apple_pay', 'name': 'Apple Pay', 'icon': 'apple', 'enabled': true},
    {'id': 'google_pay', 'name': 'Google Pay', 'icon': 'android', 'enabled': true},
    {'id': 'wallet', 'name': 'المحفظة الإلكترونية', 'icon': 'account_balance_wallet', 'enabled': true},
  ];
  
  // Notification Types
  static const List<String> notificationTypes = [
    'order_update',
    'promotion',
    'flash_sale',
    'new_restaurant',
    'review_reminder',
    'delivery_assigned',
    'driver_arrived',
    'order_delivered',
    'order_cancelled',
    'payment_failed',
    'refund_processed',
  ];
  
  // Support
  static const String supportPhone = '920000000';
  static const String supportEmail = 'support@talabtek.com';
  static const String supportWhatsApp = '+966500000000';
  static const String privacyPolicyUrl = 'https://talabtek.com/privacy';
  static const String termsOfServiceUrl = 'https://talabtek.com/terms';
  static const String faqUrl = 'https://talabtek.com/faq';
  
  // Social Links
  static const String twitterUrl = 'https://twitter.com/talabtek';
  static const String instagramUrl = 'https://instagram.com/talabtek';
  static const String snapchatUrl = 'https://snapchat.com/add/talabtek';
  static const String youtubeUrl = 'https://youtube.com/talabtek';
}