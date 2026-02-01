using PCM.Core.Enums;

namespace PCM.Core.Entities;

/// <summary>
/// Trận đấu - 000_Matches
/// </summary>
public class Match
{
    public int Id { get; set; }
    public int? TournamentId { get; set; }
    public string? RoundName { get; set; } // "Group A", "Quarter Final", "Semi Final", "Final"
    public DateTime Date { get; set; }
    public DateTime? StartTime { get; set; }
    
    // Team 1
    public int? Team1Player1Id { get; set; }
    public int? Team1Player2Id { get; set; }
    
    // Team 2
    public int? Team2Player1Id { get; set; }
    public int? Team2Player2Id { get; set; }
    
    // Result
    public int Score1 { get; set; } = 0;
    public int Score2 { get; set; } = 0;
    public string? Details { get; set; } // Chi tiết set: "11-9, 5-11, 11-8"
    public WinningSide WinningSide { get; set; } = WinningSide.None;
    
    public bool IsRanked { get; set; } = true; // Có tính điểm DUPR không
    public MatchStatus Status { get; set; } = MatchStatus.Scheduled;
    
    public int? CourtId { get; set; }
    
    // Navigation
    public virtual Tournament? Tournament { get; set; }
    public virtual Member? Team1Player1 { get; set; }
    public virtual Member? Team1Player2 { get; set; }
    public virtual Member? Team2Player1 { get; set; }
    public virtual Member? Team2Player2 { get; set; }
    public virtual Court? Court { get; set; }
}
