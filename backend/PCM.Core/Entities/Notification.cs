using PCM.Core.Enums;

namespace PCM.Core.Entities;

/// <summary>
/// Thông báo - 000_Notifications
/// </summary>
public class Notification
{
    public int Id { get; set; }
    public int MemberId { get; set; }
    public string Message { get; set; } = string.Empty;
    public NotificationType Type { get; set; } = NotificationType.Info;
    public string? LinkUrl { get; set; }
    public bool IsRead { get; set; } = false;
    public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
    
    // Navigation
    public virtual Member Member { get; set; } = null!;
}
