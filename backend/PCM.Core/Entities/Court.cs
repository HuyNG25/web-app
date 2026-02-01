namespace PCM.Core.Entities;

/// <summary>
/// Sân pickleball - 000_Courts
/// </summary>
public class Court
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty; // Sân 1, Sân 2...
    public bool IsActive { get; set; } = true;
    public string? Description { get; set; }
    public decimal PricePerHour { get; set; } = 100000; // Giá thuê/giờ
    
    // Navigation
    public virtual ICollection<Booking> Bookings { get; set; } = new List<Booking>();
}
