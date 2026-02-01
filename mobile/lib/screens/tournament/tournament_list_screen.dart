import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class TournamentListScreen extends StatefulWidget {
  const TournamentListScreen({super.key});

  @override
  State<TournamentListScreen> createState() => _TournamentListScreenState();
}

class _TournamentListScreenState extends State<TournamentListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TournamentProvider>().loadTournaments();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giải đấu'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Đang mở'),
            Tab(text: 'Đang diễn ra'),
            Tab(text: 'Đã kết thúc'),
          ],
        ),
      ),
      body: Consumer<TournamentProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.tournaments.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return TabBarView(
            controller: _tabController,
            children: [
              _buildTournamentList(
                provider.tournaments.where((t) => t.status == 'Open' || t.status == 'Registering').toList(),
              ),
              _buildTournamentList(
                provider.tournaments.where((t) => t.status == 'Ongoing' || t.status == 'DrawCompleted').toList(),
              ),
              _buildTournamentList(
                provider.tournaments.where((t) => t.status == 'Finished').toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTournamentList(List<Tournament> tournaments) {
    if (tournaments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Không có giải đấu nào'),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: () => context.read<TournamentProvider>().loadTournaments(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tournaments.length,
        itemBuilder: (context, index) {
          return _buildTournamentCard(tournaments[index]);
        },
      ),
    );
  }

  Widget _buildTournamentCard(Tournament tournament) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    return GestureDetector(
      onTap: () => _showTournamentDetail(tournament),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
          children: [
            // Header with image
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Icon(
                      Icons.emoji_events,
                      size: 80,
                      color: Colors.white.withAlpha(50),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(tournament.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getStatusText(tournament.status),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 16,
                    right: 16,
                    child: Text(
                      tournament.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildInfoItem(
                        Icons.calendar_today,
                        '${dateFormat.format(tournament.startDate)} - ${dateFormat.format(tournament.endDate)}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          Icons.people,
                          '${tournament.currentParticipants}/${tournament.maxParticipants} người',
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          Icons.sports_tennis,
                          tournament.format,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Phí tham gia',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            Text(
                              tournament.entryFee > 0
                                  ? _currencyFormat.format(tournament.entryFee)
                                  : 'Miễn phí',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Tổng giải thưởng',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            Text(
                              _currencyFormat.format(tournament.prizePool),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppTheme.warningColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (tournament.isOpen && !tournament.isFull)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _showJoinDialog(tournament),
                          child: const Text('ĐĂNG KÝ THAM GIA'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open':
      case 'Registering':
        return AppTheme.successColor;
      case 'Ongoing':
      case 'DrawCompleted':
        return AppTheme.warningColor;
      case 'Finished':
        return Colors.grey;
      default:
        return AppTheme.accentColor;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Open': return 'Mở đăng ký';
      case 'Registering': return 'Đang đăng ký';
      case 'DrawCompleted': return 'Đã bốc thăm';
      case 'Ongoing': return 'Đang diễn ra';
      case 'Finished': return 'Đã kết thúc';
      default: return status;
    }
  }

  void _showTournamentDetail(Tournament tournament) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TournamentDetailScreen(tournament: tournament),
      ),
    );
  }

  void _showJoinDialog(Tournament tournament) {
    final user = context.read<AuthProvider>().user;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đăng ký tham gia'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Giải: ${tournament.name}'),
              const SizedBox(height: 8),
              Text('Phí: ${_currencyFormat.format(tournament.entryFee)}'),
              const SizedBox(height: 8),
              Text('Số dư ví: ${_currencyFormat.format(user?.walletBalance ?? 0)}'),
              if ((user?.walletBalance ?? 0) < tournament.entryFee)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Số dư không đủ!',
                    style: TextStyle(color: AppTheme.errorColor),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: (user?.walletBalance ?? 0) >= tournament.entryFee
                  ? () async {
                      Navigator.pop(context);
                      final success = await context.read<TournamentProvider>().joinTournament(tournament.id);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success ? 'Đăng ký thành công!' : 'Đăng ký thất bại',
                            ),
                            backgroundColor: success ? AppTheme.successColor : AppTheme.errorColor,
                          ),
                        );
                        if (success) {
                          context.read<AuthProvider>().refreshUser();
                          context.read<TournamentProvider>().loadTournaments();
                        }
                      }
                    }
                  : null,
              child: const Text('Đăng ký'),
            ),
          ],
        );
      },
    );
  }
}

class TournamentDetailScreen extends StatelessWidget {
  final Tournament tournament;
  
  const TournamentDetailScreen({super.key, required this.tournament});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    
    return Scaffold(
      appBar: AppBar(
        title: Text(tournament.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.emoji_events, size: 64, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    tournament.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${dateFormat.format(tournament.startDate)} - ${dateFormat.format(tournament.endDate)}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Info cards
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    'Phí tham gia',
                    currencyFormat.format(tournament.entryFee),
                    Icons.payments,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    'Tổng giải thưởng',
                    currencyFormat.format(tournament.prizePool),
                    Icons.monetization_on,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    'Người tham gia',
                    '${tournament.currentParticipants}/${tournament.maxParticipants}',
                    Icons.people,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    'Thể thức',
                    tournament.format,
                    Icons.sports_tennis,
                  ),
                ),
              ],
            ),
            
            if (tournament.description != null) ...[
              const SizedBox(height: 24),
              const Text(
                'Mô tả',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(tournament.description!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
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
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
