import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:talabtek_customer/features/cart/presentation/widgets/address_section.dart';
import 'package:talabtek_customer/features/cart/presentation/widgets/payment_section.dart'
import 'package:talabtek_customer/features/cart/presentation/widgets/order_summary.dart'
import 'package:talabtek_customer/features/cart/presentation/widgets/notes_section.dart'
import 'package:talabtek_customer/shared/providers/cart_provider.dart'
import 'package:talabtek_customer/shared/providers/auth_provider.dart'
import 'package:talabtek_customer/shared/providers/location_provider.dart'
import 'package:talabtek_customer/core/theme/app_theme.dart'
import 'package:talabtek_customer/core/utils/app_router.dart'
import 'package:talabtek_customer/shared/widgets/custom_button.dart'
import 'package:talabtek_customer/shared/widgets/custom_app_bar.dart'

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedPaymentMethod = 'cash';
  String _deliveryInstruction = '';
  String _restaurantInstruction = '';
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final cartProvider = context.read<CartProvider>();
    final locationProvider = context.read<LocationProvider>();
    final authProvider = context.read<AuthProvider>();
    
    // Load default address if not set
    if (cartProvider.cart.deliveryAddress == null) {
      final defaultAddress = locationProvider.getDefaultAddress();
      if (defaultAddress != null) {
        cartProvider.setDeliveryAddress(DeliveryAddressModel(
          id: defaultAddress.id,
          label: defaultAddress.label,
          fullAddress: defaultAddress.address,
          building: defaultAddress.building,
          floor: defaultAddress.floor,
          apartment: defaultAddress.apartment,
          landmark: defaultAddress.landmark,
          phone: '',
          recipientName: authProvider.currentUser?.name ?? '',
          latitude: defaultAddress.latitude,
          longitude: defaultAddress.longitude,
        ));
      }
    }
    
    // Set default payment method
    cartProvider.setPaymentMethod(_selectedPaymentMethod);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartProvider = context.watch<CartProvider>();
    final cart = cartProvider.cart;

    if (cartProvider.isEmpty) {
      return Scaffold(
        appBar: CustomAppBar(title: 'إتمام الطلب'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 64.w, color: theme.colorScheme.onSurfaceVariant),
              SizedBox(height: 16.h),
              Text('سلتك فارغة', style: theme.textTheme.titleLarge),
              SizedBox(height: 16.h),
              CustomButton(text: 'استكشاف المطاعم', onPressed: () => Navigator.pop(context)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'إتمام الطلب',
        actions: [
          TextButton(
            onPressed: () => _showEditAddressBottomSheet(),
            child: Text(
              'تغيير',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            // Address Section
            SliverToBoxAdapter(
              child: AddressSection(
                onAddressChanged: (address) => cartProvider.setDeliveryAddress(address),
                onChangeAddress: _showEditAddressBottomSheet,
              ),
            ),
            
            // Notes Section
            SliverToBoxAdapter(
              child: NotesSection(
                onDeliveryNoteChanged: (note) => _deliveryInstruction = note,
                onRestaurantNoteChanged: (note) => _restaurantInstruction = note,
              ),
            ),
            
            // Payment Section
            SliverToBoxAdapter(
              child: PaymentSection(
                selectedPaymentMethod: _selectedPaymentMethod,
                onPaymentMethodChanged: (method) {
                  setState(() => _selectedPaymentMethod = method);
                  cartProvider.setPaymentMethod(method);
                },
                onWalletTap: _showWalletBottomSheet,
              ),
            ),
            
            // Coupon Section
            SliverToBoxAdapter(
              child: _buildCouponSection(cartProvider),
            ),
            
            // Order Summary
            SliverToBoxAdapter(
              child: OrderSummary(cart: cart),
            ),
            
            // Bottom Padding
            SliverToBoxAdapter(
              child: SizedBox(height: 100.h),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, cartProvider),
    );
  }

  Widget _buildCouponSection(CartProvider cartProvider) {
    final theme = Theme.of(context);
    final cart = cartProvider.cart;
    
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'كود الخصم',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),
          if (cart.appliedCouponCode != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    'كود مطبق: ${cart.appliedCouponCode}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => cartProvider.removeCoupon(),
                  child: Text('إزالة', style: TextStyle(color: theme.colorScheme.error)),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'أدخل كود الخصم',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: _applyCoupon,
                  child: Text('تطبيق'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CartProvider cartProvider) {
    final theme = Theme.of(context);
    final cart = cartProvider.cart;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: CustomButton(
          text: 'تأكيد الطلب - ${cart.total.toStringAsFixed(2)} ر.س',
          isLoading: _isPlacingOrder,
          onPressed: _placeOrder,
          height: 52,
          borderRadius: 12,
        ),
      ),
    );
  }

  Future<void> _applyCoupon() async {
    // Simulate coupon application
    await Future.delayed(const Duration(milliseconds: 500));
    final cartProvider = context.read<CartProvider>();
    await cartProvider.applyCoupon('WELCOME50', 15.0);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تطبيق الكود بنجاح! خصم 15 ر.س')),
      );
    }
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    
    final cartProvider = context.read<CartProvider>();
    final cart = cartProvider.cart;
    
    if (cart.deliveryAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى اختيار عنوان التوصيل')),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    // Simulate order placement
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isPlacingOrder = false);
    
    if (mounted) {
      // Clear cart and navigate to order tracking
      await cartProvider.clearCart();
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/order/tracking/mock_order_id',
        (route) => route.isFirst,
      );
    }
  }

  void _showEditAddressBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddressBottomSheet(),
    );
  }

  void _showWalletBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _WalletBottomSheet(),
    );
  }
}

