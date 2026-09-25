import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String otp = '/auth/otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String home = '/home';
  static const String restaurant = '/restaurant/:id';
  static const String productDetail = '/product/:id';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String orderTracking = '/order/tracking/:id';
  static const String orderHistory = '/orders';
  static const String orderDetail = '/order/:id';
  static const String profile = '/profile';
  static const String addresses = '/profile/addresses';
  static const String addAddress = '/profile/addresses/add';
  static const String editAddress = '/profile/addresses/edit/:id';
  static const String paymentMethods = '/profile/payment-methods';
  static const String wallet = '/profile/wallet';
  static const String notifications = '/notifications';
  static const String support = '/support';
  static const String chat = '/support/chat/:id';
  static const String settings = '/settings';
  static const String favorites = '/favorites';
  static const String search = '/search';
  static const String category = '/category/:id';
  
  static Map<String, String> extractParams(String route, String path) {
    final routeParts = route.split('/');
    final pathParts = path.split('/');
    final params = <String, String>{};
    
    for (int i = 0; i < routeParts.length; i++) {
      if (routeParts[i].startsWith(':')) {
        final key = routeParts[i].substring(1);
        if (i < pathParts.length) {
          params[key] = pathParts[i];
        }
      }
    }
    return params;
  }
  
  static bool matchRoute(String route, String path) {
    final routeParts = route.split('/');
    final pathParts = path.split('/');
    
    if (routeParts.length != pathParts.length) return false;
    
    for (int i = 0; i < routeParts.length; i++) {
      if (!routeParts[i].startsWith(':') && routeParts[i] != pathParts[i]) {
        return false;
      }
    }
    return true;
  }
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name ?? '/';
    final args = settings.arguments as Map<String, dynamic>?;
    
    // Handle dynamic routes
    if (AppRoutes.matchRoute(AppRoutes.restaurant, name)) {
      final params = AppRoutes.extractParams(AppRoutes.restaurant, name);
      return _buildRoute(
        settings,
        RestaurantScreen(restaurantId: params['id'] ?? ''),
      );
    }
    
    if (AppRoutes.matchRoute(AppRoutes.productDetail, name)) {
      final params = AppRoutes.extractParams(AppRoutes.productDetail, name);
      return _buildRoute(
        settings,
        ProductDetailScreen(productId: params['id'] ?? ''),
      );
    }
    
    if (AppRoutes.matchRoute(AppRoutes.orderTracking, name)) {
      final params = AppRoutes.extractParams(AppRoutes.orderTracking, name);
      return _buildRoute(
        settings,
        OrderTrackingScreen(orderId: params['id'] ?? ''),
      );
    }
    
    if (AppRoutes.matchRoute(AppRoutes.orderDetail, name)) {
      final params = AppRoutes.extractParams(AppRoutes.orderDetail, name);
      return _buildRoute(
        settings,
        OrderDetailScreen(orderId: params['id'] ?? ''),
      );
    }
    
    if (AppRoutes.matchRoute(AppRoutes.editAddress, name)) {
      final params = AppRoutes.extractParams(AppRoutes.editAddress, name);
      return _buildRoute(
        settings,
        EditAddressScreen(addressId: params['id'] ?? ''),
      );
    }
    
    if (AppRoutes.matchRoute(AppRoutes.chat, name)) {
      final params = AppRoutes.extractParams(AppRoutes.chat, name);
      return _buildRoute(
        settings,
        ChatScreen(chatId: params['id'] ?? ''),
      );
    }
    
    if (AppRoutes.matchRoute(AppRoutes.category, name)) {
      final params = AppRoutes.extractParams(AppRoutes.category, name);
      return _buildRoute(
        settings,
        CategoryScreen(categoryId: params['id'] ?? ''),
      );
    }
    
    switch (name) {
      case AppRoutes.splash:
        return _buildRoute(settings, const SplashScreen());
      case AppRoutes.onboarding:
        return _buildRoute(settings, const OnboardingScreen());
      case AppRoutes.auth:
      case AppRoutes.login:
        return _buildRoute(settings, const LoginScreen());
      case AppRoutes.register:
        return _buildRoute(settings, const RegisterScreen());
      case AppRoutes.otp:
        return _buildRoute(settings, OTPScreen(phoneNumber: args?['phone'] ?? ''));
      case AppRoutes.forgotPassword:
        return _buildRoute(settings, const ForgotPasswordScreen());
      case AppRoutes.home:
        return _buildRoute(settings, const HomeScreen());
      case AppRoutes.cart:
        return _buildRoute(settings, const CartScreen());
      case AppRoutes.checkout:
        return _buildRoute(settings, const CheckoutScreen());
      case AppRoutes.payment:
        return _buildRoute(settings, const PaymentScreen());
      case AppRoutes.orderHistory:
        return _buildRoute(settings, const OrderHistoryScreen());
      case AppRoutes.profile:
        return _buildRoute(settings, const ProfileScreen());
      case AppRoutes.addresses:
        return _buildRoute(settings, const AddressesScreen());
      case AppRoutes.addAddress:
        return _buildRoute(settings, const AddAddressScreen());
      case AppRoutes.paymentMethods:
        return _buildRoute(settings, const PaymentMethodsScreen());
      case AppRoutes.wallet:
        return _buildRoute(settings, const WalletScreen());
      case AppRoutes.notifications:
        return _buildRoute(settings, const NotificationsScreen());
      case AppRoutes.support:
        return _buildRoute(settings, const SupportScreen());
      case AppRoutes.settings:
        return _buildRoute(settings, const SettingsScreen());
      case AppRoutes.favorites:
        return _buildRoute(settings, const FavoritesScreen());
      case AppRoutes.search:
        return _buildRoute(settings, const SearchScreen());
      default:
        return _buildRoute(settings, const SplashScreen());
    }
  }
  
  static Route<dynamic> _buildRoute(RouteSettings settings, Widget screen) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
    );
  }
}

// Placeholder screens - will be implemented in features
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Splash')));
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Onboarding')));
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Login')));
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Register')));
}

class OTPScreen extends StatelessWidget {
  final String phoneNumber;
  const OTPScreen({super.key, required this.phoneNumber});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('OTP: $phoneNumber')));
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Forgot Password')));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Home')));
}

class RestaurantScreen extends StatelessWidget {
  final String restaurantId;
  const RestaurantScreen({super.key, required this.restaurantId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Restaurant: $restaurantId')));
}

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Product: $productId')));
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Cart')));
}

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Checkout')));
}

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Payment')));
}

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Tracking: $orderId')));
}

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Order History')));
}

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Order Detail: $orderId')));
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Profile')));
}

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Addresses')));
}

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Add Address')));
}

class EditAddressScreen extends StatelessWidget {
  final String addressId;
  const EditAddressScreen({super.key, required this.addressId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Edit Address: $addressId')));
}

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Payment Methods')));
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Wallet')));
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Notifications')));
}

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Support')));
}

class ChatScreen extends StatelessWidget {
  final String chatId;
  const ChatScreen({super.key, required this.chatId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Chat: $chatId')));
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Settings')));
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Favorites')));
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Search')));
}

class CategoryScreen extends StatelessWidget {
  final String categoryId;
  const CategoryScreen({super.key, required this.categoryId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Category: $categoryId')));
}