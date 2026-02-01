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
public class TournamentsController : ControllerBase
{
    private readonly PcmDbContext _context;

    public TournamentsController(PcmDbContext context)
    {
        _context = context;
    }

    private int? GetMemberIdOrNull()
    {
        var claim = User.FindFirstValue("MemberId");
        return claim != null ? int.Parse(claim) : null;
    }

    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<TournamentDto>>>> GetTournaments([FromQuery] string? status)
    {
        var query = _context.Tournaments.AsQueryable();

        if (!string.IsNullOrEmpty(status) && Enum.TryParse<TournamentStatus>(status, out var statusEnum))
            query = query.Where(t => t.Status == statusEnum);

        var tournaments = await query
            .OrderByDescending(t => t.StartDate)
            .Select(t => new TournamentDto(
                t.Id,
                t.Name,
                t.StartDate,
                t.EndDate,
                t.Format.ToString(),
                t.EntryFee,
                t.PrizePool,
                t.Status.ToString(),
                t.MaxParticipants,
                t.Participants.Count,
                t.Description,
                t.ImageUrl
            ))
            .ToListAsync();

        return Ok(new ApiResponse<List<TournamentDto>>(true, null, tournaments));
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ApiResponse<TournamentDto>>> GetTournament(int id)
    {
        var t = await _context.Tournaments
            .Include(t => t.Participants)
            .FirstOrDefaultAsync(t => t.Id == id);

        if (t == null)
            return NotFound(new ApiResponse<TournamentDto>(false, "Tournament not found", null));

        var dto = new TournamentDto(
            t.Id, t.Name, t.StartDate, t.EndDate, t.Format.ToString(),
            t.EntryFee, t.PrizePool, t.Status.ToString(),
            t.MaxParticipants, t.Participants.Count, t.Description, t.ImageUrl
        );

        return Ok(new ApiResponse<TournamentDto>(true, null, dto));
    }

    [HttpGet("{id}/participants")]
    public async Task<ActionResult<ApiResponse<List<TournamentParticipantDto>>>> GetParticipants(int id)
    {
        var participants = await _context.TournamentParticipants
            .Include(p => p.Member)
            .Where(p => p.TournamentId == id)
            .Select(p => new TournamentParticipantDto(
                p.Id, p.MemberId, p.Member.FullName, p.TeamName,
                p.PaymentCompleted, p.Seed, p.RegisteredDate
            ))
            .ToListAsync();

        return Ok(new ApiResponse<List<TournamentParticipantDto>>(true, null, participants));
    }

    [HttpPost("{id}/join")]
    [Authorize]
    public async Task<ActionResult<ApiResponse>> JoinTournament(int id, [FromBody] string? teamName)
    {
        var memberId = int.Parse(User.FindFirstValue("MemberId")!);
        var member = await _context.Members.FindAsync(memberId);
        var tournament = await _context.Tournaments
            .Include(t => t.Participants)
            .FirstOrDefaultAsync(t => t.Id == id);

        if (member == null || tournament == null)
            return NotFound(new ApiResponse(false, "Member or Tournament not found"));

        if (tournament.Status != TournamentStatus.Open && tournament.Status != TournamentStatus.Registering)
            return BadRequest(new ApiResponse(false, "Tournament is not accepting registrations"));

        if (tournament.Participants.Count >= tournament.MaxParticipants)
            return BadRequest(new ApiResponse(false, "Tournament is full"));

        if (tournament.Participants.Any(p => p.MemberId == memberId))
            return BadRequest(new ApiResponse(false, "Already registered"));

        if (member.WalletBalance < tournament.EntryFee)
            return BadRequest(new ApiResponse(false, $"Insufficient balance. Need {tournament.EntryFee:N0}đ"));

        await using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            // Deduct entry fee
            member.WalletBalance -= tournament.EntryFee;

            _context.WalletTransactions.Add(new WalletTransaction
            {
                MemberId = memberId,
                Amount = -tournament.EntryFee,
                Type = TransactionType.Payment,
                Status = TransactionStatus.Completed,
                RelatedId = tournament.Id.ToString(),
                Description = $"Phí tham gia giải: {tournament.Name}",
                CreatedDate = DateTime.UtcNow,
                ProcessedDate = DateTime.UtcNow
            });

            // Register
            _context.TournamentParticipants.Add(new TournamentParticipant
            {
                TournamentId = id,
                MemberId = memberId,
                TeamName = teamName,
                PaymentCompleted = true,
                RegisteredDate = DateTime.UtcNow
            });

            await _context.SaveChangesAsync();
            await transaction.CommitAsync();

            return Ok(new ApiResponse(true, "Successfully joined tournament"));
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
            return StatusCode(500, new ApiResponse(false, ex.Message));
        }
    }

    [HttpGet("{id}/matches")]
    public async Task<ActionResult<ApiResponse<List<MatchDto>>>> GetMatches(int id)
    {
        var matches = await _context.Matches
            .Include(m => m.Team1Player1)
            .Include(m => m.Team1Player2)
            .Include(m => m.Team2Player1)
            .Include(m => m.Team2Player2)
            .Include(m => m.Court)
            .Where(m => m.TournamentId == id)
            .OrderBy(m => m.Date)
            .ThenBy(m => m.RoundName)
            .Select(m => new MatchDto(
                m.Id, m.TournamentId, m.RoundName, m.Date,
                m.Team1Player1!.FullName, m.Team1Player2 != null ? m.Team1Player2.FullName : null,
                m.Team2Player1!.FullName, m.Team2Player2 != null ? m.Team2Player2.FullName : null,
                m.Score1, m.Score2, m.Details, m.WinningSide.ToString(), m.Status.ToString(),
                m.Court != null ? m.Court.Name : null
            ))
            .ToListAsync();

        return Ok(new ApiResponse<List<MatchDto>>(true, null, matches));
    }

    [HttpPost]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<ApiResponse<TournamentDto>>> CreateTournament([FromBody] CreateTournamentDto dto)
    {
        if (!Enum.TryParse<TournamentFormat>(dto.Format, out var format))
            return BadRequest(new ApiResponse<TournamentDto>(false, "Invalid format", null));

        var tournament = new Tournament
        {
            Name = dto.Name,
            StartDate = dto.StartDate,
            EndDate = dto.EndDate,
            Format = format,
            EntryFee = dto.EntryFee,
            PrizePool = dto.PrizePool,
            MaxParticipants = dto.MaxParticipants,
            Description = dto.Description,
            Status = TournamentStatus.Open,
            CreatedDate = DateTime.UtcNow
        };

        _context.Tournaments.Add(tournament);
        await _context.SaveChangesAsync();

        var result = new TournamentDto(
            tournament.Id, tournament.Name, tournament.StartDate, tournament.EndDate,
            tournament.Format.ToString(), tournament.EntryFee, tournament.PrizePool,
            tournament.Status.ToString(), tournament.MaxParticipants, 0, tournament.Description, null
        );

        return Ok(new ApiResponse<TournamentDto>(true, "Tournament created", result));
    }
}
