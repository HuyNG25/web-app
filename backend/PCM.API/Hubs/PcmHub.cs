using Microsoft.AspNetCore.SignalR;

namespace PCM.API.Hubs;

public class PcmHub : Hub
{
    // Khi client kết nối, join vào group của user
    public override async Task OnConnectedAsync()
    {
        var memberId = Context.User?.FindFirst("MemberId")?.Value;
        if (!string.IsNullOrEmpty(memberId))
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, $"user_{memberId}");
        }
        await base.OnConnectedAsync();
    }

    // Join vào group của match để xem real-time score
    public async Task JoinMatchGroup(int matchId)
    {
        await Groups.AddToGroupAsync(Context.ConnectionId, $"match_{matchId}");
    }

    public async Task LeaveMatchGroup(int matchId)
    {
        await Groups.RemoveFromGroupAsync(Context.ConnectionId, $"match_{matchId}");
    }

    // Join vào group của tournament
    public async Task JoinTournamentGroup(int tournamentId)
    {
        await Groups.AddToGroupAsync(Context.ConnectionId, $"tournament_{tournamentId}");
    }

    public async Task LeaveTournamentGroup(int tournamentId)
    {
        await Groups.RemoveFromGroupAsync(Context.ConnectionId, $"tournament_{tournamentId}");
    }
}

// Extension methods để gửi notifications từ controllers
public static class HubExtensions
{
    public static async Task SendNotificationToUser(this IHubContext<PcmHub> hubContext, int memberId, string message, string type = "Info")
    {
        await hubContext.Clients.Group($"user_{memberId}").SendAsync("ReceiveNotification", new
        {
            message,
            type,
            createdDate = DateTime.UtcNow
        });
    }

    public static async Task UpdateCalendar(this IHubContext<PcmHub> hubContext)
    {
        await hubContext.Clients.All.SendAsync("UpdateCalendar");
    }

    public static async Task UpdateMatchScore(this IHubContext<PcmHub> hubContext, int matchId, int score1, int score2)
    {
        await hubContext.Clients.Group($"match_{matchId}").SendAsync("UpdateMatchScore", new
        {
            matchId,
            score1,
            score2,
            updatedAt = DateTime.UtcNow
        });
    }

    public static async Task UpdateTournament(this IHubContext<PcmHub> hubContext, int tournamentId)
    {
        await hubContext.Clients.Group($"tournament_{tournamentId}").SendAsync("UpdateTournament", new
        {
            tournamentId,
            updatedAt = DateTime.UtcNow
        });
    }
}
