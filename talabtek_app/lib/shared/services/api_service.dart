import 'package:dio/dio.dart';
import 'package:talabtek_customer/core/config/app_config.dart';
import 'package:talabtek_customer/shared/models/restaurant_model.dart';
import 'package:talabtek_customer/shared/models/cart_model.dart';
import 'package:talabtek_customer/shared/models/user_model.dart';
import 'package:talabtek_customer/shared/models/order_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio;
  String? _authToken;

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectionTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Language': 'ar',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_authToken != null) {
          options.headers['Authorization'] = 'Bearer $_authToken';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        _handleError(error);
        handler.next(error);
      },
    ));

    // Add logger in debug mode
    if (AppConfig.enableLogging) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
      ));
    }
  }

  void setAuthToken(String? token) {
    _authToken = token;
  }

  void _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw Exception('انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى');
      case DioExceptionType.connectionError:
        throw Exception('لا يوجد اتصال بالإنترنت');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'حدث خطأ في الخادم';
        if (statusCode == 401) {
          throw Exception('جلسة منتهية، يرجى تسجيل الدخول مرة أخرى');
        } else if (statusCode == 403) {
          throw Exception('غير مصرح لك بالوصول');
        } else if (statusCode == 404) {
          throw Exception('المورد غير موجود');
        } else if (statusCode! >= 500) {
          throw Exception('خطأ في الخادم، يرجى المحاولة لاحقاً');
        }
        throw Exception(message);
      default:
        throw Exception('حدث خطأ غير متوقع: ${error.message}');
    }
  }

  // Restaurant APIs
  Future<List<RestaurantModel>> getRestaurants({
    String? categoryId,
    double? latitude,
    double? longitude,
    double? radiusKm,
    String? searchQuery,
    String sortBy = 'recommended',
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      'sort': sortBy,
    };

    if (categoryId != null) queryParams['category'] = categoryId;
    if (latitude != null && longitude != null) {
      queryParams['lat'] = latitude;
      queryParams['lng'] = longitude;
      if (radiusKm != null) queryParams['radius'] = radiusKm;
    }
    if (searchQuery != null && searchQuery.isNotEmpty) queryParams['q'] = searchQuery;

    final response = await _dio.get(AppConfig.restaurantsEndpoint, queryParameters: queryParams);
    final data = response.data['data'] as List;
    return data.map((json) => RestaurantModel.fromJson(json)).toList();
  }

  Future<RestaurantModel> getRestaurant(String id) async {
    final response = await _dio.get('${AppConfig.restaurantsEndpoint}/$id');
    return RestaurantModel.fromJson(response.data['data']);
  }

  Future<List<RestaurantModel>> searchRestaurants(String query, {int limit = 10}) async {
    final response = await _dio.get('/restaurant/search', queryParameters: {
      'q': query,
      'limit': limit,
    });
    final data = response.data['data'] as List;
    return data.map((json) => RestaurantModel.fromJson(json)).toList();
  }

  // Category APIs
  Future<List<CategoryModel>> getCategories() async {
    final response = await _dio.get('/category/list');
    final data = response.data['data'] as List;
    return data.map((json) => CategoryModel.fromJson(json)).toList();
  }

  // Product APIs
  Future<List<ProductModel>> getRestaurantProducts(String restaurantId, {String? categoryId}) async {
    final response = await _dio.get('/restaurant/$restaurantId/products', queryParameters: {
      if (categoryId != null) 'category': categoryId,
    });
    final data = response.data['data'] as List;
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<ProductModel> getProduct(String id) async {
    final response = await _dio.get('/product/$id');
    return ProductModel.fromJson(response.data['data']);
  }

  // Order APIs
  Future<OrderModel> createOrder({
    required String restaurantId,
    required List<CartItemModel> items,
    required DeliveryAddressModel deliveryAddress,
    required String paymentMethodId,
    String? restaurantNote,
    String? driverNote,
    String? couponCode,
  }) async {
    final response = await _dio.post('/order/create', data: {
      'restaurantId': restaurantId,
      'items': items.map((item) => item.toJson()).toList(),
      'deliveryAddress': deliveryAddress.toJson(),
      'paymentMethod': paymentMethodId,
      'restaurantNote': restaurantNote,
      'driverNote': driverNote,
      'couponCode': couponCode,
    });
    return OrderModel.fromJson(response.data['data']);
  }

  Future<List<OrderModel>> getOrders({int page = 1, int limit = 20}) async {
    final response = await _dio.get(AppConfig.ordersEndpoint, queryParameters: {
      'page': page,
      'limit': limit,
    });
    final data = response.data['data'] as List;
    return data.map((json) => OrderModel.fromJson(json)).toList();
  }

  Future<OrderModel> getOrder(String id) async {
    final response = await _dio.get('/order/$id');
    return OrderModel.fromJson(response.data['data']);
  }

  Future<OrderModel> trackOrder(String id) async {
    final response = await _dio.get('/order/$id/track');
    return OrderModel.fromJson(response.data['data']);
  }

  Future<void> cancelOrder(String id, String reason) async {
    await _dio.post('/order/$id/cancel', data: {'reason': reason});
  }

  Future<void> rateOrder(String id, int foodRating, int deliveryRating, String? comment) async {
    await _dio.post('/order/$id/rate', data: {
      'foodRating': foodRating,
      'deliveryRating': deliveryRating,
      'comment': comment,
    });
  }

  // Coupon APIs
  Future<CouponValidationResult> validateCoupon(String code, double subtotal) async {
    final response = await _dio.post('/coupon/validate', data: {
      'code': code,
      'subtotal': subtotal,
    });
    return CouponValidationResult.fromJson(response.data['data']);
  }

  // Address APIs
  Future<List<DeliveryAddressModel>> getAddresses() async {
    final response = await _dio.get('/address/list');
    final data = response.data['data'] as List;
    return data.map((json) => DeliveryAddressModel.fromJson(json)).toList();
  }

  Future<DeliveryAddressModel> addAddress(DeliveryAddressModel address) async {
    final response = await _dio.post('/address/create', data: address.toJson());
    return DeliveryAddressModel.fromJson(response.data['data']);
  }

  Future<DeliveryAddressModel> updateAddress(String id, DeliveryAddressModel address) async {
    final response = await _dio.put('/address/$id', data: address.toJson());
    return DeliveryAddressModel.fromJson(response.data['data']);
  }

  Future<void> deleteAddress(String id) async {
    await _dio.delete('/address/$id');
  }

  // Payment APIs
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    final response = await _dio.get('/payment/methods');
    final data = response.data['data'] as List;
    return data.map((json) => PaymentMethodModel.fromJson(json)).toList();
  }

  Future<PaymentMethodModel> addPaymentMethod(PaymentMethodModel method) async {
    final response = await _dio.post('/payment/method', data: method.toJson());
    return PaymentMethodModel.fromJson(response.data['data']);
  }

  Future<void> deletePaymentMethod(String id) async {
    await _dio.delete('/payment/method/$id');
  }

  // Wallet APIs
  Future<WalletModel> getWallet() async {
    final response = await _dio.get('/wallet');
    return WalletModel.fromJson(response.data['data']);
  }

  Future<WalletTopUpResult> topUpWallet(double amount, String paymentMethodId) async {
    final response = await _dio.post('/wallet/topup', data: {
      'amount': amount,
      'paymentMethodId': paymentMethodId,
    });
    return WalletTopUpResult.fromJson(response.data['data']);
  }

  // Notification APIs
  Future<void> registerDeviceToken(String token) async {
    await _dio.post('/notification/device-token', data: {'token': token});
  }

  Future<void> updateNotificationPreferences(Map<String, bool> prefs) async {
    await _dio.put('/notification/preferences', data: prefs);
  }

  // Support APIs
  Future<ChatSessionModel> createChatSession(String subject) async {
    final response = await _dio.post('/support/chat', data: {'subject': subject});
    return ChatSessionModel.fromJson(response.data['data']);
  }

  Future<List<ChatMessageModel>> getChatMessages(String chatId) async {
    final response = await _dio.get('/support/chat/$chatId/messages');
    final data = response.data['data'] as List;
    return data.map((json) => ChatMessageModel.fromJson(json)).toList();
  }

  Future<void> sendChatMessage(String chatId, String message) async {
    await _dio.post('/support/chat/$chatId/message', data: {'message': message});
  }

  // Search APIs
  Future<SearchResultModel> search({
    required String query,
    String? categoryId,
    double? latitude,
    double? longitude,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get('/search', queryParameters: {
      'q': query,
      'page': page,
      'limit': limit,
      if (categoryId != null) 'category': categoryId,
      if (latitude != null) 'lat': latitude,
      if (longitude != null) 'lng': longitude,
    });
    return SearchResultModel.fromJson(response.data['data']);
  }

  // Location APIs
  Future<List<AreaModel>> getAreas() async {
    final response = await _dio.get('/location/areas');
    final data = response.data['data'] as List;
    return data.map((json) => AreaModel.fromJson(json)).toList();
  }

  Future<List<CityModel>> getCities() async {
    final response = await _dio.get('/location/cities');
    final data = response.data['data'] as List;
    return data.map((json) => CityModel.fromJson(json)).toList();
  }
}

