import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/auth_service.dart';

// Service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return MockAuthService();
});

// Auth state
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final String? userId;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.userId,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    String? userId,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      userId: userId ?? this.userId,
    );
  }
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService service;

  AuthNotifier({required this.service}) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final profile = await service.login(email, password);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        userId: profile.id,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loginAsArjunMenon() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final profile = await service.login('arjun.menon@academy.air', 'password123');
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        userId: profile.id,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> register(Map<String, dynamic> userData) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final profile = await service.register(userData);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        userId: profile.id,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await service.logout();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final isAuth = await service.isAuthenticated();
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: isAuth,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final service = ref.watch(authServiceProvider);
  final notifier = AuthNotifier(service: service);
  notifier.checkAuthStatus();
  return notifier;
});
