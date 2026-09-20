import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  bool _isOnline = false;
  bool _isInitialized = false;

  ConnectivityResult get connectionStatus => _connectionStatus;
  bool get isOnline => _isOnline;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _connectionStatus = await _connectivity.checkConnectivity();
    _isOnline = _connectionStatus != ConnectivityResult.none;
    _isInitialized = true;
    notifyListeners();

    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final wasOnline = _isOnline;
    _connectionStatus = result;
    _isOnline = result != ConnectivityResult.none;
    
    if (wasOnline != _isOnline) {
      notifyListeners();
    }
  }

  Future<bool> checkConnection() async {
    _connectionStatus = await _connectivity.checkConnectivity();
    _isOnline = _connectionStatus != ConnectivityResult.none;
    notifyListeners();
    return _isOnline;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

enum ConnectionType {
  none,
  wifi,
  mobile,
  ethernet,
  bluetooth,
  vpn,
  other,
}

extension ConnectivityResultExtension on ConnectivityResult {
  ConnectionType get type {
    switch (this) {
      case ConnectivityResult.wifi:
        return ConnectionType.wifi;
      case ConnectivityResult.mobile:
        return ConnectionType.mobile;
      case ConnectivityResult.ethernet:
        return ConnectionType.ethernet;
      case ConnectivityResult.bluetooth:
        return ConnectionType.bluetooth;
      case ConnectivityResult.vpn:
        return ConnectionType.vpn;
      case ConnectivityResult.other:
        return ConnectionType.other;
      case ConnectivityResult.none:
        return ConnectionType.none;
    }
  }
  
  String get displayName {
    switch (this) {
      case ConnectivityResult.wifi:
        return 'Wi-Fi';
      case ConnectivityResult.mobile:
        return 'بيانات الجوال';
      case ConnectivityResult.ethernet:
        return 'إيثرنت';
      case ConnectivityResult.bluetooth:
        return 'بلوتوث';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.other:
        return 'أخرى';
      case ConnectivityResult.none:
        return 'غير متصل';
    }
  }
}