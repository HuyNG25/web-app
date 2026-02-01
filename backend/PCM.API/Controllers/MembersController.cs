using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PCM.API.DTOs;
using PCM.Infrastructure.Data;

namespace PCM.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class MembersController : ControllerBase
{
    private readonly PcmDbContext _context;

    public MembersController(PcmDbContext context)
    {
        _context = context;
    }

    private int GetMemberId() => int.Parse(User.FindFirstValue("MemberId")!);

    [HttpGet]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<List<MemberDto>>>> GetMembers(
        [FromQuery] string? search,
        [FromQuery] string? tier,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20)
    {
        var query = _context.Members.Where(m => m.IsActive);

        if (!string.IsNullOrEmpty(search))
            query = query.Where(m => m.FullName.Contains(search) || (m.Phone != null && m.Phone.Contains(search)));

        var members = await query
            .OrderByDescending(m => m.RankLevel)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(m => new MemberDto(
                m.Id, m.FullName, m.JoinDate, m.RankLevel, m.IsActive,
                m.WalletBalance, m.Tier.ToString(), m.TotalSpent,
                m.AvatarUrl, m.Phone, m.Email
            ))
            .ToListAsync();

        return Ok(new ApiResponse<List<MemberDto>>(true, null, members));
    }

    [HttpGet("{id}/profile")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<MemberDto>>> GetProfile(int id)
    {
        var member = await _context.Members.FindAsync(id);
        if (member == null)
            return NotFound(new ApiResponse<MemberDto>(false, "Member not found", null));

        var dto = new MemberDto(
            member.Id, member.FullName, member.JoinDate, member.RankLevel, member.IsActive,
            member.WalletBalance, member.Tier.ToString(), member.TotalSpent,
            member.AvatarUrl, member.Phone, member.Email
        );

        return Ok(new ApiResponse<MemberDto>(true, null, dto));
    }

    [HttpPut("profile")]
    public async Task<ActionResult<ApiResponse<MemberDto>>> UpdateProfile([FromBody] UpdateMemberDto dto)
    {
        var member = await _context.Members.FindAsync(GetMemberId());
        if (member == null)
            return NotFound(new ApiResponse<MemberDto>(false, "Member not found", null));

        if (!string.IsNullOrEmpty(dto.FullName)) member.FullName = dto.FullName;
        if (!string.IsNullOrEmpty(dto.Phone)) member.Phone = dto.Phone;
        if (!string.IsNullOrEmpty(dto.AvatarUrl)) member.AvatarUrl = dto.AvatarUrl;

        await _context.SaveChangesAsync();

        var result = new MemberDto(
            member.Id, member.FullName, member.JoinDate, member.RankLevel, member.IsActive,
            member.WalletBalance, member.Tier.ToString(), member.TotalSpent,
            member.AvatarUrl, member.Phone, member.Email
        );

        return Ok(new ApiResponse<MemberDto>(true, "Profile updated", result));
    }

    [HttpGet("dashboard")]
    public async Task<ActionResult<ApiResponse<DashboardDto>>> GetDashboard()
    {
        var memberId = GetMemberId();
        var member = await _context.Members.FindAsync(memberId);
        if (member == null)
            return NotFound(new ApiResponse<DashboardDto>(false, "Member not found", null));

        var upcomingBookings = await _context.Bookings
            .Include(b => b.Court)
            .Include(b => b.Member)
            .Where(b => b.MemberId == memberId && b.StartTime > DateTime.UtcNow)
            .OrderBy(b => b.StartTime)
            .Take(5)
            .ToListAsync();

        var recentMatches = await _context.Matches
            .Include(m => m.Team1Player1)
            .Include(m => m.Team2Player1)
            .Where(m => m.Team1Player1Id == memberId || m.Team2Player1Id == memberId)
            .OrderByDescending(m => m.Date)
            .Take(5)
            .ToListAsync();

        var unreadNotifications = await _context.Notifications
            .Where(n => n.MemberId == memberId && !n.IsRead)
            .CountAsync();

        var activeTournaments = await _context.Tournaments
            .Where(t => t.Status == Core.Enums.TournamentStatus.Open || t.Status == Core.Enums.TournamentStatus.Ongoing)
            .CountAsync();

        var dashboard = new DashboardDto(
            member.WalletBalance,
            upcomingBookings.Count,
            activeTournaments,
            unreadNotifications,
            upcomingBookings.Select(b => new BookingDto(
                b.Id, b.CourtId, b.Court.Name, b.MemberId, b.Member.FullName,
                b.StartTime, b.EndTime, b.TotalPrice, b.Status.ToString(),
                b.IsRecurring, b.CreatedDate
            )).ToList(),
            recentMatches.Select(m => new MatchDto(
                m.Id, m.TournamentId, m.RoundName, m.Date,
                m.Team1Player1?.FullName, null, m.Team2Player1?.FullName, null,
                m.Score1, m.Score2, m.Details, m.WinningSide.ToString(), m.Status.ToString(), null
            )).ToList()
        );

        return Ok(new ApiResponse<DashboardDto>(true, null, dashboard));
    }
}

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class NotificationsController : ControllerBase
{
    private readonly PcmDbContext _context;

    public NotificationsController(PcmDbContext context)
    {
        _context = context;
    }

    private int GetMemberId() => int.Parse(User.FindFirstValue("MemberId")!);

    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<NotificationDto>>>> GetNotifications([FromQuery] int page = 1, [FromQuery] int pageSize = 20)
    {
        var memberId = GetMemberId();

        var notifications = await _context.Notifications
            .Where(n => n.MemberId == memberId)
            .OrderByDescending(n => n.CreatedDate)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(n => new NotificationDto(
                n.Id, n.Message, n.Type.ToString(), n.LinkUrl, n.IsRead, n.CreatedDate
            ))
            .ToListAsync();

        return Ok(new ApiResponse<List<NotificationDto>>(true, null, notifications));
    }

    [HttpGet("unread-count")]
    public async Task<ActionResult<ApiResponse<int>>> GetUnreadCount()
    {
        var memberId = GetMemberId();
        var count = await _context.Notifications
            .Where(n => n.MemberId == memberId && !n.IsRead)
            .CountAsync();

        return Ok(new ApiResponse<int>(true, null, count));
    }

    [HttpPut("{id}/read")]
    public async Task<ActionResult<ApiResponse>> MarkAsRead(int id)
    {
        var memberId = GetMemberId();
        var notification = await _context.Notifications
            .FirstOrDefaultAsync(n => n.Id == id && n.MemberId == memberId);

        if (notification == null)
            return NotFound(new ApiResponse(false, "Notification not found"));

        notification.IsRead = true;
        await _context.SaveChangesAsync();

        return Ok(new ApiResponse(true, "Marked as read"));
    }

    [HttpPut("read-all")]
    public async Task<ActionResult<ApiResponse>> MarkAllAsRead()
    {
        var memberId = GetMemberId();
        await _context.Notifications
            .Where(n => n.MemberId == memberId && !n.IsRead)
            .ExecuteUpdateAsync(s => s.SetProperty(n => n.IsRead, true));

        return Ok(new ApiResponse(true, "All marked as read"));
    }
}

[ApiController]
[Route("api/[controller]")]
public class NewsController : ControllerBase
{
    private readonly PcmDbContext _context;

    public NewsController(PcmDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<NewsDto>>>> GetNews([FromQuery] int page = 1, [FromQuery] int pageSize = 10)
    {
        var news = await _context.News
            .OrderByDescending(n => n.IsPinned)
            .ThenByDescending(n => n.CreatedDate)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(n => new NewsDto(
                n.Id, n.Title, n.Content, n.IsPinned, n.ImageUrl, n.CreatedDate
            ))
            .ToListAsync();

        return Ok(new ApiResponse<List<NewsDto>>(true, null, news));
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ApiResponse<NewsDto>>> GetNewsById(int id)
    {
        var news = await _context.News.FindAsync(id);
        if (news == null)
            return NotFound(new ApiResponse<NewsDto>(false, "News not found", null));

        var dto = new NewsDto(news.Id, news.Title, news.Content, news.IsPinned, news.ImageUrl, news.CreatedDate);
        return Ok(new ApiResponse<NewsDto>(true, null, dto));
    }
}
