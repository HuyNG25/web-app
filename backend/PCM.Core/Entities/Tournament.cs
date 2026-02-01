using PCM.Core.Enums;

namespace PCM.Core.Entities;

/// <summary>
/// Giải đấu - 000_Tournaments
/// </summary>
public class Tournament
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public TournamentFormat Format { get; set; } = TournamentFormat.Knockout;
    public decimal EntryFee { get; set; } = 0;
    public decimal PrizePool { get; set; } = 0;
    public TournamentStatus Status { get; set; } = TournamentStatus.Open;
    public string? Settings { get; set; } // JSON: số bảng, số đội vào vòng trong...
    public string? Description { get; set; }
    public string? ImageUrl { get; set; }
    public int MaxParticipants { get; set; } = 32;
    
    public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
    
    // Navigation
    public virtual ICollection<TournamentParticipant> Participants { get; set; } = new List<TournamentParticipant>();
    public virtual ICollection<Match> Matches { get; set; } = new List<Match>();
}
