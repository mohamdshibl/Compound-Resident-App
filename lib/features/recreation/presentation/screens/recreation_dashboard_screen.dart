import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/language_toggle_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../bookings/domain/entities/booking_entity.dart';
import '../../../bookings/presentation/cubit/booking_cubit.dart';
import '../../../bookings/presentation/cubit/booking_state.dart';

class RecreationDashboardScreen extends StatelessWidget {
  const RecreationDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isAr = context.isArabic;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final user = (authState is Authenticated) ? authState.user : null;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primaryDark,
            title: Text(l10n.recreationAndFacilities),
            actions: [
              const LanguageToggleButton(),
              IconButton(
                icon: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.accentGold,
                ),
                tooltip: l10n.signOut,
                onPressed: () => context.read<AuthCubit>().logout(),
              ),
            ],
          ),
          body: BlocConsumer<BookingCubit, BookingState>(
            listener: (context, bState) {
              if (bState is BookingLoaded && bState.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(bState.errorMessage!),
                    backgroundColor: AppColors.statusRejected,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (bState is BookingLoaded &&
                  bState.successMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(bState.successMessage!),
                    backgroundColor: AppColors.statusCompleted,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            builder: (context, bState) {
              if (bState is BookingLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.accentGold),
                );
              }

              final recBookings = (bState is BookingLoaded)
                  ? bState.recreationBookings
                  : <BookingEntity>[];

              final confirmedCount = recBookings
                  .where(
                    (b) =>
                        b.status == BookingStatus.confirmed ||
                        b.status == BookingStatus.scheduled,
                  )
                  .length;
              final completedCount = recBookings
                  .where((b) => b.status == BookingStatus.completed)
                  .length;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.accentGold.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.sports_tennis_rounded,
                              color: AppColors.accentGold,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.localizedName(context) ??
                                      l10n.recreationManagerFallback,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textWhite,
                                  ),
                                ),
                                Text(
                                  l10n.clubhouseSubtitle,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.accentGoldLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Live Metrics Row
                    Row(
                      children: [
                        _buildMetricCard(
                          l10n.totalBookingsMetric,
                          '${recBookings.length}',
                          AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        _buildMetricCard(
                          l10n.confirmedMetric,
                          '$confirmedCount',
                          AppColors.statusAssigned,
                        ),
                        const SizedBox(width: 10),
                        _buildMetricCard(
                          l10n.completedMetric,
                          '$completedCount',
                          AppColors.statusCompleted,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Text(
                      '${l10n.facilityBookingsToday} (${recBookings.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (recBookings.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Text(
                          l10n.noFacilityBookingsStaff,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recBookings.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _buildFacilityBookingCard(
                            context,
                            recBookings[index],
                            isAr,
                          );
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMetricCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityBookingCard(
    BuildContext context,
    BookingEntity booking,
    bool isAr,
  ) {
    final l10n = context.l10n;
    final dateStr =
        '${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year}';
    final rateText = booking.totalPrice == 0
        ? l10n.complimentary
        : l10n.sarAmount(booking.totalPrice);

    Color statusCol;
    switch (booking.status) {
      case BookingStatus.confirmed:
      case BookingStatus.completed:
        statusCol = AppColors.statusCompleted;
        break;
      case BookingStatus.scheduled:
      case BookingStatus.inProgress:
        statusCol = AppColors.statusPending;
        break;
      case BookingStatus.cancelled:
        statusCol = AppColors.statusRejected;
        break;
    }

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
              Expanded(
                child: Text(
                  booking.localizedTitle(isAr),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusCol.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  booking.status.localizedName(context).toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusCol,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${booking.userName} (${l10n.unitWithNumber(booking.unitNumber)}) • ${booking.bookingNumber}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$dateStr • ${l10n.slotPrefix('${booking.startTime} - ${booking.endTime}')}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                rateText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentGoldDark,
                ),
              ),
            ],
          ),
          if (booking.status != BookingStatus.completed &&
              booking.status != BookingStatus.cancelled) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.read<BookingCubit>().updateStatus(
                        booking.id,
                        BookingStatus.cancelled,
                      ),
                  child: Text(
                    l10n.cancelBooking,
                    style: const TextStyle(
                      color: AppColors.statusRejected,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (booking.status == BookingStatus.scheduled) ...[
                  ElevatedButton(
                    onPressed: () => context.read<BookingCubit>().updateStatus(
                          booking.id,
                          BookingStatus.confirmed,
                        ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                    ),
                    child: Text(
                      l10n.confirmBookingAction,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                ElevatedButton(
                  onPressed: () => context.read<BookingCubit>().updateStatus(
                        booking.id,
                        BookingStatus.completed,
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.statusCompleted,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    l10n.markComplete,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
