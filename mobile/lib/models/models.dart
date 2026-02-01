// User & Auth models
class User {
  final String id;
  final String email;
  final int memberId;
  final String fullName;
  final double walletBalance;
  final String tier;
  final double rankLevel;
  final String? avatarUrl;

  User({
    required this.id,
    required this.email,
    required this.memberId,
    required this.fullName,
    required this.walletBalance,
    required this.tier,
    required this.rankLevel,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['Id'] ?? '',
      email: json['email'] ?? json['Email'] ?? '',
      memberId: json['memberId'] ?? json['MemberId'] ?? 0,
      fullName: json['fullName'] ?? json['FullName'] ?? '',
      walletBalance: (json['walletBalance'] ?? json['WalletBalance'] ?? 0).toDouble(),
      tier: json['tier'] ?? json['Tier'] ?? 'Standard',
      rankLevel: (json['rankLevel'] ?? json['RankLevel'] ?? 3.0).toDouble(),
      avatarUrl: json['avatarUrl'] ?? json['AvatarUrl'],
    );
  }
}

class AuthResponse {
  final String token;
  final User user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? json['Token'] ?? '',
      user: User.fromJson(json['user'] ?? json['User']),
    );
  }
}

// Member model
class Member {
  final int id;
  final String fullName;
  final DateTime joinDate;
  final double rankLevel;
  final bool isActive;
  final double walletBalance;
  final String tier;
  final double totalSpent;
  final String? avatarUrl;
  final String? phone;
  final String? email;

  Member({
    required this.id,
    required this.fullName,
    required this.joinDate,
    required this.rankLevel,
    required this.isActive,
    required this.walletBalance,
    required this.tier,
    required this.totalSpent,
    this.avatarUrl,
    this.phone,
    this.email,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] ?? json['Id'] ?? 0,
      fullName: json['fullName'] ?? json['FullName'] ?? '',
      joinDate: DateTime.tryParse(json['joinDate'] ?? json['JoinDate'] ?? '') ?? DateTime.now(),
      rankLevel: (json['rankLevel'] ?? json['RankLevel'] ?? 3.0).toDouble(),
      isActive: json['isActive'] ?? json['IsActive'] ?? true,
      walletBalance: (json['walletBalance'] ?? json['WalletBalance'] ?? 0).toDouble(),
      tier: json['tier'] ?? json['Tier'] ?? 'Standard',
      totalSpent: (json['totalSpent'] ?? json['TotalSpent'] ?? 0).toDouble(),
      avatarUrl: json['avatarUrl'] ?? json['AvatarUrl'],
      phone: json['phone'] ?? json['Phone'],
      email: json['email'] ?? json['Email'],
    );
  }
}

// Transaction model
class Transaction {
  final int id;
  final double amount;
  final String type;
  final String status;
  final String? description;
  final DateTime createdDate;
  final DateTime? processedDate;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    this.description,
    required this.createdDate,
    this.processedDate,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? json['Id'] ?? 0,
      amount: (json['amount'] ?? json['Amount'] ?? 0).toDouble(),
      type: json['type'] ?? json['Type'] ?? '',
      status: json['status'] ?? json['Status'] ?? '',
      description: json['description'] ?? json['Description'],
      createdDate: DateTime.tryParse(json['createdDate'] ?? json['CreatedDate'] ?? '') ?? DateTime.now(),
      processedDate: (json['processedDate'] ?? json['ProcessedDate']) != null 
          ? DateTime.tryParse(json['processedDate'] ?? json['ProcessedDate']) 
          : null,
    );
  }
  
  bool get isDeposit => amount > 0;
  bool get isPending => status == 'Pending';
  bool get isCompleted => status == 'Completed';
}

// Court model
class Court {
  final int id;
  final String name;
  final bool isActive;
  final String? description;
  final double pricePerHour;

  Court({
    required this.id,
    required this.name,
    required this.isActive,
    this.description,
    required this.pricePerHour,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      id: json['id'] ?? json['Id'] ?? 0,
      name: json['name'] ?? json['Name'] ?? '',
      isActive: json['isActive'] ?? json['IsActive'] ?? true,
      description: json['description'] ?? json['Description'],
      pricePerHour: (json['pricePerHour'] ?? json['PricePerHour'] ?? 0).toDouble(),
    );
  }
}

// Booking model
class Booking {
  final int id;
  final int courtId;
  final String courtName;
  final int memberId;
  final String memberName;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final String status;
  final bool isRecurring;
  final DateTime createdDate;

