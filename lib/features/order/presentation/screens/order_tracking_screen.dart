import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:talabtek_customer/features/order/presentation/widgets/order_status_timeline.dart'
import 'package:talabtek_customer/features/order/presentation/widgets/driver_info_card.dart'
import 'package:talabtek_customer/features/order/presentation/widgets/order_details_card.dart'
import 'package:talabtek_customer/shared/providers/auth_provider.dart'
import 'package:talabtek_customer/core/theme/app_theme.dart'
import 'package:talabtek_customer/core/utils/app_router.dart'
import 'package:talabtek_customer/shared/widgets/custom_app_bar.dart'
import 'package:talabtek_customer/shared/widgets/loading_widgets.dart'

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> with TickerProviderStateMixin {
  late GoogleMapController _mapController;
  late AnimationController _driverAnimationController;
  late Animation<double> _driverPositionAnimation;
  
  OrderModel? _order;
  bool _isLoading = true;
  String? _error;
  
  // Mock driver location (would come from real-time updates)
  LatLng _driverLocation = const LatLng(24.7200, 46.6800);
  LatLng _restaurantLocation = const LatLng(24.7136, 46.6753);
  LatLng _customerLocation = const LatLng(24.7300, 46.6900);
  
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _driverAnimationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _driverPositionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _driverAnimationController, curve: Curves.linear),
    );
    _loadOrder();
    _setupMap();
    _startDriverAnimation();
  }

  Future<void> _loadOrder() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _order = _getMockOrder(widget.orderId);
      _isLoading = false;
    });
    _updateMarkersAndRoute();
  }

  void _setupMap() {
    _markers.addAll({
      Marker(
        markerId: const MarkerId('restaurant'),
        position: _restaurantLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: const InfoWindow(title: 'المطعم'),
      ),
      Marker(
        markerId: const MarkerId('customer'),
        position: _customerLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'عنوان التوصيل'),
      ),
    });
  }

  void _updateMarkersAndRoute() {
    _markers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: _driverLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'السائق'),
        rotation: 45,
        anchor: const Offset(0.5, 0.5),
      ),
    );
    
    // Route polyline
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: [_restaurantLocation, _driverLocation, _customerLocation],
        color: Theme.of(context).colorScheme.primary,
        width: 4,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    );
  }

  void _startDriverAnimation() {
    _driverAnimationController.repeat(reverse: true);
    _driverAnimationController.addListener(() {
      if (mounted) {
        setState(() {
          // Animate driver position along route
          final t = _driverPositionAnimation.value;
          _driverLocation = LatLng(
            _restaurantLocation.latitude + t * (_customerLocation.latitude - _restaurantLocation.latitude),
            _restaurantLocation.longitude + t * (_customerLocation.longitude - _restaurantLocation.longitude),
          );
          _updateMarkersAndRoute();
        });
      }
    });
  }

  @override
  void dispose() {
    _driverAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: CustomAppBar(title: 'تتبع الطلب'),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _order == null) {
      return Scaffold(
        appBar: CustomAppBar(title: 'تتبع الطلب'),
        body: Center(child: Text(_error ?? 'خطأ في تحميل الطلب')),
      );
    }

    final order = _order!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'تتبع الطلب #${order.id.substring(0, 8)}',
        actions: [
          IconButton(
            icon: Icon(Icons.chat_outlined, size: 24.w),
            onPressed: _openChat,
          ),
          IconButton(
            icon: Icon(Icons.call_outlined, size: 24.w),
            onPressed: _callDriver,
          ),
        ],
      ),
      body: Column(
        children: [
          // Map
          SizedBox(
            height: 300.h,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _driverLocation,
                zoom: 15,
              ),
              onMapCreated: (controller) => _mapController = controller,
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              trafficEnabled: true,
            ),
          ),
          
          // Status Timeline
          OrderStatusTimeline(
            currentStatus: order.status,
            estimatedDelivery: order.estimatedDeliveryTime,
          ),
          
          // Driver Info
          if (_isDriverAssigned(order.status))
            DriverInfoCard(
              driverName: 'أحمد محمد',
              driverPhone: '0501234567',
              vehicleType: 'تويوتا كامري',
              vehiclePlate: 'أ ب ج 1234',
              rating: 4.9,
              onCall: _callDriver,
              onChat: _openChat,
            ),
          
          // Order Details
          OrderDetailsCard(order: order),
        ],
      ),
    );
  }

  bool _isDriverAssigned(String status) {
    return ['picked_up', 'delivering'].contains(status);
  }

  void _callDriver() {
    // Launch phone dialer
  }

  void _openChat() {
    Navigator.pushNamed(context, '/support/chat/${_order!.id}');
  }

  OrderModel _getMockOrder(String id) {
    return OrderModel(
      id: id,
      userId: 'user1',
      restaurantId: 'rest1',
      restaurantName: 'الخيمة النجدية',
      restaurantImage: 'assets/images/restaurant1.jpg',
      status: 'delivering',
      items: [
        OrderItemModel(
          id: '1',
          productId: 'prod1',
          productName: 'مندي لحم',
          productImage: 'assets/images/mandi.jpg',
          quantity: 2,
          unitPrice: 45.0,
          selectedOptions: [],
        ),
        OrderItemModel(
          id: '2',
          productId: 'prod2',
          productName: 'سلطة فتوش',
          productImage: 'assets/images/fattoush.jpg',
          quantity: 1,
          unitPrice: 18.0,
          selectedOptions: [],
        ),
      ],
      subtotal: 108.0,
      deliveryFee: 5.0,
      tax: 16.95,
      discount: 0,
      total: 129.95,
      paymentMethod: 'cash',
      deliveryAddress: DeliveryAddressModel(
        id: 'addr1',
        label: 'المنزل',
        fullAddress: 'حي النخيل، طريق الملك فهد، الرياض',
        building: 'أ',
        floor: '2',
        apartment: '15',
        landmark: 'بجوار مسجد النور',
        phone: '0501234567',
        recipientName: 'محمد أحمد',
        latitude: 24.7300,
        longitude: 46.6900,
      ),
      restaurantNote: 'بدون بصل في المندي',
      driverNote: 'اتصل عند الوصول',
      createdAt: DateTime.now().subtract(const Duration(minutes: 35)),
      estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 15)),
      driver: DriverModel(
        id: 'driver1',
        name: 'أحمد محمد',
        phone: '0501234567',
        photoUrl: '',
        vehicleType: 'تويوتا كامري',
        vehiclePlate: 'أ ب ج 1234',
        rating: 4.9,
        currentLocation: _driverLocation,
      ),
    );
  }
}

class OrderModel {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String restaurantImage;
  final String status;
  final List<OrderItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final double total;
  final String paymentMethod;
  final DeliveryAddressModel deliveryAddress;
  final String? restaurantNote;
  final String? driverNote;
  final DateTime createdAt;
  final DateTime estimatedDeliveryTime;
  final DriverModel? driver;

  OrderModel({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImage,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.deliveryAddress,
    this.restaurantNote,
    this.driverNote,
    required this.createdAt,
    required this.estimatedDeliveryTime,
    this.driver,
  });
}

class OrderItemModel {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double unitPrice;
  final List<CartOptionModel> selectedOptions;

  OrderItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.unitPrice,
    required this.selectedOptions,
  });
}

class DriverModel {
  final String id;
  final String name;
  final String phone;
  final String photoUrl;
  final String vehicleType;
  final String vehiclePlate;
  final double rating;
  final LatLng currentLocation;

  DriverModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.photoUrl,
    required this.vehicleType,
    required this.vehiclePlate,
    required this.rating,
    required this.currentLocation,
  });
}