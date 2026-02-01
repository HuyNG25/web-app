using PCM.Core.Enums;

namespace PCM.Core.Entities;

/// <summary>
/// Giao dịch ví điện tử - 000_WalletTransactions
/// </summary>
public class WalletTransaction
{
    public int Id { get; set; }
    public int MemberId { get; set; }
    public decimal Amount { get; set; } // + nạp/thưởng, - thanh toán/rút
    public TransactionType Type { get; set; }
    public TransactionStatus Status { get; set; } = TransactionStatus.Pending;
    public string? RelatedId { get; set; } // ID của Booking hoặc Tournament
    public string? Description { get; set; }
    public string? ProofImageUrl { get; set; } // Ảnh chứng minh chuyển khoản
    public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
    public DateTime? ProcessedDate { get; set; }
    public string? ProcessedBy { get; set; } // Admin/Thủ quỹ duyệt
    
    // Navigation
    public virtual Member Member { get; set; } = null!;
}
