namespace PCM.Core.Enums;

public enum MemberTier
{
    Standard = 0,
    Silver = 1,
    Gold = 2,
    Diamond = 3
}

public enum TransactionType
{
    Deposit = 0,      // Nạp tiền
    Withdraw = 1,     // Rút tiền
    Payment = 2,      // Thanh toán (đặt sân, phí giải)
    Refund = 3,       // Hoàn tiền
    Reward = 4        // Thưởng giải đấu
}

public enum TransactionStatus
{
    Pending = 0,
    Completed = 1,
    Rejected = 2,
    Failed = 3
}

public enum BookingStatus
{
    PendingPayment = 0,
    Confirmed = 1,
    Cancelled = 2,
    Completed = 3,
    Hold = 4          // Đang giữ chỗ 5 phút
}

public enum TournamentFormat
{
    RoundRobin = 0,   // Vòng tròn
    Knockout = 1,     // Loại trực tiếp
    Hybrid = 2        // Kết hợp
}

public enum TournamentStatus
{
    Open = 0,
    Registering = 1,
    DrawCompleted = 2,
    Ongoing = 3,
    Finished = 4
}

public enum MatchStatus
{
    Scheduled = 0,
    InProgress = 1,
    Finished = 2
}

public enum WinningSide
{
    None = 0,
    Team1 = 1,
    Team2 = 2
}

public enum NotificationType
{
    Info = 0,
    Success = 1,
    Warning = 2
}
