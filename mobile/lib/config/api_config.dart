class ApiConfig {
  // THAY ĐỔI URL NÀY KHI DEPLOY LÊN VPS
  // static const String baseUrl = 'http://10.0.2.2:5000'; // Android Emulator
  // static const String baseUrl = 'http://localhost:5000'; // Web / iOS Simulator
  static const String baseUrl = 'http://103.77.172.239'; // VPS Production
  
  static const String signalRUrl = '$baseUrl/hubs/pcm';
  
  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String me = '/api/auth/me';
  
  // Wallet endpoints
  static const String walletBalance = '/api/wallet/balance';
  static const String walletDeposit = '/api/wallet/deposit';
  static const String walletTransactions = '/api/wallet/transactions';
  
  // Booking endpoints
  static const String courts = '/api/courts';
  static const String bookings = '/api/bookings';
  static const String bookingsCalendar = '/api/bookings/calendar';
  static const String myBookings = '/api/bookings/my';
  
  // Tournament endpoints
  static const String tournaments = '/api/tournaments';
  
  // Member endpoints
  static const String members = '/api/members';
  static const String profile = '/api/members/profile';
  static const String dashboard = '/api/members/dashboard';
  
  // Notifications
  static const String notifications = '/api/notifications';
  static const String unreadCount = '/api/notifications/unread-count';
  
  // News
  static const String news = '/api/news';
  
  // Health
  static const String health = '/api/health';
}
