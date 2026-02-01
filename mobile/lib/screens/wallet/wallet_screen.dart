import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/providers.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletProvider>().loadBalance();
      context.read<WalletProvider>().loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ví điện tử'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<WalletProvider>().loadBalance();
          await context.read<WalletProvider>().loadTransactions();
          await context.read<AuthProvider>().refreshUser();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Balance Card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withAlpha(100),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Số dư hiện tại',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currencyFormat.format(user?.walletBalance ?? 0),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tier badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(30),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.diamond,
                            color: AppTheme.getTierColor(user?.tier ?? 'Standard'),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Hạng ${user?.tier ?? 'Standard'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _showDepositDialog(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppTheme.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            icon: const Icon(Icons.add),
                            label: const Text('Nạp tiền'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Transaction History
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Lịch sử giao dịch',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Xem tất cả'),
                    ),
                  ],
                ),
              ),
              
              Consumer<WalletProvider>(
                builder: (context, wallet, _) {
                  if (wallet.isLoading && wallet.transactions.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  
                  if (wallet.transactions.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('Chưa có giao dịch nào'),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: wallet.transactions.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final tx = wallet.transactions[index];
                      return _buildTransactionItem(tx);
                    },
                  );
                },
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(dynamic transaction) {
    final isDeposit = transaction.amount > 0;
    final dateFormat = DateFormat('HH:mm, dd/MM/yyyy');
    
    IconData icon;
    Color color;
    
    switch (transaction.type) {
      case 'Deposit':
        icon = Icons.add_circle;
        color = AppTheme.successColor;
        break;
      case 'Payment':
        icon = Icons.remove_circle;
        color = AppTheme.errorColor;
        break;
      case 'Refund':
        icon = Icons.replay;
        color = AppTheme.accentColor;
        break;
      case 'Reward':
        icon = Icons.emoji_events;
        color = AppTheme.warningColor;
        break;
      default:
        icon = Icons.swap_horiz;
        color = Colors.grey;
    }
    
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
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description ?? transaction.type,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      dateFormat.format(transaction.createdDate.toLocal()),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getStatusColor(transaction.status).withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getStatusText(transaction.status),
                        style: TextStyle(
                          color: _getStatusColor(transaction.status),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${isDeposit ? '+' : ''}${_currencyFormat.format(transaction.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDeposit ? AppTheme.successColor : AppTheme.errorColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed': return AppTheme.successColor;
      case 'Pending': return AppTheme.warningColor;
      case 'Rejected': return AppTheme.errorColor;
      default: return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Completed': return 'Hoàn thành';
      case 'Pending': return 'Đang chờ';
      case 'Rejected': return 'Từ chối';
      default: return status;
    }
  }

  void _showDepositDialog() {
    final amountController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Nạp tiền vào ví',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Số tiền cần nạp',
                  prefixText: 'đ ',
                  hintText: '100000',
                ),
              ),
              const SizedBox(height: 16),
              // Quick amount buttons
              Wrap(
                spacing: 8,
                children: [100000, 200000, 500000, 1000000].map((amount) {
                  return ActionChip(
                    label: Text(_currencyFormat.format(amount)),
                    onPressed: () {
                      amountController.text = amount.toString();
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hướng dẫn:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('1. Chuyển khoản đến STK: 123456789'),
                    Text('2. Ngân hàng: Vietcombank'),
                    Text('3. Chủ TK: CLB VỢT THỦ PHỐ NÚI'),
                    Text('4. Nội dung: [Email] nap tien'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Consumer<WalletProvider>(
                builder: (context, wallet, _) {
                  return ElevatedButton(
                    onPressed: wallet.isLoading
                        ? null
                        : () async {
                            final amount = double.tryParse(amountController.text);
                            if (amount == null || amount <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Vui lòng nhập số tiền hợp lệ')),
                              );
                              return;
                            }
                            
                            Navigator.pop(context);
                            final success = await context.read<WalletProvider>().deposit(amount, null);
                            
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? 'Đã gửi yêu cầu nạp tiền. Vui lòng chờ Admin duyệt.'
                                        : 'Có lỗi xảy ra',
                                  ),
                                  backgroundColor: success ? AppTheme.successColor : AppTheme.errorColor,
                                ),
                              );
                            }
                          },
                    child: wallet.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('GỬI YÊU CẦU NẠP TIỀN'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
