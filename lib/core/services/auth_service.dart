import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  static AuthService get instance => _instance;

  /// The Supabase client instance
  SupabaseClient get _client => Supabase.instance.client;

  /// Whether the user is currently authenticated
  bool get isAuthenticated => _client.auth.currentSession != null;

  /// The current user's email
  String? get currentUserEmail => _client.auth.currentUser?.email;

  /// The current user's display name (from user metadata)
  String? get currentUser {
    final meta = _client.auth.currentUser?.userMetadata;
    return meta?['full_name'] as String? ??
        meta?['name'] as String? ??
        currentUserEmail?.split('@').first ??
        'User';
  }

  /// The current user's role (from user metadata or app_metadata)
  String? get userRole {
    final appMeta = _client.auth.currentUser?.appMetadata;
    final userMeta = _client.auth.currentUser?.userMetadata;
    return appMeta?['role'] as String? ??
        userMeta?['role'] as String? ??
        'M&E Officer';
  }

  /// Initialize auth state listener
  void initialize() {
    _client.auth.onAuthStateChange.listen((data) {
      notifyListeners();
    });
  }

  /// Sign in with email and password
  Future<LoginResult> login(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      if (response.session != null) {
        notifyListeners();
        return LoginResult.success();
      }

      return LoginResult.failure('Login failed. Please try again.');
    } on AuthException catch (e) {
      return LoginResult.failure(_mapAuthError(e.message));
    } catch (e) {
      return LoginResult.failure('An unexpected error occurred. Please try again.');
    }
  }

  /// Sign up a new user with email and password
  Future<LoginResult> signUp({
    required String email,
    required String password,
    String? fullName,
    String? role,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email.trim().toLowerCase(),
        password: password,
        data: {
          if (fullName != null) 'full_name': fullName,
          if (role != null) 'role': role,
        },
      );

      if (response.user != null) {
        notifyListeners();
        return LoginResult.success();
      }

      return LoginResult.failure('Sign up failed. Please try again.');
    } on AuthException catch (e) {
      return LoginResult.failure(_mapAuthError(e.message));
    } catch (e) {
      return LoginResult.failure('An unexpected error occurred. Please try again.');
    }
  }

  /// Sign out the current user
  Future<void> logout() async {
    await _client.auth.signOut();
    notifyListeners();
  }

  /// Map Supabase auth error messages to user-friendly messages
  String _mapAuthError(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('invalid login credentials') ||
        lower.contains('invalid_credentials')) {
      return 'Invalid email or password. Please try again.';
    }
    if (lower.contains('email not confirmed')) {
      return 'Please verify your email before signing in.';
    }
    if (lower.contains('user already registered')) {
      return 'An account with this email already exists.';
    }
    if (lower.contains('too many requests') ||
        lower.contains('rate limit')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }
    return message;
  }
}

class LoginResult {
  final bool success;
  final String? error;

  LoginResult._(this.success, this.error);

  factory LoginResult.success() => LoginResult._(true, null);
  factory LoginResult.failure(String error) => LoginResult._(false, error);
}
