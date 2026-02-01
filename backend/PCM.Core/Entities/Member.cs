using PCM.Core.Enums;

namespace PCM.Core.Entities;

/// <summary>
/// Hội viên CLB - 000_Members (thay 000 bằng 3 số cuối MSSV)
/// </summary>
public class Member
{
    public int Id { get; set; }
    public string FullName { get; set; } = string.Empty;
    public DateTime JoinDate { get; set; } = DateTime.UtcNow;
    public double RankLevel { get; set; } = 3.0; // DUPR Rating (2.0 - 6.0+)
    public bool IsActive { get; set; } = true;
    
    // Wallet
    public decimal WalletBalance { get; set; } = 0;
    public MemberTier Tier { get; set; } = MemberTier.Standard;
    public decimal TotalSpent { get; set; } = 0;
    
    // Profile
    public string? AvatarUrl { get; set; }
    public string? Phone { get; set; }
    public string? Email { get; set; }
    
    // Identity link
    public string UserId { get; set; } = string.Empty;
    
    // Navigation
    public virtual ICollection<WalletTransaction> WalletTransactions { get; set; } = new List<WalletTransaction>();
    public virtual ICollection<Booking> Bookings { get; set; } = new List<Booking>();
    public virtual ICollection<TournamentParticipant> TournamentParticipations { get; set; } = new List<TournamentParticipant>();
    public virtual ICollection<Notification> Notifications { get; set; } = new List<Notification>();
}
