import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String nameEn;
  final String description;
  final String descriptionEn;
  final String imageUrl;
  final String coverImageUrl;
  final List<String> images;
  final String categoryId;
  final List<String> subCategoryIds;
  final List<String> tags;
  final double rating;
  final int reviewCount;
  final int deliveryTimeMin;
  final int deliveryTimeMax;
  final double deliveryFee;
  final double minOrderAmount;
  final double freeDeliveryThreshold;
  final LatLng location;
  final String address;
  final String phone;
  final String email;
  final bool isOpen;
  final bool isActive;
  final bool isFeatured;
  final bool hasOffer;
  final String? offerText;
  final OpeningHoursModel openingHours;
  final List<PaymentMethodModel> acceptedPayments;
  final List<String> cuisines;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  RestaurantModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.description,
    required this.descriptionEn,
    required this.imageUrl,
    required this.coverImageUrl,
    required this.images,
    required this.categoryId,
    required this.subCategoryIds,
    required this.tags,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTimeMin,
    required this.deliveryTimeMax,
    required this.deliveryFee,
    required this.minOrderAmount,
    required this.freeDeliveryThreshold,
    required this.location,
    required this.address,
    required this.phone,
    required this.email,
    this.isOpen = true,
    this.isActive = true,
    this.isFeatured = false,
    this.hasOffer = false,
    this.offerText,
    required this.openingHours,
    required this.acceptedPayments,
    required this.cuisines,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });
  
  String get deliveryTimeRange => '$deliveryTimeMin - $deliveryTimeMax دقيقة';
  bool get offersFreeDelivery => deliveryFee == 0;
  double get averageRating => rating;
  
  Map<String, dynamic> toFirestore() => {
    'name': name,
    'nameEn': nameEn,
    'description': description,
    'descriptionEn': descriptionEn,
    'imageUrl': imageUrl,
    'coverImageUrl': coverImageUrl,
    'images': images,
    'categoryId': categoryId,
    'subCategoryIds': subCategoryIds,
    'tags': tags,
    'rating': rating,
    'reviewCount': reviewCount,
    'deliveryTimeMin': deliveryTimeMin,
    'deliveryTimeMax': deliveryTimeMax,
    'deliveryFee': deliveryFee,
    'minOrderAmount': minOrderAmount,
    'freeDeliveryThreshold': freeDeliveryThreshold,
    'location': GeoPoint(location.latitude, location.longitude),
    'address': address,
    'phone': phone,
    'email': email,
    'isOpen': isOpen,
    'isActive': isActive,
    'isFeatured': isFeatured,
    'hasOffer': hasOffer,
    'offerText': offerText,
    'openingHours': openingHours.toJson(),
    'acceptedPayments': acceptedPayments.map((p) => p.toJson()).toList(),
    'cuisines': cuisines,
    'metadata': metadata,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };
  
