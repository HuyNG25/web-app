using PCM.Core.Enums;

namespace PCM.Core.Entities;

/// <summary>
/// Đặt sân - 000_Bookings
/// </summary>
public class Booking
{
    public int Id { get; set; }
    public int CourtId { get; set; }
    public int MemberId { get; set; }
    public DateTime StartTime { get; set; }
    public DateTime EndTime { get; set; }
    public decimal TotalPrice { get; set; }
    public int? TransactionId { get; set; } // Liên kết giao dịch trừ tiền
    public BookingStatus Status { get; set; } = BookingStatus.PendingPayment;
    
    // Recurring booking
    public bool IsRecurring { get; set; } = false;
    public string? RecurrenceRule { get; set; } // VD: "Weekly;Tue,Thu"
    public int? ParentBookingId { get; set; }
    
    // Hold slot
    public DateTime? HoldUntil { get; set; } // Giữ chỗ đến thời điểm này
    
    public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
    
    // Navigation
    public virtual Court Court { get; set; } = null!;
    public virtual Member Member { get; set; } = null!;
    public virtual Booking? ParentBooking { get; set; }
    public virtual ICollection<Booking> ChildBookings { get; set; } = new List<Booking>();
}
