import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  
  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  
  AuthProvider() {
    _checkAuth();
  }
  
  Future<void> _checkAuth() async {
    _isLoading = true;
    notifyListeners();
    
    if (await _api.isLoggedIn()) {
      debugPrint('PCM: Token found, checking current user...');
      final response = await _api.getCurrentUser();
      if (response.success && response.data != null) {
        debugPrint('PCM: Auth check successful for ${response.data!.email}');
        _user = response.data;
        _isAuthenticated = true;
      } else {
        debugPrint('PCM: Auth check failed: ${response.message}');
      }
    } else {
      debugPrint('PCM: No token found in storage.');
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    debugPrint('PCM: Attempting login for $email...');
    final response = await _api.login(email, password);

    if (response.success && response.data != null) {
      debugPrint('PCM: Login successful, token received.');
      _user = response.data!.user;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      debugPrint('PCM: Login failed: ${response.message}');
      _error = response.message ?? 'Login failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> register(String email, String password, String fullName, String? phone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    final response = await _api.register(email, password, fullName, phone);
    
    if (response.success && response.data != null) {
      _user = response.data!.user;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = response.message ?? 'Registration failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> logout() async {
    await _api.logout();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
  
  Future<void> refreshUser() async {
    final response = await _api.getCurrentUser();
    if (response.success && response.data != null) {
      _user = response.data;
      notifyListeners();
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

class WalletProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  
  double _balance = 0;
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _error;
  
  double get balance => _balance;
  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> loadBalance() async {
    final response = await _api.getBalance();
    if (response.success && response.data != null) {
      _balance = response.data!;
      notifyListeners();
    }
  }
  
  Future<void> loadTransactions({int page = 1}) async {
    _isLoading = true;
    notifyListeners();
    
    final response = await _api.getTransactions(page: page);
    
    if (response.success && response.data != null) {
      if (page == 1) {
        _transactions = response.data!;
      } else {
        _transactions.addAll(response.data!);
      }
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<bool> deposit(double amount, String? proofImageUrl) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    final response = await _api.deposit(amount, proofImageUrl);
    
    _isLoading = false;
    
    if (response.success) {
      await loadTransactions();
      notifyListeners();
      return true;
    } else {
      _error = response.message;
      notifyListeners();
      return false;
    }
  }
}

class BookingProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  
  List<Court> _courts = [];
  List<CalendarSlot> _slots = [];
  List<Booking> _myBookings = [];
  bool _isLoading = false;
  String? _error;
  DateTime _selectedDate = DateTime.now();
  
  List<Court> get courts => _courts;
  List<CalendarSlot> get slots => _slots;
  List<Booking> get myBookings => _myBookings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime get selectedDate => _selectedDate;
  
  Future<void> loadCourts() async {
    final response = await _api.getCourts();
    if (response.success && response.data != null) {
      _courts = response.data!;
      notifyListeners();
    }
  }
  
  Future<void> loadCalendar({DateTime? date, int? courtId}) async {
    _isLoading = true;
    notifyListeners();
    
    final targetDate = date ?? _selectedDate;
    final startOfDay = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final response = await _api.getCalendar(
      from: startOfDay,
      to: endOfDay,
      courtId: courtId,
    );
    
    if (response.success && response.data != null) {
      _slots = response.data!;
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    loadCalendar(date: date);
  }
  
  Future<void> loadMyBookings() async {
    _isLoading = true;
    notifyListeners();
    
    final response = await _api.getMyBookings();
    
    if (response.success && response.data != null) {
      _myBookings = response.data!;
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<bool> createBooking({
    required int courtId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    final response = await _api.createBooking(
      courtId: courtId,
      startTime: startTime,
      endTime: endTime,
    );
    
    _isLoading = false;
    
    if (response.success) {
      await loadCalendar();
      await loadMyBookings();
      notifyListeners();
      return true;
    } else {
      _error = response.message;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> cancelBooking(int bookingId) async {
    _isLoading = true;
    notifyListeners();
    
    final response = await _api.cancelBooking(bookingId);
    
    _isLoading = false;
    
    if (response.success) {
      await loadMyBookings();
      notifyListeners();
      return true;
    } else {
      _error = response.message;
      notifyListeners();
      return false;
    }
  }
  
  List<CalendarSlot> getSlotsForCourt(int courtId) {
    return _slots.where((s) => s.courtId == courtId).toList();
  }
}

class TournamentProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  
  List<Tournament> _tournaments = [];
  Tournament? _selectedTournament;
  List<Match> _matches = [];
  bool _isLoading = false;
  String? _error;
  
  List<Tournament> get tournaments => _tournaments;
  Tournament? get selectedTournament => _selectedTournament;
  List<Match> get matches => _matches;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<Tournament> get openTournaments =>
      _tournaments.where((t) => t.isOpen).toList();
  
  Future<void> loadTournaments({String? status}) async {
    _isLoading = true;
    notifyListeners();
    
    final response = await _api.getTournaments(status: status);
    
    if (response.success && response.data != null) {
      _tournaments = response.data!;
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> loadTournament(int id) async {
    _isLoading = true;
    notifyListeners();
    
    final response = await _api.getTournament(id);
    
    if (response.success && response.data != null) {
      _selectedTournament = response.data!;
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> loadMatches(int tournamentId) async {
    final response = await _api.getTournamentMatches(tournamentId);
    
    if (response.success && response.data != null) {
      _matches = response.data!;
      notifyListeners();
    }
  }
  
  Future<bool> joinTournament(int tournamentId, {String? teamName}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    final response = await _api.joinTournament(tournamentId, teamName);
    
    _isLoading = false;
    
    if (response.success) {
      await loadTournament(tournamentId);
      notifyListeners();
      return true;
    } else {
      _error = response.message;
      notifyListeners();
      return false;
    }
  }
}

class NotificationProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  
  List<AppNotification> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  
  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  
  Future<void> loadNotifications({int page = 1}) async {
    _isLoading = true;
    notifyListeners();
    
    final response = await _api.getNotifications(page: page);
    
    if (response.success && response.data != null) {
      if (page == 1) {
        _notifications = response.data!;
      } else {
        _notifications.addAll(response.data!);
      }
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> loadUnreadCount() async {
    final response = await _api.getUnreadCount();
    if (response.success && response.data != null) {
      _unreadCount = response.data!;
      notifyListeners();
    }
  }
  
  Future<void> markAsRead(int notificationId) async {
    await _api.markAsRead(notificationId);
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = AppNotification(
        id: _notifications[index].id,
        message: _notifications[index].message,
        type: _notifications[index].type,
        linkUrl: _notifications[index].linkUrl,
        isRead: true,
        createdDate: _notifications[index].createdDate,
      );
      _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
      notifyListeners();
    }
  }
  
  Future<void> markAllAsRead() async {
    await _api.markAllAsRead();
    _notifications = _notifications.map((n) => AppNotification(
      id: n.id,
      message: n.message,
      type: n.type,
      linkUrl: n.linkUrl,
      isRead: true,
      createdDate: n.createdDate,
    )).toList();
    _unreadCount = 0;
    notifyListeners();
  }
}

class DashboardProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  
  Dashboard? _dashboard;
  List<News> _news = [];
  bool _isLoading = false;
  String? _error;
  
  Dashboard? get dashboard => _dashboard;
  List<News> get news => _news;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> loadDashboard() async {
    _isLoading = true;
    notifyListeners();
    
    final response = await _api.getDashboard();
    
    if (response.success && response.data != null) {
      _dashboard = response.data!;
    } else {
      _error = response.message;
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> loadNews() async {
    final response = await _api.getNews();
    
    if (response.success && response.data != null) {
      _news = response.data!;
      notifyListeners();
    }
  }
  
  Future<void> refresh() async {
    await loadDashboard();
    await loadNews();
  }
}
