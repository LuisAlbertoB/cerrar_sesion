import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionService extends ChangeNotifier {
  static const _inactivityTimeout = Duration(minutes: 1); // Set to 1 min for testing as per plan
  // In a real app, this might be 5-15 mins.
  
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Timer? _timer;
  bool _isLoggedIn = false;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> login() async {
    // Simulate a login
    _token = "dummy_token_${DateTime.now().millisecondsSinceEpoch}";
    await _storage.write(key: 'auth_token', value: _token);
    await _storage.write(key: 'login_timestamp', value: DateTime.now().toIso8601String());
    
    _isLoggedIn = true;
    _startTimer();
    notifyListeners();
  }

  Future<void> logout() async {
    _timer?.cancel();
    _token = null;
    _isLoggedIn = false;
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'login_timestamp');
    notifyListeners();
  }

  void resetTimer() {
    if (!_isLoggedIn) return;
    print("User interaction detected. Resetting timer.");
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(_inactivityTimeout, () {
      print("Session timed out due to inactivity.");
      logout();
    });
  }

  // Check storage on app start to maybe restore session?
  // The user requirement says "if the user does not interact... close session". 
  // It implies if they close the app and reopen, they might still be logged in if within time limit?
  // Or simply: check if token exists. 
  // For this implementation, I'll add a simple check.
  Future<void> checkSession() async {
    String? token = await _storage.read(key: 'auth_token');
    if (token != null) {
      _isLoggedIn = true;
      _token = token;
      _startTimer();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
