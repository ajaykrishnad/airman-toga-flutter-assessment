class AppConstants {
  AppConstants._();

  static const String appName = 'Airman TOGA';
  
  // API Configuration
  static const String baseUrl = 'https://api.example.com';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Route Paths
  static const String homeRoute = '/';
  static const String settingsRoute = '/settings';
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
}
