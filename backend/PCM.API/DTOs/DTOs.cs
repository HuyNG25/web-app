namespace PCM.API.DTOs;

// ========== Auth DTOs ==========
public record LoginDto(string Email, string Password);
public record RegisterDto(string Email, string Password, string FullName, string? Phone);
public record AuthResponseDto(string Token, UserDto User);

public record UserDto(
    string Id,
    string Email,
    int MemberId,
    string FullName,
    decimal WalletBalance,
    string Tier,
    double RankLevel,
    string? AvatarUrl
);

// ========== Member DTOs ==========
public record MemberDto(
    int Id,
    string FullName,
    DateTime JoinDate,
    double RankLevel,
    bool IsActive,
    decimal WalletBalance,
    string Tier,
    decimal TotalSpent,
    string? AvatarUrl,
    string? Phone,
    string? Email
);

public record UpdateMemberDto(string? FullName, string? Phone, string? AvatarUrl);

// ========== Wallet DTOs ==========
public record DepositRequestDto(decimal Amount, string? ProofImageUrl);
public record TransactionDto(
    int Id,
    decimal Amount,
    string Type,
    string Status,
    string? Description,
    DateTime CreatedDate,
    DateTime? ProcessedDate
);

// ========== Court & Booking DTOs ==========
public record CourtDto(int Id, string Name, bool IsActive, string? Description, decimal PricePerHour);

public record BookingDto(
    int Id,
    int CourtId,
    string CourtName,
    int MemberId,
    string MemberName,
    DateTime StartTime,
    DateTime EndTime,
    decimal TotalPrice,
    string Status,
    bool IsRecurring,
    DateTime CreatedDate
);

public record CreateBookingDto(int CourtId, DateTime StartTime, DateTime EndTime);
public record RecurringBookingDto(int CourtId, DateTime StartTime, DateTime EndTime, string RecurrenceRule, DateTime UntilDate);

// ========== Tournament DTOs ==========
public record TournamentDto(
    int Id,
    string Name,
    DateTime StartDate,
    DateTime EndDate,
    string Format,
    decimal EntryFee,
    decimal PrizePool,
    string Status,
    int MaxParticipants,
    int CurrentParticipants,
    string? Description,
    string? ImageUrl
);

public record CreateTournamentDto(
    string Name,
    DateTime StartDate,
    DateTime EndDate,
    string Format,
    decimal EntryFee,
    decimal PrizePool,
    int MaxParticipants,
    string? Description
);

public record TournamentParticipantDto(
    int Id,
    int MemberId,
    string MemberName,
    string? TeamName,
    bool PaymentCompleted,
    int? Seed,
    DateTime RegisteredDate
);

// ========== Match DTOs ==========
public record MatchDto(
    int Id,
    int? TournamentId,
    string? RoundName,
    DateTime Date,
    string? Team1Player1Name,
    string? Team1Player2Name,
    string? Team2Player1Name,
    string? Team2Player2Name,
    int Score1,
    int Score2,
    string? Details,
    string WinningSide,
    string Status,
    string? CourtName
);

public record UpdateMatchResultDto(int Score1, int Score2, string? Details, string WinningSide);

// ========== Notification DTOs ==========
public record NotificationDto(
    int Id,
    string Message,
    string Type,
    string? LinkUrl,
    bool IsRead,
    DateTime CreatedDate
);

// ========== News DTOs ==========
public record NewsDto(
    int Id,
    string Title,
    string Content,
    bool IsPinned,
    string? ImageUrl,
    DateTime CreatedDate
);

public record CreateNewsDto(string Title, string Content, bool IsPinned, string? ImageUrl);

// ========== Dashboard DTOs ==========
public record DashboardDto(
    decimal WalletBalance,
    int UpcomingBookings,
    int ActiveTournaments,
    int UnreadNotifications,
    List<BookingDto> NextBookings,
    List<MatchDto> RecentMatches
);

// ========== Calendar DTOs ==========
public record CalendarSlotDto(
    int CourtId,
    string CourtName,
    DateTime StartTime,
    DateTime EndTime,
    bool IsBooked,
    int? BookingId,
    string? BookedByName,
    bool IsHold
);

// ========== API Response ==========
public record ApiResponse<T>(bool Success, string? Message, T? Data);
public record ApiResponse(bool Success, string? Message);
