import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/language_toggle_button.dart';
import '../../domain/entities/visitor_pass_entity.dart';
import '../cubit/visitor_cubit.dart';
import '../cubit/visitor_state.dart';
import '../widgets/visitor_qr_pass_dialog.dart';

class MyVisitorPassesScreen extends StatelessWidget {
  const MyVisitorPassesScreen({super.key});

  Color _statusColor(VisitorPassStatus status) {
    switch (status) {
      case VisitorPassStatus.expected:
        return AppColors.statusPending;
      case VisitorPassStatus.checkedIn:
        return AppColors.statusCompleted;
      case VisitorPassStatus.checkedOut:
        return AppColors.statusAssigned;
      case VisitorPassStatus.denied:
      case VisitorPassStatus.expired:
        return AppColors.statusRejected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: Text(l10n.myVisitorPasses),
        actions: const [
          LanguageToggleButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create-visitor-pass'),
        backgroundColor: AppColors.accentGold,
        foregroundColor: AppColors.primaryDark,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          l10n.newVisitorPass,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<VisitorCubit, VisitorState>(
        builder: (context, state) {
          if (state is VisitorLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentGold),
            );
          }

          if (state is VisitorError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.statusRejected),
                ),
              ),
            );
          }

          final passes = (state is VisitorLoaded)
              ? state.passes
              : <VisitorPassEntity>[];

          if (passes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.badge_outlined,
                      size: 56,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.noVisitorPassesYet,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
            itemCount: passes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final pass = passes[index];
              final statusCol = _statusColor(pass.status);
              final dateStr =
                  '${pass.visitDate.day}/${pass.visitDate.month}/${pass.visitDate.year}';

              return InkWell(
                onTap: () => showVisitorPassQrDialog(context, pass),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.accentTeal.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.qr_code_2_rounded,
                          color: AppColors.accentTeal,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    pass.visitorName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusCol.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    pass.status
                                        .localizedName(context)
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: statusCol,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${pass.passCode} • $dateStr (${pass.expectedArrivalTime})',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.directions_car_rounded,
                                  size: 14,
                                  color: AppColors.textMuted,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  (pass.vehiclePlate != null &&
                                          pass.vehiclePlate!.trim().isNotEmpty)
                                      ? pass.vehiclePlate!
                                      : l10n.walkInPedestrian,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