class _AddressBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locationProvider = context.watch<LocationProvider>();
    final addresses = locationProvider.savedAddresses;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              BottomSheetHandle(),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'اختر عنوان التوصيل',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/profile/addresses/add'),
                      child: Text('إضافة عنوان جديد'),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: theme.dividerColor),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.all(16.w),
                  itemCount: addresses.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return _buildAddressTile(context, address);
                  },
                ),
              ),
            ],
          );
        },
      );
  }

  Widget _buildAddressTile(BuildContext context, SavedAddressModel address) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: address.isDefault ? theme.colorScheme.primary : theme.dividerColor,
          width: address.isDefault ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getLabelColor(address.label).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  address.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _getLabelColor(address.label),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (address.isDefault) ...[
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'افتراضي',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            address.recipientName,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            address.fullAddress,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (address.building.isNotEmpty || address.floor.isNotEmpty || address.apartment.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              _buildAddressDetails(address),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: Text('تعديل'),
              ),
              SizedBox(width: 8.w),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Set this address
                },
                child: Text('اختيار'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getLabelColor(String label) {
    switch (label) {
      case 'المنزل': return Colors.blue;
      case 'العمل': return Colors.green;
      case 'أخرى': return Colors.orange;
      default: return Colors.grey;
    }
  }

  String _buildAddressDetails(SavedAddressModel address) {
    final parts = <String>[];
    if (address.building.isNotEmpty) parts.add('مبنى: ${address.building}');
    if (address.floor.isNotEmpty) parts.add('دور: ${address.floor}');
    if (address.apartment.isNotEmpty) parts.add('شقة: ${address.apartment}');
    if (address.landmark.isNotEmpty) parts.add('بجوار: ${address.landmark}');
    return parts.join(' • ');
  }
}

class _WalletBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final wallet = authProvider.currentUser?.wallet;

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.7,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              BottomSheetHandle(),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'المحفظة الإلكترونية',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/profile/wallet'),
                          child: Text('عرض المحفظة'),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [theme.colorScheme.primary, theme.colorScheme.primaryLight],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.account_balance_wallet, size: 40.w, color: Colors.white),
                          SizedBox(width: 16.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'رصيد المحفظة',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              Text(
                                '${wallet?.balance.toStringAsFixed(2) ?? '0.00'} ر.س',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.add_circle_outline, size: 20.w),
                            label: Text('شحن المحفظة'),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Use wallet for payment
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.check_circle_outline, size: 20.w),
                            label: Text('استخدام الرصيد'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
  }
}