import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talabtek_customer/shared/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  User? _firebaseUser;
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _error;
  String? _verificationId;
  int? _resendToken;
  
  User? get firebaseUser => _firebaseUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated && _currentUser != null;
  String? get error => _error;
  bool get isGuestMode => _currentUser?.isGuest ?? false;
  
  AuthProvider() {
    _initializeAuthStateListener();
  }
  
  void _initializeAuthStateListener() {
    _auth.authStateChanges().listen((User? user) async {
      _firebaseUser = user;
      if (user != null) {
        await _loadUserData(user.uid);
      } else {
        _currentUser = null;
        _isAuthenticated = false;
      }
      notifyListeners();
    });
  }
  
  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _currentUser = UserModel.fromFirestore(doc);
        _isAuthenticated = true;
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }
  
  Future<void> _saveUserToFirestore(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toFirestore());
  }
  
  // Phone Authentication
  Future<bool> sendOTP(String phoneNumber) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _formatPhoneNumber(phoneNumber),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _setError(_getAuthErrorMessage(e.code));
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
      return true;
    } catch (e) {
      _setError('فشل في إرسال رمز التحقق: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> verifyOTP(String smsCode) async {
    if (_verificationId == null) {
      _setError('انتهت صلاحية الرمز، يرجى طلب رمز جديد');
      return false;
    }
    
    _setLoading(true);
    _clearError();
    
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      await _signInWithCredential(credential);
      return true;
    } catch (e) {
      _setError('رمز التحقق غير صحيح');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> _signInWithCredential(AuthCredential credential) async {
    final userCredential = await _auth.signInWithCredential(credential);
    if (userCredential.user != null) {
      await _handleUserSignIn(userCredential.user!);
    }
  }
  
  // Google Sign In
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();
    
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        await _handleUserSignIn(userCredential.user!, isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false);
      }
      return true;
    } catch (e) {
      _setError('فشل في تسجيل الدخول بـ Google: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Email/Password Sign In
  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await _handleUserSignIn(userCredential.user!);
      }
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e.code));
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Register with Email/Password
  Future<bool> registerWithEmail(String email, String password, String name, String phone) async {
    _setLoading(true);
    _clearError();
    
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        final user = UserModel(
          uid: userCredential.user!.uid,
          name: name,
          email: email,
          phone: phone,
          authProvider: 'email',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _saveUserToFirestore(user);
        _currentUser = user;
        _isAuthenticated = true;
      }
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e.code));
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Guest Mode
  Future<void> continueAsGuest() async {
    _setLoading(true);
    _clearError();
    
    try {
      final userCredential = await _auth.signInAnonymously();
      if (userCredential.user != null) {
        final user = UserModel(
          uid: userCredential.user!.uid,
          name: 'زائر',
          email: '',
          phone: '',
          authProvider: 'anonymous',
          isGuest: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _saveUserToFirestore(user);
        _currentUser = user;
        _isAuthenticated = true;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('guest_mode', true);
      }
    } catch (e) {
      _setError('فشل في الدخول كزائر: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> _handleUserSignIn(User user, {bool isNewUser = false}) async {
    if (isNewUser) {
      final userModel = UserModel(
        uid: user.uid,
        name: user.displayName ?? 'مستخدم',
        email: user.email ?? '',
        phone: user.phoneNumber ?? '',
        photoUrl: user.photoURL,
        authProvider: _getAuthProvider(user),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _saveUserToFirestore(userModel);
      _currentUser = userModel;
    } else {
      await _loadUserData(user.uid);
    }
    _isAuthenticated = true;
  }
  
  String _getAuthProvider(User user) {
    for (final provider in user.providerData) {
      if (provider.providerId == 'google.com') return 'google';
      if (provider.providerId == 'password') return 'email';
      if (provider.providerId == 'phone') return 'phone';
    }
    return 'unknown';
  }
  
  String _formatPhoneNumber(String phone) {
    String formatted = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (formatted.startsWith('0')) {
      formatted = '966${formatted.substring(1)}';
    } else if (!formatted.startsWith('966')) {
      formatted = '966$formatted';
    }
    return '+$formatted';
  }
  
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'invalid-phone-number':
        return 'رقم الهاتف غير صحيح';
      case 'too-many-requests':
        return 'تم تجاوز عدد المحاولات، يرجى المحاولة لاحقاً';
      case 'invalid-verification-code':
        return 'رمز التحقق غير صحيح';
      case 'session-expired':
        return 'انتهت صلاحية الجلسة، يرجى طلب رمز جديد';
      case 'user-not-found':
        return 'لا يوجد مستخدم بهذا البريد الإلكتروني';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'هذا البريد الإلكتروني مسجل مسبقاً';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'network-request-failed':
        return 'خطأ في الاتصال، تحقق من الإنترنت';
      default:
        return 'حدث خطأ، يرجى المحاولة مرة أخرى';
    }
  }
  
  // Sign Out
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      _currentUser = null;
      _isAuthenticated = false;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('guest_mode', false);
    } catch (e) {
      _setError('فشل في تسجيل الخروج: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  // Update Profile
  Future<bool> updateProfile({
    String? name,
    String? photoUrl,
    Map<String, dynamic>? additionalData,
  }) async {
    if (_currentUser == null) return false;
    
    _setLoading(true);
    _clearError();
    
    try {
      final updatedUser = _currentUser!.copyWith(
        name: name,
        photoUrl: photoUrl,
        updatedAt: DateTime.now(),
        additionalData: additionalData,
      );
      
      await _firestore.collection('users').doc(_currentUser!.uid).update(updatedUser.toFirestore());
      _currentUser = updatedUser;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('فشل في تحديث الملف الشخصي: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Delete Account
  Future<bool> deleteAccount() async {
    if (_firebaseUser == null) return false;
    
    _setLoading(true);
    _clearError();
    
    try {
      await _firestore.collection('users').doc(_firebaseUser!.uid).delete();
      await _firebaseUser!.delete();
      _currentUser = null;
      _isAuthenticated = false;
      return true;
    } catch (e) {
      _setError('فشل في حذف الحساب: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
  }
}