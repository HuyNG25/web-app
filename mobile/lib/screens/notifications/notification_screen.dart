import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/providers.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        actions: [
          TextButton(
            onPressed: () => context.read<NotificationProvider>().markAllAsRead(),
            child: const Text('Đọc tất cả', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.notifications.isEmpty) {
            return const Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Không có thông báo nào'),
              ]),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () => provider.loadNotifications(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.notifications.length,
              itemBuilder: (context, index) {
                final notif = provider.notifications[index];
                final dateFormat = DateFormat('HH:mm, dd/MM');
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: notif.isRead ? Colors.white : AppTheme.primaryColor.withAlpha(10),
                    borderRadius: BorderRadius.circular(12),
                    border: notif.isRead ? null : Border.all(color: AppTheme.primaryColor.withAlpha(50)),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getTypeColor(notif.type).withAlpha(30),
                      child: Icon(_getTypeIcon(notif.type), color: _getTypeColor(notif.type)),
                    ),
                    title: Text(notif.message, style: TextStyle(fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold)),
                    subtitle: Text(dateFormat.format(notif.createdDate.toLocal()), style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    onTap: () {
                      if (!notif.isRead) provider.markAsRead(notif.id);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Booking': return Icons.calendar_today;
      case 'Wallet': return Icons.account_balance_wallet;
      case 'Tournament': return Icons.emoji_events;
      case 'Match': return Icons.sports_tennis;
      default: return Icons.info;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Booking': return AppTheme.accentColor;
      case 'Wallet': return AppTheme.successColor;
      case 'Tournament': return AppTheme.warningColor;
      case 'Match': return AppTheme.primaryColor;
      default: return Colors.grey;
    }
  }
}
