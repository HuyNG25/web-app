import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/providers.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    
    return Scaffold(
      appBar: AppBar(title: const Text('Tài khoản')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10)],
              ),
              child: Column(children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primaryColor.withAlpha(30),
                  child: Text(user?.fullName[0].toUpperCase() ?? 'U',
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                ),
                const SizedBox(height: 16),
                Text(user?.fullName ?? 'Member', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(user?.email ?? '', style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  Column(children: [
                    const Icon(Icons.star, color: AppTheme.secondaryColor),
                    Text('${user?.rankLevel.toStringAsFixed(1) ?? '3.0'}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('DUPR', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ]),
                  Column(children: [
                    Icon(Icons.diamond, color: AppTheme.getTierColor(user?.tier ?? 'Standard')),
                    Text(user?.tier ?? 'Standard', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Hạng', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ]),
                  Column(children: [
                    const Icon(Icons.account_balance_wallet, color: AppTheme.successColor),
                    Text(currencyFormat.format(user?.walletBalance ?? 0), style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Số dư', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ]),
                ]),
              ]),
            ),
            const SizedBox(height: 24),
            _buildMenuItem(Icons.person_outline, 'Thông tin cá nhân', () {}),
            _buildMenuItem(Icons.history, 'Lịch sử đặt sân', () {}),
            _buildMenuItem(Icons.emoji_events_outlined, 'Giải đấu đã tham gia', () {}),
            _buildMenuItem(Icons.leaderboard_outlined, 'Bảng xếp hạng', () {}),
            const SizedBox(height: 16),
            _buildMenuItem(Icons.logout, 'Đăng xuất', () => _showLogoutDialog(context), color: AppTheme.errorColor),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppTheme.primaryColor),
        title: Text(title, style: TextStyle(color: color)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Đăng xuất'),
      content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
        ElevatedButton(
          onPressed: () { Navigator.pop(ctx); context.read<AuthProvider>().logout(); },
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
          child: const Text('Đăng xuất'),
        ),
      ],
    ));
  }
}
