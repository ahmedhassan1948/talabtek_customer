import 'package:dio/dio.dart';
import 'package:talabtek_customer/core/config/app_config.dart';
import 'package:talabtek_customer/shared/models/restaurant_model.dart';
import 'package:talabtek_customer/shared/models/order_model.dart';

class AdminApiService {
  static final AdminApiService _instance = AdminApiService._internal();
  factory AdminApiService() => _instance;
  AdminApiService._internal();

  late final Dio _dio;

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.adminBaseUrl,
      connectTimeout: AppConfig.connectionTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Language': 'ar',
      },
    ));

    // Add interceptor for admin API
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add any admin-specific headers if needed
        // options.headers['X-Admin-Key'] = 'your-admin-key';
        handler.next(options);
      },
      onError: (error, handler) {
        _handleError(error);
        handler.next(error);
      },
    ));
  }

  void _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw Exception('انتهت مهلة الاتصال مع لوحة الإدارة');
      case DioExceptionType.connectionError:
        throw Exception('لا يوجد اتصال بالإنترنت');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'حدث خطأ في لوحة الإدارة';
        if (statusCode == 401) {
          throw Exception('غير مصرح، يرجى تسجيل الدخول للوحة الإدارة');
        } else if (statusCode == 403) {
          throw Exception('غير مصرح لك بالوصول لهذه البيانات');
        } else if (statusCode == 404) {
          throw Exception('البيانات غير موجودة');
        } else if (statusCode! >= 500) {
          throw Exception('خطأ في الخادم، يرجى المحاولة لاحقاً');
        }
        throw Exception(message);
      default:
        throw Exception('حدث خطأ غير متوقع: ${error.message}');
    }
  }

  // Fetch all orders from admin panel
  Future<AdminOrdersResponse> getAllOrders({
    int page = 1,
    int limit = 50,
    String? status,
    String? restaurantId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    if (status != null) queryParams['status'] = status;
    if (restaurantId != null) queryParams['restaurantId'] = restaurantId;
    if (fromDate != null) queryParams['fromDate'] = fromDate.toIso8601String();
    if (toDate != null) queryParams['toDate'] = toDate.toIso8601String();

    final response = await _dio.get(AppConfig.ordersEndpoint, queryParameters: queryParams);
    return AdminOrdersResponse.fromJson(response.data);
  }

  // Fetch all restaurants from admin panel
  Future<AdminRestaurantsResponse> getAllRestaurants({
    int page = 1,
    int limit = 50,
    bool? isActive,
    bool? isOpen,
    String? categoryId,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    if (isActive != null) queryParams['isActive'] = isActive;
    if (isOpen != null) queryParams['isOpen'] = isOpen;
    if (categoryId != null) queryParams['categoryId'] = categoryId;

    final response = await _dio.get(AppConfig.restaurantsEndpoint, queryParameters: queryParams);
    return AdminRestaurantsResponse.fromJson(response.data);
  }

  // Get single restaurant details
  Future<RestaurantModel> getRestaurantDetails(String id) async {
    final response = await _dio.get('${AppConfig.restaurantsEndpoint}/$id');
    return RestaurantModel.fromJson(response.data['data']);
  }

  // Get order details
  Future<OrderModel> getOrderDetails(String id) async {
    final response = await _dio.get('${AppConfig.ordersEndpoint}/$id');
    return OrderModel.fromJson(response.data['data']);
  }

  // Update order status (for driver/restaurant apps)
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _dio.patch('${AppConfig.ordersEndpoint}/$orderId/status', data: {
      'status': status,
    });
  }

  // Get restaurant products/menu
  Future<List<ProductModel>> getRestaurantProducts(String restaurantId, {String? categoryId}) async {
    final queryParams = <String, dynamic>{};
    if (categoryId != null) queryParams['categoryId'] = categoryId;
    
    final response = await _dio.get('$AppConfig.restaurantsEndpoint/$restaurantId/products', queryParameters: queryParams);
    final data = response.data['data'] as List;
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  // Get categories
  Future<List<CategoryModel>> getCategories() async {
    final response = await _dio.get('/category/list');
    final data = response.data['data'] as List;
    return data.map((json) => CategoryModel.fromJson(json)).toList();
  }

  // Get driver location for order
  Future<DriverLocationModel> getDriverLocation(String orderId) async {
    final response = await _dio.get('${AppConfig.ordersEndpoint}/$orderId/driver-location');
    return DriverLocationModel.fromJson(response.data['data']);
  }

  // Sync data with admin panel (for offline-first approach)
  Future<SyncResult> syncData({
    DateTime? lastSyncTime,
  }) async {
    final queryParams = <String, dynamic>{};
    if (lastSyncTime != null) {
      queryParams['since'] = lastSyncTime.toIso8601String();
    }

    final response = await _dio.get('/sync', queryParameters: queryParams);
    return SyncResult.fromJson(response.data['data']);
  }
}

// Response Models
class AdminOrdersResponse {
  final List<OrderModel> orders;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  AdminOrdersResponse({
    required this.orders,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory AdminOrdersResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final ordersData = data['orders'] ?? data['data'] ?? [];
    return AdminOrdersResponse(
      orders: (ordersData as List)
          .map((e) => OrderModel.fromJson(e))
          .toList(),
      total: data['total'] ?? 0,
      page: data['page'] ?? 1,
      limit: data['limit'] ?? 50,
      totalPages: data['totalPages'] ?? 1,
    );
  }
}

class AdminRestaurantsResponse {
  final List<RestaurantModel> restaurants;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  AdminRestaurantsResponse({
    required this.restaurants,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory AdminRestaurantsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final restaurantsData = data['restaurants'] ?? data['data'] ?? [];
    return AdminRestaurantsResponse(
      restaurants: (restaurantsData as List)
          .map((e) => RestaurantModel.fromJson(e))
          .toList(),
      total: data['total'] ?? 0,
      page: data['page'] ?? 1,
      limit: data['limit'] ?? 50,
      totalPages: data['totalPages'] ?? 1,
    );
  }
}

class DriverLocationModel {
  final String driverId;
  final String driverName;
  final double latitude;
  final double longitude;
  final double bearing;
  final double speed; // km/h
  final DateTime updatedAt;
  final String? vehicleType;
  final String? vehiclePlate;

  DriverLocationModel({
    required this.driverId,
    required this.driverName,
    required this.latitude,
    required this.longitude,
    required this.bearing,
    required this.speed,
    required this.updatedAt,
    this.vehicleType,
    this.vehiclePlate,
  });

  factory DriverLocationModel.fromJson(Map<String, dynamic> json) => DriverLocationModel(
    driverId: json['driverId'] ?? '',
    driverName: json['driverName'] ?? '',
    latitude: (json['latitude'] ?? 0).toDouble(),
    longitude: (json['longitude'] ?? 0).toDouble(),
    bearing: (json['bearing'] ?? 0).toDouble(),
    speed: (json['speed'] ?? 0).toDouble(),
    updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    vehicleType: json['vehicleType'],
    vehiclePlate: json['vehiclePlate'],
  );
}

class SyncResult {
  final List<RestaurantModel> updatedRestaurants;
  final List<RestaurantModel> newRestaurants;
  final List<String> deletedRestaurantIds;
  final List<CategoryModel> updatedCategories;
  final List<ProductModel> updatedProducts;
  final DateTime serverTime;

  SyncResult({
    required this.updatedRestaurants,
    required this.newRestaurants,
    required this.deletedRestaurantIds,
    required this.updatedCategories,
    required this.updatedProducts,
    required this.serverTime,
  });

  factory SyncResult.fromJson(Map<String, dynamic> json) {
    return SyncResult(
      updatedRestaurants: (json['updatedRestaurants'] as List? ?? [])
          .map((e) => RestaurantModel.fromJson(e))
          .toList(),
      newRestaurants: (json['newRestaurants'] as List? ?? [])
          .map((e) => RestaurantModel.fromJson(e))
          .toList(),
      deletedRestaurantIds: List<String>.from(json['deletedRestaurantIds'] ?? []),
      updatedCategories: (json['updatedCategories'] as List? ?? [])
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
      updatedProducts: (json['updatedProducts'] as List? ?? [])
          .map((e) => ProductModel.fromJson(e))
          .toList(),
      serverTime: DateTime.tryParse(json['serverTime'] ?? '') ?? DateTime.now(),
    );
  }
}