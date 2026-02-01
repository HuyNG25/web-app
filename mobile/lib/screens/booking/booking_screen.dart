import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  int? _selectedCourtId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadCourts();
      context.read<BookingProvider>().loadCalendar(date: _selectedDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt sân Pickleball'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showMyBookings(context),
          ),
        ],
      ),
      body: Consumer<BookingProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              // Calendar
              Container(
                color: Colors.white,
                child: TableCalendar(
                  firstDay: DateTime.now().subtract(const Duration(days: 30)),
                  lastDay: DateTime.now().add(const Duration(days: 90)),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    provider.setSelectedDate(selectedDay);
                  },
                  onFormatChanged: (format) {
                    setState(() => _calendarFormat = format);
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppTheme.primaryColor.withAlpha(100),
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                  ),
                ),
              ),
              
              // Court Filter
              if (provider.courts.isNotEmpty)
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.courts.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildCourtChip(
                          label: 'Tất cả',
                          isSelected: _selectedCourtId == null,
                          onTap: () {
                            setState(() => _selectedCourtId = null);
                            provider.loadCalendar(date: _selectedDay);
                          },
                        );
                      }
                      final court = provider.courts[index - 1];
                      return _buildCourtChip(
                        label: court.name,
                        isSelected: _selectedCourtId == court.id,
                        onTap: () {
                          setState(() => _selectedCourtId = court.id);
                          provider.loadCalendar(date: _selectedDay, courtId: court.id);
                        },
                      );
                    },
                  ),
                ),
              
              const Divider(height: 1),
              
              // Time Slots
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildTimeSlots(provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCourtChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: AppTheme.primaryColor.withAlpha(50),
        checkmarkColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildTimeSlots(BookingProvider provider) {
    final courts = _selectedCourtId != null
        ? provider.courts.where((c) => c.id == _selectedCourtId).toList()
        : provider.courts;
    
    if (courts.isEmpty) {
      return const Center(child: Text('Không có sân'));
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courts.length,
      itemBuilder: (context, index) {
        final court = courts[index];
        final slots = provider.getSlotsForCourt(court.id);
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  court.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${_currencyFormat.format(court.pricePerHour)}/h',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(16, (hour) { // 6:00 - 22:00
                final slotHour = 6 + hour;
                final slot = slots.firstWhere(
                  (s) => s.startTime.hour == slotHour,
                  orElse: () => CalendarSlot(
                    courtId: court.id,
                    courtName: court.name,
                    startTime: DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, slotHour),
                    endTime: DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, slotHour + 1),
                    isBooked: false,
                    isHold: false,
                  ),
                );
                return _buildSlotChip(slot, court);
              }),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildSlotChip(CalendarSlot slot, Court court) {
    final isPast = slot.startTime.isBefore(DateTime.now());
    final isAvailable = slot.isAvailable && !isPast;
    
    Color bgColor;
    Color textColor;
    
    if (isPast) {
      bgColor = Colors.grey[200]!;
      textColor = Colors.grey[400]!;
    } else if (slot.isBooked) {
      bgColor = AppTheme.errorColor.withAlpha(30);
      textColor = AppTheme.errorColor;
    } else if (slot.isHold) {
      bgColor = AppTheme.warningColor.withAlpha(30);
      textColor = AppTheme.warningColor;
    } else {
      bgColor = AppTheme.successColor.withAlpha(30);
      textColor = AppTheme.successColor;
    }
    
    return GestureDetector(
      onTap: isAvailable ? () => _showBookingDialog(slot, court) : null,
      child: Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: textColor.withAlpha(100)),
        ),
        child: Column(
          children: [
            Text(
              '${slot.startTime.hour}:00',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (slot.isBooked)
              Text(
                'Đã đặt',
                style: TextStyle(color: textColor, fontSize: 10),
              ),
          ],
        ),
      ),
    );
  }

  void _showBookingDialog(CalendarSlot slot, Court court) {
    final user = context.read<AuthProvider>().user;
    final totalPrice = court.pricePerHour;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Xác nhận đặt sân',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildInfoRow('Sân:', court.name),
              _buildInfoRow('Thời gian:', '${slot.startTime.hour}:00 - ${slot.endTime.hour}:00'),
              _buildInfoRow('Ngày:', DateFormat('dd/MM/yyyy').format(slot.startTime)),
              _buildInfoRow('Giá:', _currencyFormat.format(totalPrice)),
              const Divider(height: 24),
              _buildInfoRow(
                'Số dư ví:',
                _currencyFormat.format(user?.walletBalance ?? 0),
                valueColor: (user?.walletBalance ?? 0) >= totalPrice
                    ? AppTheme.successColor
                    : AppTheme.errorColor,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: (user?.walletBalance ?? 0) >= totalPrice
                    ? () async {
                        Navigator.pop(context);
                        final success = await context.read<BookingProvider>().createBooking(
                          courtId: court.id,
                          startTime: slot.startTime,
                          endTime: slot.endTime,
                        );
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success ? 'Đặt sân thành công!' : 'Đặt sân thất bại',
                              ),
                              backgroundColor: success ? AppTheme.successColor : AppTheme.errorColor,
                            ),
                          );
                          if (success) {
                            context.read<AuthProvider>().refreshUser();
                          }
                        }
                      }
                    : null,
                child: const Text('XÁC NHẬN ĐẶT SÂN'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showMyBookings(BuildContext context) {
    context.read<BookingProvider>().loadMyBookings();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Consumer<BookingProvider>(
              builder: (context, provider, _) {
                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Lịch sử đặt sân',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: provider.myBookings.isEmpty
                          ? const Center(child: Text('Chưa có lịch đặt sân'))
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: provider.myBookings.length,
                              itemBuilder: (context, index) {
                                final booking = provider.myBookings[index];
                                return ListTile(
                                  leading: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppTheme.accentColor.withAlpha(30),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.sports_tennis, color: AppTheme.accentColor),
                                  ),
                                  title: Text(booking.courtName),
                                  subtitle: Text(
                                    '${DateFormat('HH:mm').format(booking.startTime.toLocal())} - ${DateFormat('HH:mm, dd/MM').format(booking.endTime.toLocal())}',
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        _currencyFormat.format(booking.totalPrice),
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        booking.status,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: booking.isConfirmed ? AppTheme.successColor : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
