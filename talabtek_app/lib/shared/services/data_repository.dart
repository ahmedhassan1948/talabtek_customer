import 'package:talabtek_customer/shared/services/api_service.dart';
import 'package:talabtek_customer/shared/services/admin_api_service.dart';
import 'package:talabtek_customer/shared/models/restaurant_model.dart';
import 'package:talabtek_customer/shared/models/order_model.dart';
import 'package:talabtek_customer/shared/models/cart_model.dart';
import 'package:talabtek_customer/shared/models/user_model.dart';
import 'package:talabtek_customer/core/config/app_config.dart';

class DataRepository {
  static final DataRepository _instance = DataRepository._internal();
  factory DataRepository() => _instance;
  DataRepository._internal();

  final ApiService _apiService = ApiService();
  final AdminApiService _adminApiService = AdminApiService();

  bool _useAdminApi = false;
  DateTime? _lastSyncTime;

  void initialize({bool useAdminApi = false}) {
    _useAdminApi = useAdminApi;
    _apiService.initialize();
    _adminApiService.initialize();
  }

  void setUseAdminApi(bool use) {
    _useAdminApi = use;
  }

  void setAuthToken(String? token) {
    _apiService.setAuthToken(token);
  }

  // Restaurant Methods
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
    if (_useAdminApi) {
      final response = await _adminApiService.getAllRestaurants(
        page: page,
        limit: limit,
        isOpen: true,
        categoryId: categoryId,
      );
      return response.restaurants;
    }
    return _apiService.getRestaurants(
      categoryId: categoryId,
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
      searchQuery: searchQuery,
      sortBy: sortBy,
      page: page,
      limit: limit,
    );
  }

  Future<RestaurantModel> getRestaurant(String id) async {
    if (_useAdminApi) {
      return _adminApiService.getRestaurantDetails(id);
    }
    return _apiService.getRestaurant(id);
  }

  Future<List<RestaurantModel>> searchRestaurants(String query, {int limit = 10}) async {
    if (_useAdminApi) {
      // Admin API doesn't have search, fallback to regular API
      return _apiService.searchRestaurants(query, limit: limit);
    }
    return _apiService.searchRestaurants(query, limit: limit);
  }

  Future<List<RestaurantModel>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
    int limit = 20,
  }) async {
    return getRestaurants(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
      limit: limit,
    );
  }

  // Category Methods
  Future<List<CategoryModel>> getCategories() async {
    if (_useAdminApi) {
      return _adminApiService.getCategories();
    }
    return _apiService.getCategories();
  }

  // Product Methods
  Future<List<ProductModel>> getRestaurantProducts(String restaurantId, {String? categoryId}) async {
    if (_useAdminApi) {
      return _adminApiService.getRestaurantProducts(restaurantId, categoryId: categoryId);
    }
    return _apiService.getRestaurantProducts(restaurantId, categoryId: categoryId);
  }

  Future<ProductModel> getProduct(String id) async {
    return _apiService.getProduct(id);
  }

  // Order Methods
  Future<OrderModel> createOrder({
    required String restaurantId,
    required List<CartItemModel> items,
    required DeliveryAddressModel deliveryAddress,
    required String paymentMethodId,
    String? restaurantNote,
    String? driverNote,
    String? couponCode,
  }) async {
    return _apiService.createOrder(
      restaurantId: restaurantId,
      items: items,
      deliveryAddress: deliveryAddress,
      paymentMethodId: paymentMethodId,
      restaurantNote: restaurantNote,
      driverNote: driverNote,
      couponCode: couponCode,
    );
  }

  Future<List<OrderModel>> getOrders({int page = 1, int limit = 20}) async {
    if (_useAdminApi) {
      final response = await _adminApiService.getAllOrders(page: page, limit: limit);
      return response.orders;
    }
    return _apiService.getOrders(page: page, limit: limit);
  }

  Future<OrderModel> getOrder(String id) async {
    if (_useAdminApi) {
      return _adminApiService.getOrderDetails(id);
    }
    return _apiService.getOrder(id);
  }

  Future<OrderModel> trackOrder(String id) async {
    return _apiService.trackOrder(id);
  }

  Future<void> cancelOrder(String id, String reason) async {
    return _apiService.cancelOrder(id, reason);
  }

  Future<void> rateOrder(String id, int foodRating, int deliveryRating, String? comment) async {
    return _apiService.rateOrder(id, foodRating, deliveryRating, comment);
  }

  // Coupon Methods
  Future<CouponValidationResult> validateCoupon(String code, double subtotal) async {
    return _apiService.validateCoupon(code, subtotal);
  }

  // Address Methods
  Future<List<DeliveryAddressModel>> getAddresses() async {
    return _apiService.getAddresses();
  }

  Future<DeliveryAddressModel> addAddress(DeliveryAddressModel address) async {
    return _apiService.addAddress(address);
  }

  Future<DeliveryAddressModel> updateAddress(String id, DeliveryAddressModel address) async {
    return _apiService.updateAddress(id, address);
  }

  Future<void> deleteAddress(String id) async {
    return _apiService.deleteAddress(id);
  }

  // Payment Methods
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    return _apiService.getPaymentMethods();
  }

  Future<PaymentMethodModel> addPaymentMethod(PaymentMethodModel method) async {
    return _apiService.addPaymentMethod(method);
  }

  Future<void> deletePaymentMethod(String id) async {
    return _apiService.deletePaymentMethod(id);
  }

  // Wallet Methods
  Future<WalletModel> getWallet() async {
    return _apiService.getWallet();
  }

  Future<WalletTopUpResult> topUpWallet(double amount, String paymentMethodId) async {
    return _apiService.topUpWallet(amount, paymentMethodId);
  }

  // Notification Methods
  Future<void> registerDeviceToken(String token) async {
    return _apiService.registerDeviceToken(token);
  }

  Future<void> updateNotificationPreferences(Map<String, bool> prefs) async {
    return _apiService.updateNotificationPreferences(prefs);
  }

  // Support Methods
  Future<ChatSessionModel> createChatSession(String subject) async {
    return _apiService.createChatSession(subject);
  }

  Future<List<ChatMessageModel>> getChatMessages(String chatId) async {
    return _apiService.getChatMessages(chatId);
  }

  Future<void> sendChatMessage(String chatId, String message) async {
    return _apiService.sendChatMessage(chatId, message);
  }

  // Search Methods
  Future<SearchResultModel> search({
    required String query,
    String? categoryId,
    double? latitude,
    double? longitude,
    int page = 1,
    int limit = 20,
  }) async {
    return _apiService.search(
      query: query,
      categoryId: categoryId,
      latitude: latitude,
      longitude: longitude,
      page: page,
      limit: limit,
    );
  }

  // Location Methods
  Future<List<AreaModel>> getAreas() async {
    return _apiService.getAreas();
  }

  Future<List<CityModel>> getCities() async {
    return _apiService.getCities();
  }

  // Sync Methods
  Future<SyncResult> syncData() async {
    final result = await _adminApiService.syncData(lastSyncTime: _lastSyncTime);
    _lastSyncTime = result.serverTime;
    return result;
  }

  // Driver Location
  Future<DriverLocationModel> getDriverLocation(String orderId) async {
    return _adminApiService.getDriverLocation(orderId);
  }

  // Admin-specific methods
  Future<AdminOrdersResponse> getAllOrdersAdmin({
    int page = 1,
    int limit = 50,
    String? status,
    String? restaurantId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return _adminApiService.getAllOrders(
      page: page,
      limit: limit,
      status: status,
      restaurantId: restaurantId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  Future<AdminRestaurantsResponse> getAllRestaurantsAdmin({
    int page = 1,
    int limit = 50,
    bool? isActive,
    bool? isOpen,
    String? categoryId,
  }) async {
    return _adminApiService.getAllRestaurants(
      page: page,
      limit: limit,
      isActive: isActive,
      isOpen: isOpen,
      categoryId: categoryId,
    );
  }
}

// Export response models for convenience
export 'package:talabtek_customer/shared/services/api_service.dart' 
    show CouponValidationResult, WalletTopUpResult, ChatSessionModel, ChatMessageModel, SearchResultModel, AreaModel, CityModel;
export 'package:talabtek_customer/shared/services/admin_api_service.dart' 
    show AdminOrdersResponse, AdminRestaurantsResponse, DriverLocationModel, SyncResult;