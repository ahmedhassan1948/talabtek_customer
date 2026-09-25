import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  final String id;
  final String? restaurantId;
  final String? restaurantName;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final double total;
  final String? appliedCouponCode;
  final DeliveryAddressModel? deliveryAddress;
  final String? paymentMethodId;
  final String? restaurantNote;
  final String? driverNote;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  CartModel({
    required this.id,
    this.restaurantId,
    this.restaurantName,
    required this.items,
    this.subtotal = 0,
    this.deliveryFee = 0,
    this.tax = 0,
    this.discount = 0,
    this.total = 0,
    this.appliedCouponCode,
    this.deliveryAddress,
    this.paymentMethodId,
    this.restaurantNote,
    this.driverNote,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory CartModel.empty() => CartModel(
    id: '',
    items: [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  
  CartModel copyWith({
    String? id,
    String? restaurantId,
    String? restaurantName,
    List<CartItemModel>? items,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? discount,
    double? total,
    String? appliedCouponCode,
    DeliveryAddressModel? deliveryAddress,
    String? paymentMethodId,
    String? restaurantNote,
    String? driverNote,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartModel(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      appliedCouponCode: appliedCouponCode ?? this.appliedCouponCode,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      restaurantNote: restaurantNote ?? this.restaurantNote,
      driverNote: driverNote ?? this.driverNote,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'restaurantId': restaurantId,
    'restaurantName': restaurantName,
    'items': items.map((i) => i.toJson()).toList(),
    'subtotal': subtotal,
    'deliveryFee': deliveryFee,
    'tax': tax,
    'discount': discount,
    'total': total,
    'appliedCouponCode': appliedCouponCode,
    'deliveryAddress': deliveryAddress?.toJson(),
    'paymentMethodId': paymentMethodId,
    'restaurantNote': restaurantNote,
    'driverNote': driverNote,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };
  
  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    id: json['id'] ?? '',
    restaurantId: json['restaurantId'],
    restaurantName: json['restaurantName'],
    items: (json['items'] as List? ?? [])
        .map((i) => CartItemModel.fromJson(i))
        .toList(),
    subtotal: (json['subtotal'] ?? 0).toDouble(),
    deliveryFee: (json['deliveryFee'] ?? 0).toDouble(),
    tax: (json['tax'] ?? 0).toDouble(),
    discount: (json['discount'] ?? 0).toDouble(),
    total: (json['total'] ?? 0).toDouble(),
    appliedCouponCode: json['appliedCouponCode'],
    deliveryAddress: json['deliveryAddress'] != null 
        ? DeliveryAddressModel.fromJson(json['deliveryAddress'])
        : null,
    paymentMethodId: json['paymentMethodId'],
    restaurantNote: json['restaurantNote'],
    driverNote: json['driverNote'],
    createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}

class CartItemModel {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final String restaurantId;
  final String restaurantName;
  final double unitPrice;
  final int quantity;
  final List<CartOptionModel> selectedOptions;
  final String? specialInstructions;
  final DateTime addedAt;
  
  CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.restaurantId,
    required this.restaurantName,
    required this.unitPrice,
    required this.quantity,
    required this.selectedOptions,
    this.specialInstructions,
    required this.addedAt,
  });
  
  double get optionsPrice => selectedOptions.fold(0, (sum, opt) => sum + opt.price);
  double get totalPrice => (unitPrice + optionsPrice) * quantity;
  
  CartItemModel copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productImage,
    String? restaurantId,
    String? restaurantName,
    double? unitPrice,
    int? quantity,
    List<CartOptionModel>? selectedOptions,
    String? specialInstructions,
    DateTime? addedAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      addedAt: addedAt ?? this.addedAt,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': productId,
    'productName': productName,
    'productImage': productImage,
    'restaurantId': restaurantId,
    'restaurantName': restaurantName,
    'unitPrice': unitPrice,
    'quantity': quantity,
    'selectedOptions': selectedOptions.map((o) => o.toJson()).toList(),
    'specialInstructions': specialInstructions,
    'addedAt': Timestamp.fromDate(addedAt),
  };
  
  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    id: json['id'] ?? '',
    productId: json['productId'] ?? '',
    productName: json['productName'] ?? '',
    productImage: json['productImage'] ?? '',
    restaurantId: json['restaurantId'] ?? '',
    restaurantName: json['restaurantName'] ?? '',
    unitPrice: (json['unitPrice'] ?? 0).toDouble(),
    quantity: json['quantity'] ?? 1,
    selectedOptions: (json['selectedOptions'] as List? ?? [])
        .map((o) => CartOptionModel.fromJson(o))
        .toList(),
    specialInstructions: json['specialInstructions'],
    addedAt: (json['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}

class CartOptionModel {
  final String optionId;
  final String optionName;
  final String valueId;
  final String valueName;
  final double price;
  final bool isRequired;
  
  CartOptionModel({
    required this.optionId,
    required this.optionName,
    required this.valueId,
    required this.valueName,
    required this.price,
    this.isRequired = false,
  });
  
  Map<String, dynamic> toJson() => {
    'optionId': optionId,
    'optionName': optionName,
    'valueId': valueId,
    'valueName': valueName,
    'price': price,
    'isRequired': isRequired,
  };
  
  factory CartOptionModel.fromJson(Map<String, dynamic> json) => CartOptionModel(
    optionId: json['optionId'] ?? '',
    optionName: json['optionName'] ?? '',
    valueId: json['valueId'] ?? '',
    valueName: json['valueName'] ?? '',
    price: (json['price'] ?? 0).toDouble(),
    isRequired: json['isRequired'] ?? false,
  );
}

class DeliveryAddressModel {
  final String id;
  final String label;
  final String fullAddress;
  final String building;
  final String floor;
  final String apartment;
  final String landmark;
  final String phone;
  final String recipientName;
  final double latitude;
  final double longitude;
  final bool isDefault;
  
  DeliveryAddressModel({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.building,
    required this.floor,
    required this.apartment,
    required this.landmark,
    required this.phone,
    required this.recipientName,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'fullAddress': fullAddress,
    'building': building,
    'floor': floor,
    'apartment': apartment,
    'landmark': landmark,
    'phone': phone,
    'recipientName': recipientName,
    'latitude': latitude,
    'longitude': longitude,
    'isDefault': isDefault,
  };
  
  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) => DeliveryAddressModel(
    id: json['id'] ?? '',
    label: json['label'] ?? '',
    fullAddress: json['fullAddress'] ?? '',
    building: json['building'] ?? '',
    floor: json['floor'] ?? '',
    apartment: json['apartment'] ?? '',
    landmark: json['landmark'] ?? '',
    phone: json['phone'] ?? '',
    recipientName: json['recipientName'] ?? '',
    latitude: (json['latitude'] ?? 0).toDouble(),
    longitude: (json['longitude'] ?? 0).toDouble(),
    isDefault: json['isDefault'] ?? false,
  );
}