import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/models.dart';
import 'token_storage.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  
  late Dio _dio;
  final TokenStorage _storage = TokenStorage();
  
  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    // Add interceptor for JWT token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.readToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Token expired, trigger logout
          _storage.deleteToken();
        }
        return handler.next(error);
      },
    ));
  }
  
  // ========== Auth ==========
  Future<ApiResponse<AuthResponse>> login(String email, String password) async {
    try {
      final response = await _dio.post(ApiConfig.login, data: {
        'email': email,
        'password': password,
      });
      
      final apiResponse = ApiResponse.fromJson(
        response.data,
        (data) => AuthResponse.fromJson(data),
      );
      
      if (apiResponse.success && apiResponse.data != null) {
        await _storage.writeToken(apiResponse.data!.token);
      }
      
      return apiResponse;
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Login failed',
      );
    }
  }
  
  Future<ApiResponse<AuthResponse>> register(
    String email, String password, String fullName, String? phone
  ) async {
    try {
      final response = await _dio.post(ApiConfig.register, data: {
        'email': email,
        'password': password,
        'fullName': fullName,
        'phone': phone,
      });
      
      final apiResponse = ApiResponse.fromJson(
        response.data,
        (data) => AuthResponse.fromJson(data),
      );
      
      if (apiResponse.success && apiResponse.data != null) {
        await _storage.writeToken(apiResponse.data!.token);
      }
      
      return apiResponse;
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Registration failed',
      );
    }
  }
  
  Future<ApiResponse<User>> getCurrentUser() async {
    try {
      final response = await _dio.get(ApiConfig.me);
      return ApiResponse.fromJson(
        response.data,
        (data) => User.fromJson(data),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to get user',
      );
    }
  }
  
  Future<void> logout() async {
    await _storage.deleteToken();
  }
  
  Future<bool> isLoggedIn() async {
    return await _storage.hasToken();
  }
  
  // ========== Dashboard ==========
  Future<ApiResponse<Dashboard>> getDashboard() async {
    try {
      final response = await _dio.get(ApiConfig.dashboard);
      return ApiResponse.fromJson(
        response.data,
        (data) => Dashboard.fromJson(data),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to get dashboard',
      );
    }
  }
  
  // ========== Wallet ==========
  Future<ApiResponse<double>> getBalance() async {
    try {
      final response = await _dio.get(ApiConfig.walletBalance);
      return ApiResponse.fromJson(
        response.data,
        (data) => (data as num).toDouble(),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to get balance',
      );
    }
  }
  
  Future<ApiResponse<Transaction>> deposit(double amount, String? proofImageUrl) async {
    try {
      final response = await _dio.post(ApiConfig.walletDeposit, data: {
        'amount': amount,
        'proofImageUrl': proofImageUrl,
      });
      return ApiResponse.fromJson(
        response.data,
        (data) => Transaction.fromJson(data),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to request deposit',
      );
    }
  }
  
  Future<ApiResponse<List<Transaction>>> getTransactions({int page = 1, int pageSize = 20}) async {
    try {
      final response = await _dio.get(ApiConfig.walletTransactions, queryParameters: {
        'page': page,
        'pageSize': pageSize,
      });
      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List).map((e) => Transaction.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to get transactions',
      );
    }
  }
  
  // ========== Courts & Bookings ==========
  Future<ApiResponse<List<Court>>> getCourts() async {
    try {
      final response = await _dio.get(ApiConfig.courts);
      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List).map((e) => Court.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to get courts',
      );
    }
  }
  
  Future<ApiResponse<List<CalendarSlot>>> getCalendar({
    required DateTime from,
    required DateTime to,
    int? courtId,
  }) async {
    try {
      final response = await _dio.get(ApiConfig.bookingsCalendar, queryParameters: {
        'from': from.toIso8601String(),
        'to': to.toIso8601String(),
        if (courtId != null) 'courtId': courtId,
      });
      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List).map((e) => CalendarSlot.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to get calendar',
      );
    }
  }
  
  Future<ApiResponse<Booking>> createBooking({
    required int courtId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      final response = await _dio.post(ApiConfig.bookings, data: {
        'courtId': courtId,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
      });
      return ApiResponse.fromJson(
        response.data,
        (data) => Booking.fromJson(data),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to create booking',
      );
    }
  }
  
  Future<ApiResponse<List<Booking>>> getMyBookings({DateTime? from, DateTime? to}) async {
    try {
      final response = await _dio.get(ApiConfig.myBookings, queryParameters: {
        if (from != null) 'from': from.toIso8601String(),
        if (to != null) 'to': to.toIso8601String(),
      });
      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List).map((e) => Booking.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to get bookings',
      );
    }
  }
  
  Future<ApiResponse> cancelBooking(int bookingId) async {
    try {
      final response = await _dio.post('${ApiConfig.bookings}/cancel/$bookingId');
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to cancel booking',
      );
    }
  }
  
  // ========== Tournaments ==========
  Future<ApiResponse<List<Tournament>>> getTournaments({String? status}) async {
    try {
      final response = await _dio.get(ApiConfig.tournaments, queryParameters: {
        if (status != null) 'status': status,
      });
      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List).map((e) => Tournament.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to get tournaments',
      );
    }
  }
  
  Future<ApiResponse<Tournament>> getTournament(int id) async {
    try {
      final response = await _dio.get('${ApiConfig.tournaments}/$id');
      return ApiResponse.fromJson(
        response.data,
        (data) => Tournament.fromJson(data),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to get tournament',
      );
    }
  }
  
  Future<ApiResponse> joinTournament(int tournamentId, String? teamName) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.tournaments}/$tournamentId/join',
        data: teamName != null ? '"$teamName"' : null,
      );
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to join tournament',
      );
    }
  }
  
  Future<ApiResponse<List<Match>>> getTournamentMatches(int tournamentId) async {
    try {
      final response = await _dio.get('${ApiConfig.tournaments}/$tournamentId/matches');
      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List).map((e) => Match.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to get matches',
      );
    }
  }
  
  // ========== Members ==========
  Future<ApiResponse<List<Member>>> getMembers({String? search, int page = 1}) async {
    try {
      final response = await _dio.get(ApiConfig.members, queryParameters: {
        if (search != null) 'search': search,
        'page': page,
      });
      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List).map((e) => Member.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to get members',
      );
    }
  }
  
  Future<ApiResponse<Member>> getMemberProfile(int id) async {
    try {
      final response = await _dio.get('${ApiConfig.members}/$id/profile');
      return ApiResponse.fromJson(
        response.data,
        (data) => Member.fromJson(data),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to get profile',
      );
    }
  }
  
  Future<ApiResponse<Member>> updateProfile({
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      final response = await _dio.put(ApiConfig.profile, data: {
        if (fullName != null) 'fullName': fullName,
        if (phone != null) 'phone': phone,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
      });
      return ApiResponse.fromJson(
        response.data,
        (data) => Member.fromJson(data),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to update profile',
      );
    }
  }
  
  // ========== Notifications ==========
  Future<ApiResponse<List<AppNotification>>> getNotifications({int page = 1}) async {
    try {
      final response = await _dio.get(ApiConfig.notifications, queryParameters: {
        'page': page,
      });
      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List).map((e) => AppNotification.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to get notifications',
      );
    }
  }
  
  Future<ApiResponse<int>> getUnreadCount() async {
    try {
      final response = await _dio.get(ApiConfig.unreadCount);
      return ApiResponse.fromJson(
        response.data,
        (data) => data as int,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to get unread count',
      );
    }
  }
  
  Future<ApiResponse> markAsRead(int notificationId) async {
    try {
      final response = await _dio.put('${ApiConfig.notifications}/$notificationId/read');
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to mark as read',
      );
    }
  }
  
  Future<ApiResponse> markAllAsRead() async {
    try {
      final response = await _dio.put('${ApiConfig.notifications}/read-all');
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to mark all as read',
      );
    }
  }
  
  // ========== News ==========
  Future<ApiResponse<List<News>>> getNews({int page = 1}) async {
    try {
      final response = await _dio.get(ApiConfig.news, queryParameters: {
        'page': page,
      });
      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List).map((e) => News.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? 'Failed to get news',
      );
    }
  }
  
  // ========== Health Check ==========
  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get(ApiConfig.health);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
