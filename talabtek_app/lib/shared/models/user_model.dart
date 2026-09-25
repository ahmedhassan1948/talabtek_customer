import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String? photoUrl;
  final String authProvider;
  final bool isGuest;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;
  final Map<String, dynamic>? additionalData;
  final UserPreferences preferences;
  final WalletModel wallet;
  final LoyaltyModel loyalty;
  
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl,
    required this.authProvider,
    this.isGuest = false,
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
    this.additionalData,
    UserPreferences? preferences,
    WalletModel? wallet,
    LoyaltyModel? loyalty,
  }) : preferences = preferences ?? UserPreferences.defaultPreferences(),
       wallet = wallet ?? WalletModel.empty(),
       loyalty = loyalty ?? LoyaltyModel.empty();
  
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? authProvider,
    bool? isGuest,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? additionalData,
    UserPreferences? preferences,
    WalletModel? wallet,
    LoyaltyModel? loyalty,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      authProvider: authProvider ?? this.authProvider,
      isGuest: isGuest ?? this.isGuest,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      additionalData: additionalData ?? this.additionalData,
      preferences: preferences ?? this.preferences,
      wallet: wallet ?? this.wallet,
      loyalty: loyalty ?? this.loyalty,
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'authProvider': authProvider,
      'isGuest': isGuest,
      'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
      'additionalData': additionalData,
      'preferences': preferences.toJson(),
      'wallet': wallet.toJson(),
      'loyalty': loyalty.toJson(),
    };
  }
  
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      photoUrl: data['photoUrl'],
      authProvider: data['authProvider'] ?? 'unknown',
      isGuest: data['isGuest'] ?? false,
      isVerified: data['isVerified'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLoginAt: (data['lastLoginAt'] as Timestamp?)?.toDate(),
      additionalData: data['additionalData'],
      preferences: UserPreferences.fromJson(data['preferences'] ?? {}),
      wallet: WalletModel.fromJson(data['wallet'] ?? {}),
      loyalty: LoyaltyModel.fromJson(data['loyalty'] ?? {}),
    );
  }
}

class UserPreferences {
  final String language;
  final String currency;
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool promotionalNotifications;
  final bool orderUpdates;
  final bool darkMode;
  final String mapStyle;
  final bool autoPlayVideos;
  final String defaultPaymentMethod;
  
  UserPreferences({
    this.language = 'ar',
    this.currency = 'SAR',
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.smsNotifications = true,
    this.promotionalNotifications = true,
    this.orderUpdates = true,
    this.darkMode = false,
    this.mapStyle = 'normal',
    this.autoPlayVideos = true,
    this.defaultPaymentMethod = 'cash',
  });
  
  factory UserPreferences.defaultPreferences() => UserPreferences();
  
  Map<String, dynamic> toJson() => {
    'language': language,
    'currency': currency,
    'pushNotifications': pushNotifications,
    'emailNotifications': emailNotifications,
    'smsNotifications': smsNotifications,
    'promotionalNotifications': promotionalNotifications,
    'orderUpdates': orderUpdates,
    'darkMode': darkMode,
    'mapStyle': mapStyle,
    'autoPlayVideos': autoPlayVideos,
    'defaultPaymentMethod': defaultPaymentMethod,
  };
  
  factory UserPreferences.fromJson(Map<String, dynamic> json) => UserPreferences(
    language: json['language'] ?? 'ar',
    currency: json['currency'] ?? 'SAR',
    pushNotifications: json['pushNotifications'] ?? true,
    emailNotifications: json['emailNotifications'] ?? true,
    smsNotifications: json['smsNotifications'] ?? true,
    promotionalNotifications: json['promotionalNotifications'] ?? true,
    orderUpdates: json['orderUpdates'] ?? true,
    darkMode: json['darkMode'] ?? false,
    mapStyle: json['mapStyle'] ?? 'normal',
    autoPlayVideos: json['autoPlayVideos'] ?? true,
    defaultPaymentMethod: json['defaultPaymentMethod'] ?? 'cash',
  );
}

class WalletModel {
  final double balance;
  final double pendingBalance;
  final String currency;
  final List<WalletTransactionModel> transactions;
  
  WalletModel({
    this.balance = 0,
    this.pendingBalance = 0,
    this.currency = 'SAR',
    this.transactions = const [],
  });
  
  factory WalletModel.empty() => WalletModel();
  
  Map<String, dynamic> toJson() => {
    'balance': balance,
    'pendingBalance': pendingBalance,
    'currency': currency,
    'transactions': transactions.map((t) => t.toJson()).toList(),
  };
  
  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    balance: (json['balance'] ?? 0).toDouble(),
    pendingBalance: (json['pendingBalance'] ?? 0).toDouble(),
    currency: json['currency'] ?? 'SAR',
    transactions: (json['transactions'] as List? ?? [])
        .map((t) => WalletTransactionModel.fromJson(t))
        .toList(),
  );
}

class WalletTransactionModel {
  final String id;
  final String type; // credit, debit, refund, cashback
  final double amount;
  final String description;
  final String? orderId;
  final String? referenceId;
  final DateTime createdAt;
  final String status; // pending, completed, failed
  
  WalletTransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    this.orderId,
    this.referenceId,
    required this.createdAt,
    required this.status,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'amount': amount,
    'description': description,
    'orderId': orderId,
    'referenceId': referenceId,
    'createdAt': Timestamp.fromDate(createdAt),
    'status': status,
  };
  
  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) => WalletTransactionModel(
    id: json['id'] ?? '',
    type: json['type'] ?? '',
    amount: (json['amount'] ?? 0).toDouble(),
    description: json['description'] ?? '',
    orderId: json['orderId'],
    referenceId: json['referenceId'],
    createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    status: json['status'] ?? 'pending',
  );
}

class LoyaltyModel {
  final int points;
  final int tier; // 1: Bronze, 2: Silver, 3: Gold, 4: Platinum
  final int pointsToNextTier;
  final DateTime? tierExpiry;
  
  LoyaltyModel({
    this.points = 0,
    this.tier = 1,
    this.pointsToNextTier = 1000,
    this.tierExpiry,
  });
  
  factory LoyaltyModel.empty() => LoyaltyModel();
  
  Map<String, dynamic> toJson() => {
    'points': points,
    'tier': tier,
    'pointsToNextTier': pointsToNextTier,
    'tierExpiry': tierExpiry != null ? Timestamp.fromDate(tierExpiry!) : null,
  };
  
  factory LoyaltyModel.fromJson(Map<String, dynamic> json) => LoyaltyModel(
    points: json['points'] ?? 0,
    tier: json['tier'] ?? 1,
    pointsToNextTier: json['pointsToNextTier'] ?? 1000,
    tierExpiry: (json['tierExpiry'] as Timestamp?)?.toDate(),
  );
  
  String get tierName {
    switch (tier) {
      case 1: return 'برونزي';
      case 2: return 'فضي';
      case 3: return 'ذهبي';
      case 4: return 'بلاتيني';
      default: return 'برونزي';
    }
  }
  
  Color get tierColor {
    switch (tier) {
      case 1: return const Color(0xFFCD7F32);
      case 2: return const Color(0xFFC0C0C0);
      case 3: return const Color(0xFFFFD700);
      case 4: return const Color(0xFFE5E4E2);
      default: return const Color(0xFFCD7F32);
    }
  }
}