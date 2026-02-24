import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  static AuthService get instance => _instance;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  String? _currentUser;
  String? get currentUser => _currentUser;

  String? _userRole;
  String? get userRole => _userRole;

  // Demo credentials
  static const Map<String, Map<String, String>> _demoUsers = {
    'admin@hubspokes.gov.sz': {
      'password': 'admin123',
      'name': 'Dr. Malaika Madi',
      'role': 'System Administrator',
    },
    'officer@hubspokes.gov.sz': {
      'password': 'officer123',
      'name': 'Nurse Dlamini',
      'role': 'M&E Officer',
    },
    'manager@hubspokes.gov.sz': {
      'password': 'manager123',
      'name': 'Dr. Nkambule',
      'role': 'Hub Manager',
    },
  };

  Future<LoginResult> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    final normalizedEmail = email.trim().toLowerCase();

    if (_demoUsers.containsKey(normalizedEmail)) {
      final user = _demoUsers[normalizedEmail]!;
      if (user['password'] == password) {
        _isAuthenticated = true;
        _currentUser = user['name'];
        _userRole = user['role'];
        notifyListeners();
        return LoginResult.success();
      }
    }

    return LoginResult.failure('Invalid email or password. Please try again.');
  }

  void logout() {
    _isAuthenticated = false;
    _currentUser = null;
    _userRole = null;
    notifyListeners();
  }
}

class LoginResult {
  final bool success;
  final String? error;

  LoginResult._(this.success, this.error);

  factory LoginResult.success() => LoginResult._(true, null);
  factory LoginResult.failure(String error) => LoginResult._(false, error);
}