  Booking({
    required this.id,
    required this.courtId,
    required this.courtName,
    required this.memberId,
    required this.memberName,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
    required this.isRecurring,
    required this.createdDate,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? json['Id'] ?? 0,
      courtId: json['courtId'] ?? json['CourtId'] ?? 0,
      courtName: json['courtName'] ?? json['CourtName'] ?? '',
      memberId: json['memberId'] ?? json['MemberId'] ?? 0,
      memberName: json['memberName'] ?? json['MemberName'] ?? '',
      startTime: DateTime.tryParse(json['startTime'] ?? json['StartTime'] ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json['endTime'] ?? json['EndTime'] ?? '') ?? DateTime.now(),
      totalPrice: (json['totalPrice'] ?? json['TotalPrice'] ?? 0).toDouble(),
      status: json['status'] ?? json['Status'] ?? '',
      isRecurring: json['isRecurring'] ?? json['IsRecurring'] ?? false,
      createdDate: DateTime.tryParse(json['createdDate'] ?? json['CreatedDate'] ?? '') ?? DateTime.now(),
    );
  }
  
  Duration get duration => endTime.difference(startTime);
  bool get isUpcoming => startTime.isAfter(DateTime.now());
  bool get isConfirmed => status == 'Confirmed';
}

// Calendar slot model
class CalendarSlot {
  final int courtId;
  final String courtName;
  final DateTime startTime;
  final DateTime endTime;
  final bool isBooked;
  final int? bookingId;
  final String? bookedByName;
  final bool isHold;

  CalendarSlot({
    required this.courtId,
    required this.courtName,
    required this.startTime,
    required this.endTime,
    required this.isBooked,
    this.bookingId,
    this.bookedByName,
    required this.isHold,
  });

  factory CalendarSlot.fromJson(Map<String, dynamic> json) {
    return CalendarSlot(
      courtId: json['courtId'] ?? json['CourtId'] ?? 0,
      courtName: json['courtName'] ?? json['CourtName'] ?? '',
      startTime: DateTime.tryParse(json['startTime'] ?? json['StartTime'] ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json['endTime'] ?? json['EndTime'] ?? '') ?? DateTime.now(),
      isBooked: json['isBooked'] ?? json['IsBooked'] ?? false,
      bookingId: json['bookingId'] ?? json['BookingId'],
      bookedByName: json['bookedByName'] ?? json['BookedByName'],
      isHold: json['isHold'] ?? json['IsHold'] ?? false,
    );
  }
  
  bool get isAvailable => !isBooked && !isHold;
}

// Tournament model
class Tournament {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String format;
  final double entryFee;
  final double prizePool;
  final String status;
  final int maxParticipants;
  final int currentParticipants;
  final String? description;
  final String? imageUrl;

  Tournament({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.format,
    required this.entryFee,
    required this.prizePool,
    required this.status,
    required this.maxParticipants,
    required this.currentParticipants,
    this.description,
    this.imageUrl,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'] ?? json['Id'] ?? 0,
      name: json['name'] ?? json['Name'] ?? '',
      startDate: DateTime.tryParse(json['startDate'] ?? json['StartDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate'] ?? json['EndDate'] ?? '') ?? DateTime.now(),
      format: json['format'] ?? json['Format'] ?? '',
      entryFee: (json['entryFee'] ?? json['EntryFee'] ?? 0).toDouble(),
      prizePool: (json['prizePool'] ?? json['PrizePool'] ?? 0).toDouble(),
      status: json['status'] ?? json['Status'] ?? '',
      maxParticipants: json['maxParticipants'] ?? json['MaxParticipants'] ?? 0,
      currentParticipants: json['currentParticipants'] ?? json['CurrentParticipants'] ?? 0,
      description: json['description'] ?? json['Description'],
      imageUrl: json['imageUrl'] ?? json['ImageUrl'],
    );
  }
  
  bool get isOpen => status == 'Open' || status == 'Registering';
  bool get isFull => currentParticipants >= maxParticipants;
  int get spotsLeft => maxParticipants - currentParticipants;
}

// Match model
class Match {
  final int id;
  final int? tournamentId;
  final String? roundName;
  final DateTime date;
  final String? team1Player1Name;
  final String? team1Player2Name;
  final String? team2Player1Name;
  final String? team2Player2Name;
  final int score1;
  final int score2;
  final String? details;
  final String winningSide;
  final String status;
  final String? courtName;