factory RestaurantModel.fromFirestore(DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      return RestaurantModel.fromJson({'id': doc.id, ...data});
    }

    factory RestaurantModel.fromJson(Map<String, dynamic> json) {
      final data = json['data'] ?? json;
      return RestaurantModel(
        id: json['id'] ?? data['id'] ?? '',
        name: data['name'] ?? '',
        nameEn: data['nameEn'] ?? '',
        description: data['description'] ?? '',
        descriptionEn: data['descriptionEn'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        coverImageUrl: data['coverImageUrl'] ?? '',
        images: List<String>.from(data['images'] ?? []),
        categoryId: data['categoryId'] ?? '',
        subCategoryIds: List<String>.from(data['subCategoryIds'] ?? []),
        tags: List<String>.from(data['tags'] ?? []),
        rating: (data['rating'] ?? 0).toDouble(),
        reviewCount: data['reviewCount'] ?? 0,
        deliveryTimeMin: data['deliveryTimeMin'] ?? 30,
        deliveryTimeMax: data['deliveryTimeMax'] ?? 45,
        deliveryFee: (data['deliveryFee'] ?? 0).toDouble(),
        minOrderAmount: (data['minOrderAmount'] ?? 0).toDouble(),
        freeDeliveryThreshold: (data['freeDeliveryThreshold'] ?? 0).toDouble(),
        location: LatLng(
          (data['location'] as GeoPoint?)?.latitude ??
              (data['latitude'] ?? 0).toDouble(),
          (data['location'] as GeoPoint?)?.longitude ??
              (data['longitude'] ?? 0).toDouble(),
        ),
        address: data['address'] ?? '',
        phone: data['phone'] ?? '',
        email: data['email'] ?? '',
        isOpen: data['isOpen'] ?? true,
        isActive: data['isActive'] ?? true,
        isFeatured: data['isFeatured'] ?? false,
        hasOffer: data['hasOffer'] ?? false,
        offerText: data['offerText'],
        openingHours: OpeningHoursModel.fromJson(data['openingHours'] ?? {}),
        acceptedPayments: (data['acceptedPayments'] as List? ?? [])
            .map((p) => PaymentMethodModel.fromJson(p))
            .toList(),
        cuisines: List<String>.from(data['cuisines'] ?? []),
        metadata: data['metadata'] ?? {},
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ??
            DateTime.tryParse(data['createdAt'] ?? '') ??
            DateTime.now(),
        updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ??
            DateTime.tryParse(data['updatedAt'] ?? '') ??
            DateTime.now(),
      );
    }
  }

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel.fromJson(json);
  }
}

class OpeningHoursModel {
  final Map<String, DayHoursModel> days;
  final bool is24Hours;
  
  OpeningHoursModel({
    required this.days,
    this.is24Hours = false,
  });
  
  factory OpeningHoursModel.defaultHours() => OpeningHoursModel(
    days: {
      'sunday': DayHoursModel(open: '09:00', close: '23:00', isClosed: false),
      'monday': DayHoursModel(open: '09:00', close: '23:00', isClosed: false),
      'tuesday': DayHoursModel(open: '09:00', close: '23:00', isClosed: false),
      'wednesday': DayHoursModel(open: '09:00', close: '23:00', isClosed: false),
      'thursday': DayHoursModel(open: '09:00', close: '23:00', isClosed: false),
      'friday': DayHoursModel(open: '09:00', close: '23:00', isClosed: false),
      'saturday': DayHoursModel(open: '09:00', close: '23:00', isClosed: false),
    },
  );
  
  Map<String, dynamic> toJson() => {
    'days': days.map((k, v) => MapEntry(k, v.toJson())),
    'is24Hours': is24Hours,
  };
  
  factory OpeningHoursModel.fromJson(Map<String, dynamic> json) => OpeningHoursModel(
    days: (json['days'] as Map? ?? {}).map(
      (k, v) => MapEntry(k as String, DayHoursModel.fromJson(v)),
    ),
    is24Hours: json['is24Hours'] ?? false,
  );
  
  bool isOpenNow() {
    if (is24Hours) return true;
    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);
    final dayHours = days[dayName];
    if (dayHours == null || dayHours.isClosed) return false;
    
    final currentMinutes = now.hour * 60 + now.minute;
    final openMinutes = _timeToMinutes(dayHours.open);
    final closeMinutes = _timeToMinutes(dayHours.close);
    
    return currentMinutes >= openMinutes && currentMinutes <= closeMinutes;
  }
  
  String _getDayName(int weekday) {
    const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    return days[weekday - 1];
  }
  
  int _timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}

class DayHoursModel {
  final String open;
  final String close;
  final bool isClosed;
  
  DayHoursModel({
    required this.open,
    required this.close,
    this.isClosed = false,
  });
  
  Map<String, dynamic> toJson() => {
    'open': open,
    'close': close,
    'isClosed': isClosed,
  };
  
