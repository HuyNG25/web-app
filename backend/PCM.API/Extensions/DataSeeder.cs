using Microsoft.AspNetCore.Identity;
using PCM.Core.Entities;
using PCM.Core.Enums;
using PCM.Infrastructure.Data;

namespace PCM.API.Extensions;

public static class DataSeeder
{
    public static async Task SeedDataAsync(IServiceProvider serviceProvider)
    {
        using var scope = serviceProvider.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<PcmDbContext>();
        var userManager = scope.ServiceProvider.GetRequiredService<UserManager<IdentityUser>>();
        var roleManager = scope.ServiceProvider.GetRequiredService<RoleManager<IdentityRole>>();

        // Create roles
        string[] roles = { "Admin", "Treasurer", "Referee", "Member" };
        foreach (var role in roles)
        {
            if (!await roleManager.RoleExistsAsync(role))
                await roleManager.CreateAsync(new IdentityRole(role));
        }

        // Seed Admin
        if (!context.Members.Any())
        {
            // Admin
            var adminUser = new IdentityUser { UserName = "admin@pcm.vn", Email = "admin@pcm.vn", EmailConfirmed = true };
            await userManager.CreateAsync(adminUser, "Admin@123");
            await userManager.AddToRoleAsync(adminUser, "Admin");
            context.Members.Add(new Member
            {
                FullName = "Quản trị viên",
                UserId = adminUser.Id,
                Email = "admin@pcm.vn",
                RankLevel = 5.5,
                WalletBalance = 10000000,
                Tier = MemberTier.Diamond
            });

            // Treasurer
            var treasurerUser = new IdentityUser { UserName = "treasurer@pcm.vn", Email = "treasurer@pcm.vn", EmailConfirmed = true };
            await userManager.CreateAsync(treasurerUser, "Treasurer@123");
            await userManager.AddToRoleAsync(treasurerUser, "Treasurer");
            context.Members.Add(new Member
            {
                FullName = "Thủ quỹ CLB",
                UserId = treasurerUser.Id,
                Email = "treasurer@pcm.vn",
                RankLevel = 4.5,
                WalletBalance = 5000000,
                Tier = MemberTier.Gold
            });

            // Referee
            var refereeUser = new IdentityUser { UserName = "referee@pcm.vn", Email = "referee@pcm.vn", EmailConfirmed = true };
            await userManager.CreateAsync(refereeUser, "Referee@123");
            await userManager.AddToRoleAsync(refereeUser, "Referee");
            context.Members.Add(new Member
            {
                FullName = "Trọng tài CLB",
                UserId = refereeUser.Id,
                Email = "referee@pcm.vn",
                RankLevel = 4.0,
                WalletBalance = 3000000,
                Tier = MemberTier.Silver
            });

            // 20 Members with varying ranks and tiers
            var random = new Random();
            var names = new[] { "Nguyễn Văn An", "Trần Thị Bình", "Lê Văn Cường", "Phạm Thị Dung", "Hoàng Văn Em",
                "Vũ Thị Phương", "Đỗ Văn Giang", "Bùi Thị Hoa", "Ngô Văn Hùng", "Dương Thị Kim",
                "Lý Văn Long", "Mai Thị Nhung", "Trương Văn Phú", "Đinh Thị Quỳnh", "Cao Văn Sơn",
                "Phan Thị Trang", "Hồ Văn Tuấn", "Lưu Thị Uyên", "Tạ Văn Việt", "Châu Thị Yến" };

            for (int i = 0; i < names.Length; i++)
            {
                var email = $"member{i + 1}@pcm.vn";
                var user = new IdentityUser { UserName = email, Email = email, EmailConfirmed = true };
                await userManager.CreateAsync(user, "Member@123");
                await userManager.AddToRoleAsync(user, "Member");

                var rank = 2.5 + random.NextDouble() * 3.5; // 2.5 - 6.0
                var balance = random.Next(2000000, 10000000);
                var tier = balance switch
                {
                    >= 8000000 => MemberTier.Diamond,
                    >= 5000000 => MemberTier.Gold,
                    >= 3000000 => MemberTier.Silver,
                    _ => MemberTier.Standard
                };

                context.Members.Add(new Member
                {
                    FullName = names[i],
                    UserId = user.Id,
                    Email = email,
                    Phone = $"09{random.Next(10000000, 99999999)}",
                    RankLevel = Math.Round(rank, 2),
                    WalletBalance = balance,
                    TotalSpent = balance / 2,
                    Tier = tier
                });
            }

            await context.SaveChangesAsync();
        }

        // Seed Courts
        if (!context.Courts.Any())
        {
            context.Courts.AddRange(
                new Court { Name = "Sân 1", Description = "Sân chính - Indoor", PricePerHour = 150000, IsActive = true },
                new Court { Name = "Sân 2", Description = "Sân phụ - Indoor", PricePerHour = 120000, IsActive = true },
                new Court { Name = "Sân 3", Description = "Sân ngoài trời", PricePerHour = 100000, IsActive = true },
                new Court { Name = "Sân 4", Description = "Sân VIP", PricePerHour = 200000, IsActive = true }
            );
            await context.SaveChangesAsync();
        }

        // Seed Tournaments
        if (!context.Tournaments.Any())
        {
            context.Tournaments.AddRange(
                new Tournament
                {
                    Name = "Summer Open 2026",
                    StartDate = DateTime.UtcNow.AddMonths(-2),
                    EndDate = DateTime.UtcNow.AddMonths(-1),
                    Format = TournamentFormat.Knockout,
                    EntryFee = 200000,
                    PrizePool = 5000000,
                    MaxParticipants = 16,
                    Status = TournamentStatus.Finished,
                    Description = "Giải đấu mùa hè 2026 - Đã kết thúc"
                },
                new Tournament
                {
                    Name = "Winter Cup 2026",
                    StartDate = DateTime.UtcNow.AddDays(14),
                    EndDate = DateTime.UtcNow.AddDays(21),
                    Format = TournamentFormat.Hybrid,
                    EntryFee = 300000,
                    PrizePool = 10000000,
                    MaxParticipants = 32,
                    Status = TournamentStatus.Open,
                    Description = "Giải đấu mùa đông 2026 - Đang mở đăng ký"
                }
            );
            await context.SaveChangesAsync();
        }

        // Seed News
        if (!context.News.Any())
        {
            context.News.AddRange(
                new News
                {
                    Title = "Chào mừng đến với CLB Vợt Thủ Phố Núi!",
                    Content = "CLB Pickleball Vợt Thủ Phố Núi chính thức ra mắt ứng dụng di động. Hãy tải app và đặt sân ngay!",
                    IsPinned = true,
                    CreatedDate = DateTime.UtcNow
                },
                new News
                {
                    Title = "Giải Winter Cup 2026 sắp khởi tranh",
                    Content = "Đăng ký tham gia giải Winter Cup 2026 với tổng giải thưởng lên đến 10 triệu đồng!",
                    IsPinned = false,
                    CreatedDate = DateTime.UtcNow.AddDays(-1)
                }
            );
            await context.SaveChangesAsync();
        }
    }
}
