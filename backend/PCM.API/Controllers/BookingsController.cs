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
public class CourtsController : ControllerBase
{
    private readonly PcmDbContext _context;

    public CourtsController(PcmDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<CourtDto>>>> GetCourts()
    {
        var courts = await _context.Courts
            .Where(c => c.IsActive)
            .Select(c => new CourtDto(c.Id, c.Name, c.IsActive, c.Description, c.PricePerHour))
            .ToListAsync();

        return Ok(new ApiResponse<List<CourtDto>>(true, null, courts));
    }
}

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class BookingsController : ControllerBase
{
    private readonly PcmDbContext _context;

    public BookingsController(PcmDbContext context)
    {
        _context = context;
    }

    private int GetMemberId() => int.Parse(User.FindFirstValue("MemberId")!);

    [HttpGet("calendar")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<List<CalendarSlotDto>>>> GetCalendar([FromQuery] DateTime from, [FromQuery] DateTime to, [FromQuery] int? courtId)
    {
        var bookingsQuery = _context.Bookings
            .Include(b => b.Court)
            .Include(b => b.Member)
            .Where(b => b.StartTime >= from && b.EndTime <= to)
            .Where(b => b.Status == BookingStatus.Confirmed || b.Status == BookingStatus.Hold);

        if (courtId.HasValue)
            bookingsQuery = bookingsQuery.Where(b => b.CourtId == courtId.Value);

        var bookings = await bookingsQuery.ToListAsync();
        var courts = await _context.Courts.Where(c => c.IsActive).ToListAsync();

        var slots = new List<CalendarSlotDto>();
        
        // Generate time slots for each court (6:00 - 22:00, 1 hour slots)
        foreach (var court in courts)
        {
            for (var date = from.Date; date <= to.Date; date = date.AddDays(1))
            {
                for (var hour = 6; hour < 22; hour++)
                {
                    var startTime = date.AddHours(hour);
                    var endTime = startTime.AddHours(1);

                    var booking = bookings.FirstOrDefault(b => 
                        b.CourtId == court.Id && 
                        b.StartTime <= startTime && 
                        b.EndTime > startTime);

                    slots.Add(new CalendarSlotDto(
                        court.Id,
                        court.Name,
                        startTime,
                        endTime,
                        booking != null,
                        booking?.Id,
                        booking?.Member.FullName,
                        booking?.Status == BookingStatus.Hold
                    ));
                }
            }
        }

        return Ok(new ApiResponse<List<CalendarSlotDto>>(true, null, slots));
    }

    [HttpPost]
    public async Task<ActionResult<ApiResponse<BookingDto>>> CreateBooking([FromBody] CreateBookingDto dto)
    {
        var memberId = GetMemberId();
        var member = await _context.Members.FindAsync(memberId);
        var court = await _context.Courts.FindAsync(dto.CourtId);

        if (member == null || court == null)
            return NotFound(new ApiResponse<BookingDto>(false, "Member or Court not found", null));

        // Check for conflicts
        var conflict = await _context.Bookings
            .Where(b => b.CourtId == dto.CourtId)
            .Where(b => b.Status == BookingStatus.Confirmed || b.Status == BookingStatus.Hold)
            .Where(b => b.StartTime < dto.EndTime && b.EndTime > dto.StartTime)
            .AnyAsync();

        if (conflict)
            return BadRequest(new ApiResponse<BookingDto>(false, "Time slot already booked", null));

        // Calculate price
        var hours = (decimal)(dto.EndTime - dto.StartTime).TotalHours;
        var totalPrice = hours * court.PricePerHour;

        // Check wallet balance
        if (member.WalletBalance < totalPrice)
            return BadRequest(new ApiResponse<BookingDto>(false, $"Insufficient balance. Need {totalPrice:N0}đ, have {member.WalletBalance:N0}đ", null));

        await using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            // Create booking
            var booking = new Booking
            {
                CourtId = dto.CourtId,
                MemberId = memberId,
                StartTime = dto.StartTime,
                EndTime = dto.EndTime,
                TotalPrice = totalPrice,
                Status = BookingStatus.Confirmed,
                CreatedDate = DateTime.UtcNow
            };
            _context.Bookings.Add(booking);

            // Deduct from wallet
            member.WalletBalance -= totalPrice;

            // Create transaction record
            var walletTransaction = new WalletTransaction
            {
                MemberId = memberId,
                Amount = -totalPrice,
                Type = TransactionType.Payment,
                Status = TransactionStatus.Completed,
                Description = $"Đặt sân {court.Name}: {dto.StartTime:dd/MM/yyyy HH:mm} - {dto.EndTime:HH:mm}",
                CreatedDate = DateTime.UtcNow,
                ProcessedDate = DateTime.UtcNow
            };
            _context.WalletTransactions.Add(walletTransaction);

            await _context.SaveChangesAsync();
            
            booking.TransactionId = walletTransaction.Id;
            await _context.SaveChangesAsync();
            
            await transaction.CommitAsync();

            var result = new BookingDto(
                booking.Id,
                booking.CourtId,
                court.Name,
                booking.MemberId,
                member.FullName,
                booking.StartTime,
                booking.EndTime,
                booking.TotalPrice,
                booking.Status.ToString(),
                booking.IsRecurring,
                booking.CreatedDate
            );

            return Ok(new ApiResponse<BookingDto>(true, "Booking created successfully", result));
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
            return StatusCode(500, new ApiResponse<BookingDto>(false, $"Error: {ex.Message}", null));
        }
    }

    [HttpGet("my")]
    public async Task<ActionResult<ApiResponse<List<BookingDto>>>> GetMyBookings([FromQuery] DateTime? from, [FromQuery] DateTime? to)
    {
        var memberId = GetMemberId();
        
        var query = _context.Bookings
            .Include(b => b.Court)
            .Include(b => b.Member)
            .Where(b => b.MemberId == memberId);

        if (from.HasValue) query = query.Where(b => b.StartTime >= from.Value);
        if (to.HasValue) query = query.Where(b => b.EndTime <= to.Value);

        var bookings = await query
            .OrderByDescending(b => b.StartTime)
            .Select(b => new BookingDto(
                b.Id,
                b.CourtId,
                b.Court.Name,
                b.MemberId,
                b.Member.FullName,
                b.StartTime,
                b.EndTime,
                b.TotalPrice,
                b.Status.ToString(),
                b.IsRecurring,
                b.CreatedDate
            ))
            .ToListAsync();

        return Ok(new ApiResponse<List<BookingDto>>(true, null, bookings));
    }

    [HttpPost("cancel/{id}")]
    public async Task<ActionResult<ApiResponse>> CancelBooking(int id)
    {
        var memberId = GetMemberId();
        var booking = await _context.Bookings
            .Include(b => b.Member)
            .FirstOrDefaultAsync(b => b.Id == id && b.MemberId == memberId);

        if (booking == null)
            return NotFound(new ApiResponse(false, "Booking not found"));

        if (booking.Status != BookingStatus.Confirmed)
            return BadRequest(new ApiResponse(false, "Cannot cancel this booking"));

        // Refund policy: 100% if > 24h before, 50% if > 1h, 0% otherwise
        var hoursUntil = (booking.StartTime - DateTime.UtcNow).TotalHours;
        decimal refundPercent = hoursUntil switch
        {
            > 24 => 1.0m,
            > 1 => 0.5m,
            _ => 0
        };

        var refundAmount = booking.TotalPrice * refundPercent;

        booking.Status = BookingStatus.Cancelled;
        booking.Member.WalletBalance += refundAmount;

        if (refundAmount > 0)
        {
            _context.WalletTransactions.Add(new WalletTransaction
            {
                MemberId = memberId,
                Amount = refundAmount,
                Type = TransactionType.Refund,
                Status = TransactionStatus.Completed,
                Description = $"Hoàn tiền hủy sân: {refundPercent:P0} của {booking.TotalPrice:N0}đ",
                CreatedDate = DateTime.UtcNow,
                ProcessedDate = DateTime.UtcNow
            });
        }

        await _context.SaveChangesAsync();

        return Ok(new ApiResponse(true, $"Booking cancelled. Refunded {refundAmount:N0}đ ({refundPercent:P0})"));
    }
}
