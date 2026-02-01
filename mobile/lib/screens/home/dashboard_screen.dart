import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../notifications/notification_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<DashboardProvider>().refresh();
          await context.read<AuthProvider>().refreshUser();
        },
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.white,
                                child: user?.avatarUrl != null
                                    ? ClipOval(
                                        child: Image.network(
                                          user!.avatarUrl!,
                                          fit: BoxFit.cover,
                                          width: 56,
                                          height: 56,
                                        ),
                                      )
                                    : Text(
                                        user?.fullName.isNotEmpty == true
                                            ? user!.fullName[0].toUpperCase()
                                            : 'U',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Xin chào,',
                                      style: TextStyle(
                                        color: Colors.white.withAlpha(200),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      user?.fullName ?? 'Member',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Notification bell
                              Consumer<NotificationProvider>(
                                builder: (context, notif, _) {
                                  return IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const NotificationScreen(),
                                        ),
                                      );
                                    },
                                    icon: Badge(
                                      isLabelVisible: notif.unreadCount > 0,
                                      label: Text(
                                        notif.unreadCount > 9 ? '9+' : '${notif.unreadCount}',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      child: const Icon(
                                        Icons.notifications_outlined,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Rank & Tier
                          Row(
                            children: [
                              _buildInfoChip(
                                icon: Icons.star,
                                label: 'DUPR ${user?.rankLevel.toStringAsFixed(1) ?? '0.0'}',
                                color: AppTheme.secondaryColor,
                              ),
                              const SizedBox(width: 12),
                              _buildInfoChip(
                                icon: Icons.diamond_outlined,
                                label: user?.tier ?? 'Standard',
                                color: AppTheme.getTierColor(user?.tier ?? 'Standard'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Content
            SliverToBoxAdapter(
              child: Consumer<DashboardProvider>(
                builder: (context, dashboardProvider, _) {
                  if (dashboardProvider.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  
                  final dashboard = dashboardProvider.dashboard;
                  
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.account_balance_wallet,
                                label: 'Số dư ví',
                                value: _currencyFormat.format(dashboard?.walletBalance ?? 0),
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.calendar_today,
                                label: 'Sắp tới',
                                value: '${dashboard?.upcomingBookings ?? 0} lịch đặt',
                                color: AppTheme.accentColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.emoji_events,
                                label: 'Giải đấu',
                                value: '${dashboard?.activeTournaments ?? 0} đang mở',
                                color: AppTheme.warningColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.notifications,
                                label: 'Thông báo',
                                value: '${dashboard?.unreadNotifications ?? 0} chưa đọc',
                                color: AppTheme.errorColor,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Upcoming Bookings
                        if (dashboard?.nextBookings.isNotEmpty == true) ...[
                          _buildSectionTitle('Lịch đặt sân sắp tới'),
                          const SizedBox(height: 12),
                          ...dashboard!.nextBookings.map((booking) => _buildBookingCard(booking)),
                        ],
                        
                        const SizedBox(height: 24),
                        
                        // News
                        _buildSectionTitle('Tin tức CLB'),
                        const SizedBox(height: 12),
                        ...dashboardProvider.news.take(3).map((news) => _buildNewsCard(news)),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Xem tất cả'),
        ),
      ],
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final dateFormat = DateFormat('HH:mm, dd/MM');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.sports_tennis, color: AppTheme.accentColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.courtName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(booking.startTime.toLocal()),
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              booking.status,
              style: const TextStyle(
                color: AppTheme.successColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(News news) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (news.isPinned)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withAlpha(30),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.push_pin, size: 12, color: AppTheme.errorColor),
                  SizedBox(width: 4),
                  Text(
                    'Ghim',
                    style: TextStyle(color: AppTheme.errorColor, fontSize: 11),
                  ),
                ],
              ),
            ),
          Text(
            news.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            news.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            dateFormat.format(news.createdDate.toLocal()),
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