  Match({
    required this.id,
    this.tournamentId,
    this.roundName,
    required this.date,
    this.team1Player1Name,
    this.team1Player2Name,
    this.team2Player1Name,
    this.team2Player2Name,
    required this.score1,
    required this.score2,
    this.details,
    required this.winningSide,
    required this.status,
    this.courtName,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] ?? json['Id'] ?? 0,
      tournamentId: json['tournamentId'] ?? json['TournamentId'],
      roundName: json['roundName'] ?? json['RoundName'],
      date: DateTime.tryParse(json['date'] ?? json['Date'] ?? '') ?? DateTime.now(),
      team1Player1Name: json['team1Player1Name'] ?? json['Team1Player1Name'],
      team1Player2Name: json['team1Player2Name'] ?? json['Team1Player2Name'],
      team2Player1Name: json['team2Player1Name'] ?? json['Team2Player1Name'],
      team2Player2Name: json['team2Player2Name'] ?? json['Team2Player2Name'],
      score1: json['score1'] ?? json['Score1'] ?? 0,
      score2: json['score2'] ?? json['Score2'] ?? 0,
      details: json['details'] ?? json['Details'],
      winningSide: json['winningSide'] ?? json['WinningSide'] ?? 'None',
      status: json['status'] ?? json['Status'] ?? '',
      courtName: json['courtName'] ?? json['CourtName'],
    );
  }
  
  String get team1Name {
    if (team1Player2Name != null) {
      return '$team1Player1Name / $team1Player2Name';
    }
    return team1Player1Name ?? 'TBD';
  }
  
  String get team2Name {
    if (team2Player2Name != null) {
      return '$team2Player1Name / $team2Player2Name';
    }
    return team2Player1Name ?? 'TBD';
  }
  
  String get scoreDisplay => '$score1 - $score2';
}

// Notification model
class AppNotification {
  final int id;
  final String message;
  final String type;
  final String? linkUrl;
  final bool isRead;
  final DateTime createdDate;

  AppNotification({
    required this.id,
    required this.message,
    required this.type,
    this.linkUrl,
    required this.isRead,
    required this.createdDate,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? json['Id'] ?? 0,
      message: json['message'] ?? json['Message'] ?? '',
      type: json['type'] ?? json['Type'] ?? 'Info',
      linkUrl: json['linkUrl'] ?? json['LinkUrl'],
      isRead: json['isRead'] ?? json['IsRead'] ?? false,
      createdDate: DateTime.tryParse(json['createdDate'] ?? json['CreatedDate'] ?? '') ?? DateTime.now(),
    );
  }
}

// News model
class News {
  final int id;
  final String title;
  final String content;
  final bool isPinned;
  final String? imageUrl;
  final DateTime createdDate;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.isPinned,
    this.imageUrl,
    required this.createdDate,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] ?? json['Id'] ?? 0,
      title: json['title'] ?? json['Title'] ?? '',
      content: json['content'] ?? json['Content'] ?? '',
      isPinned: json['isPinned'] ?? json['IsPinned'] ?? false,
      imageUrl: json['imageUrl'] ?? json['ImageUrl'],
      createdDate: DateTime.tryParse(json['createdDate'] ?? json['CreatedDate'] ?? '') ?? DateTime.now(),
    );
  }
}

// Dashboard model
class Dashboard {
  final double walletBalance;
  final int upcomingBookings;
  final int activeTournaments;
  final int unreadNotifications;
  final List<Booking> nextBookings;
  final List<Match> recentMatches;

  Dashboard({
    required this.walletBalance,
    required this.upcomingBookings,
    required this.activeTournaments,
    required this.unreadNotifications,
    required this.nextBookings,
    required this.recentMatches,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      walletBalance: (json['walletBalance'] ?? json['WalletBalance'] ?? 0).toDouble(),
      upcomingBookings: json['upcomingBookings'] ?? json['UpcomingBookings'] ?? 0,
      activeTournaments: json['activeTournaments'] ?? json['ActiveTournaments'] ?? 0,
      unreadNotifications: json['unreadNotifications'] ?? json['UnreadNotifications'] ?? 0,
      nextBookings: (json['nextBookings'] ?? json['NextBookings'] as List?)
          ?.map((e) => Booking.fromJson(e))
          .toList() ?? [],
      recentMatches: (json['recentMatches'] ?? json['RecentMatches'] as List?)
          ?.map((e) => Match.fromJson(e))
          .toList() ?? [],
    );
  }
}

// API Response wrapper
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T? Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] ?? json['Success'] ?? false,
      message: json['message'] ?? json['Message'],
      data: (json['data'] ?? json['Data']) != null && fromJsonT != null
          ? fromJsonT(json['data'] ?? json['Data'])
          : null,
    );
  }
}
