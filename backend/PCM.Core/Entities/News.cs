namespace PCM.Core.Entities;

/// <summary>
/// Tin tức / Thông báo CLB - 000_News
/// </summary>
public class News
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public bool IsPinned { get; set; } = false;
    public string? ImageUrl { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
    public string? CreatedBy { get; set; }
}
