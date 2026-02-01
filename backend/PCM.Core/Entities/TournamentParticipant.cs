namespace PCM.Core.Entities;

/// <summary>
/// Người tham gia giải đấu - 000_TournamentParticipants
/// </summary>
public class TournamentParticipant
{
    public int Id { get; set; }
    public int TournamentId { get; set; }
    public int MemberId { get; set; }
    public string? TeamName { get; set; } // Tên đội (nếu đánh đôi)
    public int? PartnerId { get; set; } // Đồng đội (nếu đánh đôi)
    public bool PaymentCompleted { get; set; } = false;
    public int? Seed { get; set; } // Hạt giống
    public DateTime RegisteredDate { get; set; } = DateTime.UtcNow;
    
    // Navigation
    public virtual Tournament Tournament { get; set; } = null!;
    public virtual Member Member { get; set; } = null!;
    public virtual Member? Partner { get; set; }
}
