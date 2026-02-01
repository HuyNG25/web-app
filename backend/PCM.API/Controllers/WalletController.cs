using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PCM.API.DTOs;
using PCM.Core.Entities;
using PCM.Core.Enums;
using PCM.Infrastructure.Data;

namespace PCM.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class WalletController : ControllerBase
{
    private readonly PcmDbContext _context;

    public WalletController(PcmDbContext context)
    {
        _context = context;
    }

    private int GetMemberId() => int.Parse(User.FindFirstValue("MemberId")!);

    [HttpGet("balance")]
    public async Task<ActionResult<ApiResponse<decimal>>> GetBalance()
    {
        var member = await _context.Members.FindAsync(GetMemberId());
        if (member == null) return NotFound(new ApiResponse<decimal>(false, "Member not found", 0));

        return Ok(new ApiResponse<decimal>(true, null, member.WalletBalance));
    }

    [HttpPost("deposit")]
    public async Task<ActionResult<ApiResponse<TransactionDto>>> Deposit([FromBody] DepositRequestDto dto)
    {
        var memberId = GetMemberId();
        
        var transaction = new WalletTransaction
        {
            MemberId = memberId,
            Amount = dto.Amount,
            Type = TransactionType.Deposit,
            Status = TransactionStatus.Pending,
            ProofImageUrl = dto.ProofImageUrl,
            Description = $"Yêu cầu nạp {dto.Amount:N0}đ",
            CreatedDate = DateTime.UtcNow
        };

        _context.WalletTransactions.Add(transaction);
        await _context.SaveChangesAsync();

        var result = new TransactionDto(
            transaction.Id,
            transaction.Amount,
            transaction.Type.ToString(),
            transaction.Status.ToString(),
            transaction.Description,
            transaction.CreatedDate,
            transaction.ProcessedDate
        );

        return Ok(new ApiResponse<TransactionDto>(true, "Deposit request created. Waiting for approval.", result));
    }

    [HttpGet("transactions")]
    public async Task<ActionResult<ApiResponse<List<TransactionDto>>>> GetTransactions([FromQuery] int page = 1, [FromQuery] int pageSize = 20)
    {
        var memberId = GetMemberId();
        
        var transactions = await _context.WalletTransactions
            .Where(t => t.MemberId == memberId)
            .OrderByDescending(t => t.CreatedDate)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(t => new TransactionDto(
                t.Id,
                t.Amount,
                t.Type.ToString(),
                t.Status.ToString(),
                t.Description,
                t.CreatedDate,
                t.ProcessedDate
            ))
            .ToListAsync();

        return Ok(new ApiResponse<List<TransactionDto>>(true, null, transactions));
    }
}

[ApiController]
[Route("api/admin/wallet")]
[Authorize(Roles = "Admin,Treasurer")]
public class AdminWalletController : ControllerBase
{
    private readonly PcmDbContext _context;

    public AdminWalletController(PcmDbContext context)
    {
        _context = context;
    }

    [HttpGet("pending")]
    public async Task<ActionResult<ApiResponse<List<TransactionDto>>>> GetPendingDeposits()
    {
        var transactions = await _context.WalletTransactions
            .Where(t => t.Type == TransactionType.Deposit && t.Status == TransactionStatus.Pending)
            .OrderBy(t => t.CreatedDate)
            .Select(t => new TransactionDto(
                t.Id,
                t.Amount,
                t.Type.ToString(),
                t.Status.ToString(),
                t.Description,
                t.CreatedDate,
                t.ProcessedDate
            ))
            .ToListAsync();

        return Ok(new ApiResponse<List<TransactionDto>>(true, null, transactions));
    }

    [HttpPut("approve/{transactionId}")]
    public async Task<ActionResult<ApiResponse>> ApproveDeposit(int transactionId)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        
        await using var dbTransaction = await _context.Database.BeginTransactionAsync();
        try
        {
            var transaction = await _context.WalletTransactions
                .Include(t => t.Member)
                .FirstOrDefaultAsync(t => t.Id == transactionId);

            if (transaction == null)
                return NotFound(new ApiResponse(false, "Transaction not found"));

            if (transaction.Status != TransactionStatus.Pending)
                return BadRequest(new ApiResponse(false, "Transaction already processed"));

            // Update transaction status
            transaction.Status = TransactionStatus.Completed;
            transaction.ProcessedDate = DateTime.UtcNow;
            transaction.ProcessedBy = userId;

            // Add money to wallet
            transaction.Member.WalletBalance += transaction.Amount;
            transaction.Member.TotalSpent += transaction.Amount;

            // Update tier based on total spent
            transaction.Member.Tier = transaction.Member.TotalSpent switch
            {
                >= 50000000 => MemberTier.Diamond,
                >= 20000000 => MemberTier.Gold,
                >= 5000000 => MemberTier.Silver,
                _ => MemberTier.Standard
            };

            // Create notification
            _context.Notifications.Add(new Notification
            {
                MemberId = transaction.MemberId,
                Message = $"Nạp tiền thành công: +{transaction.Amount:N0}đ. Số dư mới: {transaction.Member.WalletBalance:N0}đ",
                Type = NotificationType.Success,
                CreatedDate = DateTime.UtcNow
            });

            await _context.SaveChangesAsync();
            await dbTransaction.CommitAsync();

            return Ok(new ApiResponse(true, "Deposit approved successfully"));
        }
        catch (Exception ex)
        {
            await dbTransaction.RollbackAsync();
            return StatusCode(500, new ApiResponse(false, $"Error: {ex.Message}"));
        }
    }

    [HttpPut("reject/{transactionId}")]
    public async Task<ActionResult<ApiResponse>> RejectDeposit(int transactionId)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        
        var transaction = await _context.WalletTransactions.FindAsync(transactionId);
        if (transaction == null)
            return NotFound(new ApiResponse(false, "Transaction not found"));

        if (transaction.Status != TransactionStatus.Pending)
            return BadRequest(new ApiResponse(false, "Transaction already processed"));

        transaction.Status = TransactionStatus.Rejected;
        transaction.ProcessedDate = DateTime.UtcNow;
        transaction.ProcessedBy = userId;

        // Create notification
        _context.Notifications.Add(new Notification
        {
            MemberId = transaction.MemberId,
            Message = $"Yêu cầu nạp tiền {transaction.Amount:N0}đ bị từ chối",
            Type = NotificationType.Warning,
            CreatedDate = DateTime.UtcNow
        });

        await _context.SaveChangesAsync();

        return Ok(new ApiResponse(true, "Deposit rejected"));
    }
}