  factory DayHoursModel.fromJson(Map<String, dynamic> json) => DayHoursModel(
    open: json['open'] ?? '09:00',
    close: json['close'] ?? '23:00',
    isClosed: json['isClosed'] ?? false,
  );
}

class PaymentMethodModel {
  final String id;
  final String name;
  final String icon;
  final bool isEnabled;
  
  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.icon,
    this.isEnabled = true,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'isEnabled': isEnabled,
  };
  
  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) => PaymentMethodModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    icon: json['icon'] ?? '',
    isEnabled: json['isEnabled'] ?? true,
  );
}

class CategoryModel {
  final String id;
  final String name;
  final String nameEn;
  final String icon;
  final String imageUrl;
  final String color;
  final int order;
  final bool isActive;
  final String? parentId;
  final List<String> subCategoryIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  CategoryModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.icon,
    required this.imageUrl,
    required this.color,
    required this.order,
    this.isActive = true,
    this.parentId,
    required this.subCategoryIds,
    required this.createdAt,
    required this.updatedAt,
  });
  
  Map<String, dynamic> toFirestore() => {
    'name': name,
    'nameEn': nameEn,
    'icon': icon,
    'imageUrl': imageUrl,
    'color': color,
    'order': order,
    'isActive': isActive,
    'parentId': parentId,
    'subCategoryIds': subCategoryIds,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };
  
  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      nameEn: data['nameEn'] ?? '',
      icon: data['icon'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      color: data['color'] ?? '#FF6B35',
      order: data['order'] ?? 0,
      isActive: data['isActive'] ?? true,
      parentId: data['parentId'],
      subCategoryIds: List<String>.from(data['subCategoryIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class ProductModel {
  final String id;
  final String restaurantId;
  final String categoryId;
  final String subCategoryId;
  final String name;
  final String nameEn;
  final String description;
  final String descriptionEn;
  final String imageUrl;
  final List<String> images;
  final double price;
  final double? originalPrice;
  final double discountPercentage;
  final int calories;
  final String preparationTime;
  final bool isAvailable;
  final bool isPopular;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final bool isHalal;
  final int spicyLevel; // 0-3
  final List<ProductOptionGroupModel> optionGroups;
  final List<String> tags;
  final List<String> allergens;
  final Map<String, dynamic> nutritionInfo;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  ProductModel({
    required this.id,
    required this.restaurantId,
    required this.categoryId,
    required this.subCategoryId,
    required this.name,
    required this.nameEn,
    required this.description,
    required this.descriptionEn,
    required this.imageUrl,
    required this.images,
    required this.price,
    this.originalPrice,
    this.discountPercentage = 0,
    this.calories = 0,
    this.preparationTime = '15-20 دقيقة',
    this.isAvailable = true,
    this.isPopular = false,
    this.isVegetarian = false,
    this.isVegan = false,
    this.isGlutenFree = false,
    this.isHalal = true,
    this.spicyLevel = 0,
    required this.optionGroups,
    required this.tags,
    required this.allergens,
    required this.nutritionInfo,
    this.order = 0,
    required this.createdAt,
    required this.updatedAt,
  });
  
  bool get hasDiscount => discountPercentage > 0 && originalPrice != null && originalPrice! > price;
  double get finalPrice => hasDiscount ? price : price;
  String get formattedPrice => '${finalPrice.toStringAsFixed(2)} ر.س';
  bool get hasOptions => optionGroups.isNotEmpty;
  
  Map<String, dynamic> toFirestore() => {
    'restaurantId': restaurantId,
    'categoryId': categoryId,
    'subCategoryId': subCategoryId,
    'name': name,
    'nameEn': nameEn,
    'description': description,
    'descriptionEn': descriptionEn,
    'imageUrl': imageUrl,
    'images': images,
    'price': price,
    'originalPrice': originalPrice,
    'discountPercentage': discountPercentage,
    'calories': calories,
    'preparationTime': preparationTime,
    'isAvailable': isAvailable,
    'isPopular': isPopular,
    'isVegetarian': isVegetarian,
    'isVegan': isVegan,
    'isGlutenFree': isGlutenFree,
    'isHalal': isHalal,
    'spicyLevel': spicyLevel,
    'optionGroups': optionGroups.map((g) => g.toJson()).toList(),
    'tags': tags,
    'allergens': allergens,
    'nutritionInfo': nutritionInfo,
    'order': order,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };
  
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      restaurantId: data['restaurantId'] ?? '',
      categoryId: data['categoryId'] ?? '',
      subCategoryId: data['subCategoryId'] ?? '',
      name: data['name'] ?? '',
      nameEn: data['nameEn'] ?? '',
      description: data['description'] ?? '',
      descriptionEn: data['descriptionEn'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      price: (data['price'] ?? 0).toDouble(),
      originalPrice: (data['originalPrice'] as num?)?.toDouble(),
      discountPercentage: (data['discountPercentage'] ?? 0).toDouble(),
      calories: data['calories'] ?? 0,
      preparationTime: data['preparationTime'] ?? '15-20 دقيقة',
      isAvailable: data['isAvailable'] ?? true,
      isPopular: data['isPopular'] ?? false,
      isVegetarian: data['isVegetarian'] ?? false,
      isVegan: data['isVegan'] ?? false,
      isGlutenFree: data['isGlutenFree'] ?? false,
      isHalal: data['isHalal'] ?? true,
      spicyLevel: data['spicyLevel'] ?? 0,
      optionGroups: (data['optionGroups'] as List? ?? [])
          .map((g) => ProductOptionGroupModel.fromJson(g))
          .toList(),
      tags: List<String>.from(data['tags'] ?? []),
      allergens: List<String>.from(data['allergens'] ?? []),
      nutritionInfo: data['nutritionInfo'] ?? {},
      order: data['order'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class ProductOptionGroupModel {
  final String id;
  final String name;
  final String nameEn;
  final String type; // single, multiple
  final bool isRequired;
  final int minSelections;
  final int maxSelections;
  final List<ProductOptionModel> options;
  
  ProductOptionGroupModel({
    required this.id,
    required this.name,
    required this.nameEn,
    this.type = 'single',
    this.isRequired = false,
    this.minSelections = 0,
    this.maxSelections = 1,
    required this.options,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'nameEn': nameEn,
    'type': type,
    'isRequired': isRequired,
    'minSelections': minSelections,
    'maxSelections': maxSelections,
    'options': options.map((o) => o.toJson()).toList(),
  };
  
  factory ProductOptionGroupModel.fromJson(Map<String, dynamic> json) => ProductOptionGroupModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    nameEn: json['nameEn'] ?? '',
    type: json['type'] ?? 'single',
    isRequired: json['isRequired'] ?? false,
    minSelections: json['minSelections'] ?? 0,
    maxSelections: json['maxSelections'] ?? 1,
    options: (json['options'] as List? ?? [])
        .map((o) => ProductOptionModel.fromJson(o))
        .toList(),
  );
}

class ProductOptionModel {
  final String id;
  final String name;
  final String nameEn;
  final double price;
  final bool isDefault;
  final String? imageUrl;
  final int calories;
  
  ProductOptionModel({
    required this.id,
    required this.name,
    required this.nameEn,
    this.price = 0,
    this.isDefault = false,
    this.imageUrl,
    this.calories = 0,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'nameEn': nameEn,
    'price': price,
    'isDefault': isDefault,
    'imageUrl': imageUrl,
    'calories': calories,
  };
  
  factory ProductOptionModel.fromJson(Map<String, dynamic> json) => ProductOptionModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    nameEn: json['nameEn'] ?? '',
    price: (json['price'] ?? 0).toDouble(),
    isDefault: json['isDefault'] ?? false,
    imageUrl: json['imageUrl'],
    calories: json['calories'] ?? 0,
  );
}