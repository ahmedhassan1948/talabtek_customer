import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _fcmToken;
  bool _notificationsEnabled = true;
  
  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get fcmToken => _fcmToken;
  bool get notificationsEnabled => _notificationsEnabled;
  
  Future<void> initialize() async {
    await _requestPermissions();
    await _getFCMToken();
    await _setupMessageHandlers();
    await _loadNotifications();
  }
  
  Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    _notificationsEnabled = settings.authorizationStatus == AuthorizationStatus.authorized;
  }
  
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _messaging.getToken();
      if (_fcmToken != null) {
        debugPrint('FCM Token: $_fcmToken');
        // Save token to user document in Firestore
      }
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
    }
  }
  
  Future<void> _setupMessageHandlers() async {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message);
    });
    
    // Background messages (app opened from notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });
    
    // Terminated state (app opened from notification when closed)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
    
    // Token refresh
    _messaging.onTokenRefresh.listen((token) {
      _fcmToken = token;
      // Update token in Firestore
    });
  }
  
  void _handleForegroundMessage(RemoteMessage message) {
    final notification = NotificationModel.fromRemoteMessage(message);
    _notifications.insert(0, notification);
    _unreadCount++;
    notifyListeners();
    
    // Show local notification if app is in foreground
    _showLocalNotification(notification);
  }
  
  void _handleNotificationTap(RemoteMessage message) {
    // Navigate based on notification data
    final data = message.data;
    final type = data['type'];
    final id = data['id'];
    
    debugPrint('Notification tapped: $type - $id');
    // Navigation logic would go here
  }
  
  void _showLocalNotification(NotificationModel notification) {
    // Implement local notification display
    // Using flutter_local_notifications package
  }
  
  Future<void> _loadNotifications() async {
    _setLoading(true);
    try {
      // Load from Firestore
      final userId = 'current_user_id'; // Get from auth provider
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();
      
      _notifications = snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
      
      _unreadCount = _notifications.where((n) => !n.isRead).length;
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index >= 0 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
      notifyListeners();
      
      // Update in Firestore
      try {
        final userId = 'current_user_id';
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('notifications')
            .doc(notificationId)
            .update({'isRead': true});
      } catch (e) {
        debugPrint('Error marking as read: $e');
      }
    }
  }
  
  Future<void> markAllAsRead() async {
    for (var notification in _notifications) {
      if (!notification.isRead) {
        notification = notification.copyWith(isRead: true);
      }
    }
    _unreadCount = 0;
    notifyListeners();
    
    // Batch update in Firestore
  }
  
  Future<void> deleteNotification(String notificationId) async {
    _notifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();
    
    try {
      final userId = 'current_user_id';
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .delete();
    } catch (e) {
      debugPrint('Error deleting notification: $e');
    }
  }
  
  Future<void> clearAllNotifications() async {
    _notifications.clear();
    _unreadCount = 0;
    notifyListeners();
  }
  
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }
  
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String? imageUrl;
  final String type;
  final Map<String, dynamic> data;
  final bool isRead;
  final DateTime createdAt;
  
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.type,
    required this.data,
    this.isRead = false,
    required this.createdAt,
  });
  
  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? imageUrl,
    String? type,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      imageUrl: data['imageUrl'],
      type: data['type'] ?? 'general',
      data: data['data'] ?? {},
      isRead: data['isRead'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
  
  factory NotificationModel.fromRemoteMessage(RemoteMessage message) {
    return NotificationModel(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      imageUrl: message.notification?.android?.imageUrl ?? 
                message.notification?.apple?.imageUrl,
      type: message.data['type'] ?? 'general',
      data: message.data,
      createdAt: DateTime.now(),
    );
  }
  
  Map<String, dynamic> toFirestore() => {
    'title': title,
    'body': body,
    'imageUrl': imageUrl,
    'type': type,
    'data': data,
    'isRead': isRead,
    'createdAt': FieldValue.serverTimestamp(),
  };
}