// Response Models
class CouponValidationResult {
  final bool isValid;
  final double discountAmount;
  final String? message;
  final DateTime? expiresAt;

  CouponValidationResult({
    required this.isValid,
    required this.discountAmount,
    this.message,
    this.expiresAt,
  });

  factory CouponValidationResult.fromJson(Map<String, dynamic> json) => CouponValidationResult(
    isValid: json['isValid'] ?? false,
    discountAmount: (json['discountAmount'] ?? 0).toDouble(),
    message: json['message'],
    expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
  );
}

class WalletTopUpResult {
  final bool success;
  final String transactionId;
  final double newBalance;
  final String? paymentUrl;

  WalletTopUpResult({
    required this.success,
    required this.transactionId,
    required this.newBalance,
    this.paymentUrl,
  });

  factory WalletTopUpResult.fromJson(Map<String, dynamic> json) => WalletTopUpResult(
    success: json['success'] ?? false,
    transactionId: json['transactionId'] ?? '',
    newBalance: (json['newBalance'] ?? 0).toDouble(),
    paymentUrl: json['paymentUrl'],
  );
}

class ChatSessionModel {
  final String id;
  final String subject;
  final String status;
  final DateTime createdAt;

  ChatSessionModel({
    required this.id,
    required this.subject,
    required this.status,
    required this.createdAt,
  });

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) => ChatSessionModel(
    id: json['id'] ?? '',
    subject: json['subject'] ?? '',
    status: json['status'] ?? 'open',
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class ChatMessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String senderType; // user, agent, system
  final String message;
  final String? attachmentUrl;
  final DateTime createdAt;

  ChatMessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderType,
    required this.message,
    this.attachmentUrl,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => ChatMessageModel(
    id: json['id'] ?? '',
    chatId: json['chatId'] ?? '',
    senderId: json['senderId'] ?? '',
    senderType: json['senderType'] ?? 'user',
    message: json['message'] ?? '',
    attachmentUrl: json['attachmentUrl'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class SearchResultModel {
  final List<RestaurantModel> restaurants;
  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final int totalResults;
  final int currentPage;
  final int totalPages;

  SearchResultModel({
    required this.restaurants,
    required this.products,
    required this.categories,
    required this.totalResults,
    required this.currentPage,
    required this.totalPages,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) => SearchResultModel(
    restaurants: (json['restaurants'] as List? ?? [])
        .map((e) => RestaurantModel.fromJson(e))
        .toList(),
    products: (json['products'] as List? ?? [])
        .map((e) => ProductModel.fromJson(e))
        .toList(),
    categories: (json['categories'] as List? ?? [])
        .map((e) => CategoryModel.fromJson(e))
        .toList(),
    totalResults: json['totalResults'] ?? 0,
    currentPage: json['currentPage'] ?? 1,
    totalPages: json['totalPages'] ?? 1,
  );
}

class AreaModel {
  final String id;
  final String name;
  final String cityId;
  final double latitude;
  final double longitude;

  AreaModel({
    required this.id,
    required this.name,
    required this.cityId,
    required this.latitude,
    required this.longitude,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    cityId: json['cityId'] ?? '',
    latitude: (json['latitude'] ?? 0).toDouble(),
    longitude: (json['longitude'] ?? 0).toDouble(),
  );
}

class CityModel {
  final String id;
  final String name;
  final String nameEn;
  final bool isActive;

  CityModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.isActive,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    nameEn: json['nameEn'] ?? '',
    isActive: json['isActive'] ?? true,
  );
}