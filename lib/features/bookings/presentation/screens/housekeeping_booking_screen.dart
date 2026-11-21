import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/language_toggle_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../domain/entities/booking_entity.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';

class HousekeepingBookingScreen extends StatefulWidget {
  const HousekeepingBookingScreen({super.key});

  @override
  State<HousekeepingBookingScreen> createState() =>
      _HousekeepingBookingScreenState();
}

class _HousekeepingBookingScreenState extends State<HousekeepingBookingScreen> {
  BookingCatalogItem _selectedPackage =
      BookingCatalogItem.housekeepingPackages.first;
  DateTime _bookingDate = DateTime.now().add(const Duration(days: 1));
  String _selectedStartHour = '10:00';
  int _durationHours = 2;
  final _notesController = TextEditingController();

  final List<String> _arrivalHours = const [
    '09:00',
    '10:00',
    '12:00',
    '14:00',
    '15:00',
    '17:00',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String _computeEndTime(String start, int hours) {
    final startHour = int.tryParse(start.split(':').first) ?? 10;
    final endHour = (startHour + hours) % 24;
    return '${endHour.toString().padLeft(2, '0')}:00';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _bookingDate,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 14)),
    );
    if (picked != null) {
      setState(() => _bookingDate = picked);
    }
  }

  void _submitBooking() {
    final authState = context.read<AuthCubit>().state;
    if (authState is! Authenticated) return;
    final user = authState.user;

    final id = 'bk_hk_${DateTime.now().millisecondsSinceEpoch}';
    final number = 'HK-2026-${1000 + (DateTime.now().millisecond % 9000)}';
    final total = _selectedPackage.hourlyRate * _durationHours;
    final notes = _notesController.text.trim();

    final booking = BookingEntity(
      id: id,
      bookingNumber: number,
      compoundId: user.compoundId,
      facilityOrServiceId: _selectedPackage.id,
      title: _selectedPackage.titleEn,
      titleAr: _selectedPackage.titleAr,
      bookingType: BookingType.housekeeping,
      userId: user.id,
      userEmail: user.email,
      userName: user.localizedName(context),
      unitNumber: user.primaryUnitNumber ?? 'V-104',
      bookingDate: DateTime(
        _bookingDate.year,
        _bookingDate.month,
        _bookingDate.day,
      ),
      startTime: _selectedStartHour,
      endTime: _computeEndTime(_selectedStartHour, _durationHours),
      durationHours: _durationHours,
      totalPrice: total,
      status: BookingStatus.scheduled,
      notes: notes.isNotEmpty ? notes : null,
      createdAt: DateTime.now(),
    );

    context.read<BookingCubit>().createBooking(booking);
    _notesController.clear();
  }

  void _openRatingDialog(BookingEntity booking) {
    final l10n = context.l10n;
    int rating = 5;
    final feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            l10n.rateCompletedService,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starNum = index + 1;
                  return IconButton(
                    icon: Icon(
                      starNum <= rating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: AppColors.accentGold,
                      size: 32,
                    ),
                    onPressed: () => setDialogState(() => rating = starNum),
                  );
                }),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: feedbackController,
                maxLines: 2,
                decoration: InputDecoration(hintText: l10n.feedbackHint),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.read<BookingCubit>().submitRating(
                      bookingId: booking.id,
                      rating: rating,
                      feedback: feedbackController.text.trim(),
                    );
              },
              child: Text(l10n.submitRating),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isAr = context.isArabic;
    final dateStr =
        '${_bookingDate.day}/${_bookingDate.month}/${_bookingDate.year}';
    final totalPrice = _selectedPackage.hourlyRate * _durationHours;

    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingLoaded && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.statusRejected,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is BookingLoaded && state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: AppColors.statusCompleted,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state is BookingLoaded && state.isSubmitting;
        final myHkBookings = (state is BookingLoaded)
            ? state.housekeepingBookings
            : <BookingEntity>[];

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primaryDark,
            title: Text(l10n.bookHousekeepingTitle),
            actions: const [
              LanguageToggleButton(),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectCleaningPackage,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                // Cleaning Packages
                ...BookingCatalogItem.housekeepingPackages.map((pkg) {
                  final isSelected = _selectedPackage.id == pkg.id;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () => setState(() => _selectedPackage = pkg),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.06)
                              : AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accentGold
                                : AppColors.borderLight,
                            width: isSelected ? 1.8 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.statusInProgress.withValues(
                                  alpha: 0.14,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                pkg.iconEmoji,
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pkg.localizedTitle(context),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    pkg.localizedSubtitle(context),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accentGold.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                l10n.ratePerHour(pkg.hourlyRate),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accentGoldDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),
                Text(
                  l10n.selectDurationAndRate,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),

                // 1 - 4 Hours Duration Calculator
                Row(
                  children: [1, 2, 3, 4].map((hrs) {
                    final isSelected = _durationHours == hrs;
                    final cost = _selectedPackage.hourlyRate * hrs;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () => setState(() => _durationHours = hrs),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.surfaceCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.accentGold
                                    : AppColors.borderLight,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  l10n.hoursCount(hrs),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? AppColors.textWhite
                                        : AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  l10n.sarAmount(cost),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isSelected
                                        ? AppColors.accentGoldLight
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 18),
                Text(
                  l10n.selectDateAndSlot,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),

                // Date + Start Time Picker
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCard,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 18,
                                color: AppColors.accentTeal,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                dateStr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedStartHour,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.access_time_rounded,
                              color: AppColors.accentGoldDark,
                              size: 18,
                            ),
                            items: _arrivalHours
                                .map(
                                  (slot) => DropdownMenuItem(
                                    value: slot,
                                    child: Text(
                                      '$slot - ${_computeEndTime(slot, _durationHours)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedStartHour = val);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),
                Text(
                  l10n.specialCleaningNotes,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: l10n.specialCleaningNotesHint,
                  ),
                ),
                const SizedBox(height: 20),

                // Total Price & Confirm Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.hoursAndSar(_durationHours, totalPrice),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textWhite,
                            ),
                          ),
                          Text(
                            l10n.totalRateLabel,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.accentGoldLight,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: isSubmitting ? null : _submitBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentGold,
                          foregroundColor: AppColors.primaryDark,
                        ),
                        icon: isSubmitting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.cleaning_services_rounded),
                        label: Text(
                          l10n.confirmHousekeepingBooking,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
                Text(
                  '${l10n.myHousekeepingBookings} (${myHkBookings.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                if (myHkBookings.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Text(
                      l10n.noHousekeepingBookingsYet,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: myHkBookings.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final b = myHkBookings[index];
                      final bDate =
                          '${b.bookingDate.day}/${b.bookingDate.month}/${b.bookingDate.year}';

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    b.localizedTitle(isAr),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _buildStatusBadge(context, b.status),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${b.bookingNumber} • $bDate (${b.startTime} - ${b.endTime})',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (b.assignedStaffName != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                l10n.assignedPrefix(b.assignedStaffName!),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accentTeal,
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.hoursAndSar(
                                    b.durationHours,
                                    b.totalPrice,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accentGoldDark,
                                  ),
                                ),
                                if (b.status == BookingStatus.scheduled ||
                                    b.status == BookingStatus.confirmed)
                                  TextButton(
                                    onPressed: () => context
                                        .read<BookingCubit>()
                                        .updateStatus(
                                          b.id,
                                          BookingStatus.cancelled,
                                        ),
                                    child: Text(
                                      l10n.cancelBooking,
                                      style: const TextStyle(
                                        color: AppColors.statusRejected,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                else if (b.status == BookingStatus.completed &&
                                    !b.hasRating)
                                  TextButton.icon(
                                    onPressed: () => _openRatingDialog(b),
                                    icon: const Icon(
                                      Icons.star_rounded,
                                      color: AppColors.accentGold,
                                      size: 16,
                                    ),
                                    label: Text(
                                      l10n.rateButton,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  )
                                else if (b.hasRating)
                                  Row(
                                    children: List.generate(
                                      b.ratingValue ?? 5,
                                      (_) => const Icon(
                                        Icons.star_rounded,
                                        size: 16,
                                        color: AppColors.accentGold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(BuildContext context, BookingStatus status) {
    Color col;
    switch (status) {
      case BookingStatus.confirmed:
      case BookingStatus.completed:
        col = AppColors.statusCompleted;
        break;
      case BookingStatus.scheduled:
      case BookingStatus.inProgress:
        col = AppColors.statusPending;
        break;
      case BookingStatus.cancelled:
        col = AppColors.statusRejected;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: col.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.localizedName(context).toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: col),
      ),
    );
  }
}
