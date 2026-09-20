import 'package:flutter/foundation.dart';
import 'package:talabtek_customer/shared/models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  CartModel _cart = CartModel.empty();
  bool _isLoading = false;
  String? _error;
  
  CartModel get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEmpty => _cart.items.isEmpty;
  int get itemCount => _cart.items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _cart.items.fold(0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => _cart.deliveryFee;
  double get tax => _cart.tax;
  double get discount => _cart.discount;
  double get total => _cart.total;
  String? get appliedCouponCode => _cart.appliedCouponCode;
  String? get restaurantId => _cart.restaurantId;
  String? get restaurantName => _cart.restaurantName;
  
  // Add item to cart
  Future<bool> addItem(CartItemModel item) async {
    if (_cart.restaurantId != null && _cart.restaurantId != item.restaurantId) {
      _setError('لا يمكن إضافة منتجات من مطاعم مختلفة. يرجى إفراغ السلة أولاً.');
      return false;
    }
    
    _setLoading(true);
    _clearError();
    
    try {
      final existingIndex = _cart.items.indexWhere((i) => i.productId == item.productId && 
          _areOptionsEqual(i.selectedOptions, item.selectedOptions));
      
      if (existingIndex >= 0) {
        _cart.items[existingIndex] = _cart.items[existingIndex].copyWith(
          quantity: _cart.items[existingIndex].quantity + item.quantity,
        );
      } else {
        _cart.items.add(item);
      }
      
      if (_cart.restaurantId == null) {
        _cart = _cart.copyWith(
          restaurantId: item.restaurantId,
          restaurantName: item.restaurantName,
        );
      }
      
      _recalculate();
      await _saveCart();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('فشل في إضافة المنتج: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Update item quantity
  Future<void> updateQuantity(String itemId, int quantity) async {
    if (quantity <= 0) {
      await removeItem(itemId);
      return;
    }
    
    final index = _cart.items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      _cart.items[index] = _cart.items[index].copyWith(quantity: quantity);
      _recalculate();
      await _saveCart();
      notifyListeners();
    }
  }
  
  // Remove item from cart
  Future<void> removeItem(String itemId) async {
    _cart.items.removeWhere((item) => item.id == itemId);
    
    if (_cart.items.isEmpty) {
      _cart = CartModel.empty();
    }
    
    _recalculate();
    await _saveCart();
    notifyListeners();
  }
  
  // Clear cart
  Future<void> clearCart() async {
    _cart = CartModel.empty();
    await _saveCart();
    notifyListeners();
  }
  
  // Apply coupon
  Future<bool> applyCoupon(String code, double discountAmount) async {
    _setLoading(true);
    _clearError();
    
    try {
      _cart = _cart.copyWith(
        appliedCouponCode: code,
        discount: discountAmount,
      );
      _recalculate();
      await _saveCart();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('فشل في تطبيق الكوبون: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Remove coupon
  Future<void> removeCoupon() async {
    _cart = _cart.copyWith(
      appliedCouponCode: null,
      discount: 0,
    );
    _recalculate();
    await _saveCart();
    notifyListeners();
  }
  
  // Set delivery fee
  Future<void> setDeliveryFee(double fee) async {
    _cart = _cart.copyWith(deliveryFee: fee);
    _recalculate();
    await _saveCart();
    notifyListeners();
  }
  
  // Set delivery address
  Future<void> setDeliveryAddress(DeliveryAddressModel address) async {
    _cart = _cart.copyWith(deliveryAddress: address);
    await _saveCart();
    notifyListeners();
  }
  
  // Set payment method
  Future<void> setPaymentMethod(String methodId) async {
    _cart = _cart.copyWith(paymentMethodId: methodId);
    await _saveCart();
    notifyListeners();
  }
  
  // Add note
  Future<void> addNote(String note, {bool isForRestaurant = false}) async {
    if (isForRestaurant) {
      _cart = _cart.copyWith(restaurantNote: note);
    } else {
      _cart = _cart.copyWith(driverNote: note);
    }
    await _saveCart();
    notifyListeners();
  }
  
  bool _areOptionsEqual(List<CartOptionModel> options1, List<CartOptionModel> options2) {
    if (options1.length != options2.length) return false;
    for (int i = 0; i < options1.length; i++) {
      if (options1[i].optionId != options2[i].optionId ||
          options1[i].valueId != options2[i].valueId) {
        return false;
      }
    }
    return true;
  }
  
  void _recalculate() {
    final subtotal = _cart.items.fold(0.0, (sum, item) => sum + item.totalPrice);
    double tax = subtotal * 0.15; // 15% VAT
    double total = subtotal + _cart.deliveryFee + tax - _cart.discount;
    if (total < 0) total = 0;
    
    _cart = _cart.copyWith(
      subtotal: subtotal,
      tax: tax,
      total: total,
    );
  }
  
  Future<void> _saveCart() async {
    // Save to local storage (SharedPreferences/Hive)
  }
  
  Future<void> loadCart() async {
    _setLoading(true);
    try {
      // Load from local storage
      _recalculate();
    } catch (e) {
      _setError('فشل في تحميل السلة: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
  }
}