using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using PCM.Core.Entities;

namespace PCM.Infrastructure.Data;

public class PcmDbContext : IdentityDbContext<IdentityUser>
{
    public PcmDbContext(DbContextOptions<PcmDbContext> options) : base(options)
    {
    }

    // Entities - Prefix 000 (thay bằng 3 số cuối MSSV)
    public DbSet<Member> Members { get; set; }
    public DbSet<WalletTransaction> WalletTransactions { get; set; }
    public DbSet<Court> Courts { get; set; }
    public DbSet<Booking> Bookings { get; set; }
    public DbSet<Tournament> Tournaments { get; set; }
    public DbSet<TournamentParticipant> TournamentParticipants { get; set; }
    public DbSet<Match> Matches { get; set; }
    public DbSet<Notification> Notifications { get; set; }
    public DbSet<News> News { get; set; }

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);

        // Table naming với prefix 000 (thay bằng MSSV)
        builder.Entity<Member>().ToTable("000_Members");
        builder.Entity<WalletTransaction>().ToTable("000_WalletTransactions");
        builder.Entity<Court>().ToTable("000_Courts");
        builder.Entity<Booking>().ToTable("000_Bookings");
        builder.Entity<Tournament>().ToTable("000_Tournaments");
        builder.Entity<TournamentParticipant>().ToTable("000_TournamentParticipants");
        builder.Entity<Match>().ToTable("000_Matches");
        builder.Entity<Notification>().ToTable("000_Notifications");
        builder.Entity<News>().ToTable("000_News");

        // Member
        builder.Entity<Member>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.WalletBalance).HasPrecision(18, 2);
            entity.Property(e => e.TotalSpent).HasPrecision(18, 2);
            entity.HasIndex(e => e.UserId).IsUnique();
        });

        // WalletTransaction
        builder.Entity<WalletTransaction>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Amount).HasPrecision(18, 2);
            entity.HasOne(e => e.Member)
                  .WithMany(m => m.WalletTransactions)
                  .HasForeignKey(e => e.MemberId)
                  .OnDelete(DeleteBehavior.Cascade);
        });

        // Court
        builder.Entity<Court>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.PricePerHour).HasPrecision(18, 2);
        });

        // Booking
        builder.Entity<Booking>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.TotalPrice).HasPrecision(18, 2);
            entity.HasOne(e => e.Court)
                  .WithMany(c => c.Bookings)
                  .HasForeignKey(e => e.CourtId)
                  .OnDelete(DeleteBehavior.Restrict);
            entity.HasOne(e => e.Member)
                  .WithMany(m => m.Bookings)
                  .HasForeignKey(e => e.MemberId)
                  .OnDelete(DeleteBehavior.Cascade);
            entity.HasOne(e => e.ParentBooking)
                  .WithMany(b => b.ChildBookings)
                  .HasForeignKey(e => e.ParentBookingId)
                  .OnDelete(DeleteBehavior.Restrict);
        });

        // Tournament
        builder.Entity<Tournament>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.EntryFee).HasPrecision(18, 2);
            entity.Property(e => e.PrizePool).HasPrecision(18, 2);
        });

        // TournamentParticipant
        builder.Entity<TournamentParticipant>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasOne(e => e.Tournament)
                  .WithMany(t => t.Participants)
                  .HasForeignKey(e => e.TournamentId)
                  .OnDelete(DeleteBehavior.Cascade);
            entity.HasOne(e => e.Member)
                  .WithMany(m => m.TournamentParticipations)
                  .HasForeignKey(e => e.MemberId)
                  .OnDelete(DeleteBehavior.Restrict);
            entity.HasIndex(e => new { e.TournamentId, e.MemberId }).IsUnique();
        });

        // Match
        builder.Entity<Match>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasOne(e => e.Tournament)
                  .WithMany(t => t.Matches)
                  .HasForeignKey(e => e.TournamentId)
                  .OnDelete(DeleteBehavior.Cascade);
            entity.HasOne(e => e.Team1Player1)
                  .WithMany()
                  .HasForeignKey(e => e.Team1Player1Id)
                  .OnDelete(DeleteBehavior.Restrict);
            entity.HasOne(e => e.Team1Player2)
                  .WithMany()
                  .HasForeignKey(e => e.Team1Player2Id)
                  .OnDelete(DeleteBehavior.Restrict);
            entity.HasOne(e => e.Team2Player1)
                  .WithMany()
                  .HasForeignKey(e => e.Team2Player1Id)
                  .OnDelete(DeleteBehavior.Restrict);
            entity.HasOne(e => e.Team2Player2)
                  .WithMany()
                  .HasForeignKey(e => e.Team2Player2Id)
                  .OnDelete(DeleteBehavior.Restrict);
            entity.HasOne(e => e.Court)
                  .WithMany()
                  .HasForeignKey(e => e.CourtId)
                  .OnDelete(DeleteBehavior.Restrict);
        });

        // Notification
        builder.Entity<Notification>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasOne(e => e.Member)
                  .WithMany(m => m.Notifications)
                  .HasForeignKey(e => e.MemberId)
                  .OnDelete(DeleteBehavior.Cascade);
        });

        // News
        builder.Entity<News>(entity =>
        {
            entity.HasKey(e => e.Id);
        });
    }
}
