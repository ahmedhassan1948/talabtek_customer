import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocationProvider extends ChangeNotifier {
  Position? _currentPosition;
  LatLng? _selectedLocation;
  String _currentAddress = '';
  List<SavedAddressModel> _savedAddresses = [];
  bool _isLoading = false;
  bool _isSelectingLocation = false;
  String? _error;
  
  Position? get currentPosition => _currentPosition;
  LatLng get currentLatLng => _currentPosition != null 
      ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude) 
      : const LatLng(24.7136, 46.6753); // Default to Riyadh
  LatLng? get selectedLocation => _selectedLocation;
  String get currentAddress => _currentAddress;
  List<SavedAddressModel> get savedAddresses => _savedAddresses;
  bool get isLoading => _isLoading;
  bool get isSelectingLocation => _isSelectingLocation;
  String? get error => _error;
  
  static const LatLng defaultLocation = LatLng(24.7136, 46.6753); // Riyadh
  static const String savedAddressesKey = 'saved_addresses';
  
  Future<void> initialize() async {
    await _loadSavedAddresses();
    await getCurrentLocation();
  }
  
  // Get current location
  Future<bool> getCurrentLocation() async {
    _setLoading(true);
    _clearError();
    
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setError('خدمة الموقع معطلة. يرجى تفعيلها من الإعدادات.');
        return false;
      }
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _setError('تم رفض إذن الموقع. يرجى السماح بالوصول للموقع.');
          return false;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        _setError('تم رفض إذن الموقع بشكل دائم. يرجى تفعيله من إعدادات التطبيق.');
        return false;
      }
      
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      await _updateAddressFromPosition(_currentPosition!);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('فشل في الحصول على الموقع: ${e.toString()}');
      _currentPosition = null;
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Update address from position
  Future<void> _updateAddressFromPosition(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        _currentAddress = _formatAddress(place);
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
      _currentAddress = 'موقع غير معروف';
    }
  }
  
  String _formatAddress(Placemark place) {
    List<String> parts = [];
    if (place.street?.isNotEmpty == true) parts.add(place.street!);
    if (place.subLocality?.isNotEmpty == true) parts.add(place.subLocality!);
    if (place.locality?.isNotEmpty == true) parts.add(place.locality!);
    if (place.administrativeArea?.isNotEmpty == true) parts.add(place.administrativeArea!);
    if (place.country?.isNotEmpty == true) parts.add(place.country!);
    return parts.join(', ');
  }
  
  // Select location on map
  void startLocationSelection() {
    _isSelectingLocation = true;
    notifyListeners();
  }
  
  void updateSelectedLocation(LatLng location) {
    _selectedLocation = location;
    notifyListeners();
  }
  
  Future<void> confirmSelectedLocation() async {
    if (_selectedLocation == null) return;
    
    _setLoading(true);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _selectedLocation!.latitude,
        _selectedLocation!.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        _currentAddress = _formatAddress(placemarks.first);
      }
      
      _isSelectingLocation = false;
      notifyListeners();
    } catch (e) {
      _setError('فشل في الحصول على العنوان: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  void cancelLocationSelection() {
    _isSelectingLocation = false;
    _selectedLocation = null;
    notifyListeners();
  }
  
  // Search address
  Future<List<SearchResultModel>> searchAddress(String query) async {
    if (query.isEmpty) return [];
    
    try {
      List<Location> locations = await locationFromAddress(query);
      return locations.map((loc) => SearchResultModel(
        name: query,
        address: '${loc.latitude}, ${loc.longitude}',
        latLng: LatLng(loc.latitude, loc.longitude),
      )).toList();
    } catch (e) {
      debugPrint('Search error: $e');
      return [];
    }
  }
  
  // Save address
  Future<bool> saveAddress(SavedAddressModel address) async {
    _setLoading(true);
    _clearError();
    
    try {
      // Check if default address exists
      if (address.isDefault) {
        _savedAddresses = _savedAddresses.map((a) => a.copyWith(isDefault: false)).toList();
      }
      
      _savedAddresses.add(address);
      await _persistAddresses();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('فشل في حفظ العنوان: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Update address
  Future<bool> updateAddress(String id, SavedAddressModel updatedAddress) async {
    _setLoading(true);
    _clearError();
    
    try {
      final index = _savedAddresses.indexWhere((a) => a.id == id);
      if (index >= 0) {
        if (updatedAddress.isDefault) {
          _savedAddresses = _savedAddresses.map((a) => a.copyWith(isDefault: false)).toList();
        }
        _savedAddresses[index] = updatedAddress;
        await _persistAddresses();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('فشل في تحديث العنوان: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Delete address
  Future<bool> deleteAddress(String id) async {
    _setLoading(true);
    _clearError();
    
    try {
      _savedAddresses.removeWhere((a) => a.id == id);
      await _persistAddresses();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('فشل في حذف العنوان: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Set default address
  Future<void> setDefaultAddress(String id) async {
    _savedAddresses = _savedAddresses.map((a) => 
      a.copyWith(isDefault: a.id == id)
    ).toList();
    await _persistAddresses();
    notifyListeners();
  }
  
  // Get default address
  SavedAddressModel? getDefaultAddress() {
    try {
      return _savedAddresses.firstWhere((a) => a.isDefault);
    } catch (e) {
      return _savedAddresses.isNotEmpty ? _savedAddresses.first : null;
    }
  }
  
  Future<void> _loadSavedAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? addressesJson = prefs.getString(savedAddressesKey);
      if (addressesJson != null) {
        final List<dynamic> decoded = json.decode(addressesJson);
        _savedAddresses = decoded.map((e) => SavedAddressModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Error loading addresses: $e');
    }
  }
  
  Future<void> _persistAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = json.encode(_savedAddresses.map((a) => a.toJson()).toList());
      await prefs.setString(savedAddressesKey, encoded);
    } catch (e) {
      debugPrint('Error saving addresses: $e');
    }
  }
  
  // Calculate distance
  double calculateDistance(LatLng from, LatLng to) {
    return Geolocator.distanceBetween(
      from.latitude, from.longitude,
      to.latitude, to.longitude,
    ) / 1000; // Return in km
  }
  
  // Get nearby restaurants
  Future<List<RestaurantModel>> getNearbyRestaurants({double radiusKm = 10}) async {
    // This would query Firestore with geoqueries
    // Implementation depends on backend structure
    return [];
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

class SearchResultModel {
  final String name;
  final String address;
  final LatLng latLng;
  
  SearchResultModel({
    required this.name,
    required this.address,
    required this.latLng,
  });
}

// Placeholder models
class SavedAddressModel {
  final String id;
  final String label;
  final String address;
  final String building;
  final String floor;
  final String apartment;
  final String landmark;
  final double latitude;
  final double longitude;
  final bool isDefault;
  final DateTime createdAt;
  
  SavedAddressModel({
    required this.id,
    required this.label,
    required this.address,
    required this.building,
    required this.floor,
    required this.apartment,
    required this.landmark,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
    required this.createdAt,
  });
  
  SavedAddressModel copyWith({
    String? id,
    String? label,
    String? address,
    String? building,
    String? floor,
    String? apartment,
    String? landmark,
    double? latitude,
    double? longitude,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return SavedAddressModel(
      id: id ?? this.id,
      label: label ?? this.label,
      address: address ?? this.address,
      building: building ?? this.building,
      floor: floor ?? this.floor,
      apartment: apartment ?? this.apartment,
      landmark: landmark ?? this.landmark,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'address': address,
    'building': building,
    'floor': floor,
    'apartment': apartment,
    'landmark': landmark,
    'latitude': latitude,
    'longitude': longitude,
    'isDefault': isDefault,
    'createdAt': createdAt.toIso8601String(),
  };
  
  factory SavedAddressModel.fromJson(Map<String, dynamic> json) => SavedAddressModel(
    id: json['id'],
    label: json['label'],
    address: json['address'],
    building: json['building'],
    floor: json['floor'],
    apartment: json['apartment'],
    landmark: json['landmark'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    isDefault: json['isDefault'] ?? false,
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class RestaurantModel {
  final String id;
  final String name;
  final String image;
  final double rating;
  final int deliveryTime;
  final double deliveryFee;
  final LatLng location;
  
  RestaurantModel({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.location,
  });
}