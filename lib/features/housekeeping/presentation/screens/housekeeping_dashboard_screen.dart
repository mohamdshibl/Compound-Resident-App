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

class HousekeepingDashboardScreen extends StatelessWidget {
  const HousekeepingDashboardScreen({super.key});

  void _openDispatchSheet(BuildContext context, BookingEntity booking) {
    final l10n = context.l10n;
    final teams = [
      l10n.teamFatimaSunita,
      l10n.teamMariaElena,
      l10n.teamAminaGrace,
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.assignCleaningTeamTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...teams.map(
              (team) => ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(
                    Icons.cleaning_services_rounded,
                    color: AppColors.accentGold,
                    size: 18,
                  ),
                ),
                title: Text(
                  team,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.accentTeal,
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<BookingCubit>().updateStatus(
                        booking.id,
                        BookingStatus.confirmed,
                        assignedStaffName: team,
                      );
                },
              ),
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

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final user = (authState is Authenticated) ? authState.user : null;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primaryDark,
            title: Text(l10n.housekeepingAndCleaning),
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

              final hkBookings = (bState is BookingLoaded)
                  ? bState.housekeepingBookings
                  : <BookingEntity>[];

              final scheduledCount = hkBookings
                  .where((b) => b.status == BookingStatus.scheduled)
                  .length;
              final confirmedCount = hkBookings
                  .where(
                    (b) =>
                        b.status == BookingStatus.confirmed ||
                        b.status == BookingStatus.inProgress,
                  )
                  .length;
              final completedCount = hkBookings
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
                              color: AppColors.statusInProgress.withValues(
                                alpha: 0.2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.cleaning_services_rounded,
                              color: AppColors.statusInProgress,
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
                                      l10n.housekeepingSupervisorFallback,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textWhite,
                                  ),
                                ),
                                Text(
                                  l10n.housekeepingRateSubtitle,
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
                          l10n.statusScheduled,
                          '$scheduledCount',
                          AppColors.statusPending,
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
                      '${l10n.todaysCleaningAppointments} (${hkBookings.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (hkBookings.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Text(
                          l10n.noHousekeepingBookingsStaff,
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
                        itemCount: hkBookings.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _buildCleaningJobCard(
                            context,
                            hkBookings[index],
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

  Widget _buildCleaningJobCard(
    BuildContext context,
    BookingEntity booking,
    bool isAr,
  ) {
    final l10n = context.l10n;
    final dateStr =
        '${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year}';

    Color statusColor;
    switch (booking.status) {
      case BookingStatus.confirmed:
      case BookingStatus.completed:
        statusColor = AppColors.statusCompleted;
        break;
      case BookingStatus.scheduled:
      case BookingStatus.inProgress:
        statusColor = AppColors.statusPending;
        break;
      case BookingStatus.cancelled:
        statusColor = AppColors.statusRejected;
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
              Flexible(
                child: Text(
                  '${l10n.unitWithNumber(booking.unitNumber)} (${booking.userName}) • ${booking.bookingNumber}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  booking.status.localizedName(context).toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            booking.localizedTitle(isAr),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.hoursAndSar(booking.durationHours, booking.totalPrice),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.accentGoldDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            booking.assignedStaffName != null
                ? l10n.assignedPrefix(booking.assignedStaffName!)
                : l10n.staffUnassigned,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: booking.assignedStaffName != null
                  ? AppColors.accentTeal
                  : AppColors.statusPending,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$dateStr • ${booking.startTime} - ${booking.endTime}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              if (booking.status != BookingStatus.completed &&
                  booking.status != BookingStatus.cancelled)
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _openDispatchSheet(context, booking),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                      ),
                      child: Text(
                        l10n.dispatch,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<BookingCubit>().updateStatus(
                                booking.id,
                                BookingStatus.completed,
                              ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.statusCompleted,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
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
          ),
        ],
      ),
    );
  }
}
