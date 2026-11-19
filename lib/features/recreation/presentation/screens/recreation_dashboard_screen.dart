import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/language_toggle_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class RecreationDashboardScreen extends StatelessWidget {
  const RecreationDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isAr = context.isArabic;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = (state is Authenticated) ? state.user : null;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primaryDark,
            title: Text(l10n.recreationAndFacilities),
            actions: [
              const LanguageToggleButton(),
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: AppColors.accentGold),
                tooltip: l10n.signOut,
                onPressed: () => context.read<AuthCubit>().logout(),
              ),
            ],
          ),
          body: SingleChildScrollView(
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
                        child: const Icon(Icons.sports_tennis_rounded, color: AppColors.accentGold, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.localizedName(context) ?? l10n.recreationManagerFallback,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textWhite,
                              ),
                            ),
                            Text(
                              l10n.clubhouseSubtitle,
                              style: const TextStyle(fontSize: 12, color: AppColors.accentGoldLight),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.facilityBookingsToday,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                _buildFacilityBookingCard(
                  context: context,
                  facility: l10n.padelCourt1,
                  resident: isAr ? 'د. طارق منصور (فيلا V-104)' : 'Dr. Tarek Mansour (Villa V-104)',
                  time: '19:00 - 20:00',
                  rate: l10n.sarAmount(80),
                  status: l10n.statusConfirmed,
                ),
                const SizedBox(height: 12),
                _buildFacilityBookingCard(
                  context: context,
                  facility: l10n.olympicSwimmingPool,
                  resident: isAr ? 'سارة الحسيني (شقة B2-301)' : 'Sara Al-Husseini (Apt B2-301)',
                  time: '16:00 - 17:00',
                  rate: l10n.complimentary,
                  status: l10n.statusConfirmed,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFacilityBookingCard({
    required BuildContext context,
    required String facility,
    required String resident,
    required String time,
    required String rate,
    required String status,
  }) {
    final l10n = context.l10n;

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
                child: Text(facility, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.statusCompleted.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.statusCompleted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(resident, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.slotPrefix(time), style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              Text(rate, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.accentGoldDark)),
            ],
          ),
        ],
      ),
    );
  }
}
