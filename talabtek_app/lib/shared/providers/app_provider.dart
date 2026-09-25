import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _error;
  Locale _locale = const Locale('ar', 'SA');
  ThemeMode _themeMode = ThemeMode.light;
  bool _onboardingComplete = false;
  bool _isGuestMode = false;
  
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;
  bool get onboardingComplete => _onboardingComplete;
  bool get isGuestMode => _isGuestMode;
  
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      _onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
      _isGuestMode = prefs.getBool('guest_mode') ?? false;
      
      final languageCode = prefs.getString('language') ?? 'ar';
      final countryCode = prefs.getString('country') ?? 'SA';
      _locale = Locale(languageCode, countryCode);
      
      final themeIndex = prefs.getInt('theme_mode') ?? 0;
      _themeMode = ThemeMode.values[themeIndex];
      
      _isInitialized = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', locale.languageCode);
    await prefs.setString('country', locale.countryCode ?? '');
    notifyListeners();
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
    notifyListeners();
  }
  
  Future<void> setOnboardingComplete() async {
    _onboardingComplete = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    notifyListeners();
  }
  
  Future<void> setGuestMode(bool value) async {
    _isGuestMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('guest_mode', value);
    notifyListeners();
  }
  
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void setError(String? error) {
    _error = error;
    notifyListeners();
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}