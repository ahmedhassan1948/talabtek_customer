import 'package:flutter_test/flutter_test.dart';
import 'package:talabtek_customer/shared/models/cart_model.dart';
import 'package:talabtek_customer/shared/models/restaurant_model.dart';
import 'package:talabtek_customer/shared/models/user_model.dart';

void main() {
  group('CartModel Tests', () {
    late CartModel emptyCart;
    late CartItemModel testItem;
    late CartOptionModel testOption;

    setUp(() {
      emptyCart = CartModel.empty();
      testOption = CartOptionModel(
        optionId: 'size',
        optionName: 'الحجم',
        valueId: 'large',
        valueName: 'كبير',
        price: 5.0,
      );
      testItem = CartItemModel(
        id: 'item_1',
        productId: 'prod_1',
        productName: 'برجر',
        productImage: 'burger.jpg',
        restaurantId: 'rest_1',
        restaurantName: 'مطعم البرجر',
        unitPrice: 25.0,
        quantity: 1,
        selectedOptions: [testOption],
        addedAt: DateTime.now(),
      );
    });

    test('Empty cart should have zero values', () {
      expect(emptyCart.items, isEmpty);
      expect(emptyCart.subtotal, 0.0);
      expect(emptyCart.total, 0.0);
      expect(emptyCart.itemCount, 0);
      expect(emptyCart.isEmpty, true);
    });

    test('Adding item should update cart correctly', () {
      final cart = emptyCart.copyWith(items: [testItem]);
      
      expect(cart.items.length, 1);
      expect(cart.itemCount, 1);
      expect(cart.subtotal, 30.0); // 25 + 5 option
      expect(cart.isEmpty, false);
    });

    test('Multiple quantities should calculate correctly', () {
      final item = testItem.copyWith(quantity: 3);
      final cart = emptyCart.copyWith(items: [item]);
      
      expect(cart.itemCount, 3);
      expect(cart.subtotal, 90.0); // (25 + 5) * 3
    });

    test('Delivery fee and tax calculation', () {
      final cart = emptyCart.copyWith(
        items: [testItem],
        deliveryFee: 5.0,
        tax: 4.5,
      );
      
      expect(cart.total, 39.5); // 30 + 5 + 4.5
    });

    test('Discount should reduce total', () {
      final cart = emptyCart.copyWith(
        items: [testItem],
        deliveryFee: 5.0,
        tax: 4.5,
        discount: 10.0,
      );
      
      expect(cart.total, 29.5); // 30 + 5 + 4.5 - 10
    });

    test('Cannot have negative total', () {
      final cart = emptyCart.copyWith(
        items: [testItem],
        discount: 100.0,
      );
      
      expect(cart.total, 0.0);
    });

    test('Restaurant ID should be set on first item', () {
      final cart = emptyCart.copyWith(items: [testItem]);
      expect(cart.restaurantId, 'rest_1');
      expect(cart.restaurantName, 'مطعم البرجر');
    });
  });

  group('ProductModel Tests', () {
    late ProductModel testProduct;

    setUp(() {
      testProduct = ProductModel(
        id: 'prod_1',
        restaurantId: 'rest_1',
        categoryId: 'cat_1',
        subCategoryId: 'sub_1',
        name: 'برجر لحم',
        nameEn: 'Beef Burger',
        description: 'برجر لذيذ',
        descriptionEn: 'Delicious burger',
        imageUrl: 'burger.jpg',
        images: [],
        price: 30.0,
        originalPrice: 40.0,
        discountPercentage: 25.0,
        calories: 500,
        preparationTime: '20 دقيقة',
        isAvailable: true,
        isPopular: true,
        isVegetarian: false,
        isVegan: false,
        isGlutenFree: false,
        isHalal: true,
        spicyLevel: 1,
        optionGroups: [],
        tags: ['برجر', 'غداء'],
        allergens: ['غلوتين'],
        nutritionInfo: {'protein': '25g', 'carbs': '40g'},
        order: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });

    test('Has discount should be true when originalPrice > price', () {
      expect(testProduct.hasDiscount, true);
      expect(testProduct.discountPercentage, 25.0);
    });

    test('Final price should be discounted price when has discount', () {
      expect(testProduct.finalPrice, 30.0);
    });

    test('Formatted price should include currency', () {
      expect(testProduct.formattedPrice, '30.00 ر.س');
    });

    test('Product without discount should use regular price', () {
      final product = testProduct.copyWith(originalPrice: null, discountPercentage: 0);
      expect(product.hasDiscount, false);
      expect(product.finalPrice, 30.0);
    });

    test('Dietary tags should be detected', () {
      final vegProduct = testProduct.copyWith(isVegetarian: true, isVegan: true);
      expect(vegProduct.isVegetarian, true);
      expect(vegProduct.isVegan, true);
    });
  });

  group('UserModel Tests', () {
    late UserModel testUser;

    setUp(() {
      testUser = UserModel(
        uid: 'user_1',
        name: 'أحمد محمد',
        email: 'ahmed@example.com',
        phone: '0501234567',
        authProvider: 'email',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        wallet: WalletModel(balance: 100.0),
        loyalty: LoyaltyModel(points: 500, tier: 2),
      );
    });

    test('User should have correct initial values', () {
      expect(testUser.name, 'أحمد محمد');
      expect(testUser.wallet.balance, 100.0);
      expect(testUser.loyalty.points, 500);
      expect(testUser.loyalty.tier, 2);
      expect(testUser.loyalty.tierName, 'فضي');
    });

    test('Guest user should have isGuest true', () {
      final guest = UserModel(
        uid: 'guest_1',
        name: 'زائر',
        email: '',
        phone: '',
        authProvider: 'anonymous',
        isGuest: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      expect(guest.isGuest, true);
    });
  });
}