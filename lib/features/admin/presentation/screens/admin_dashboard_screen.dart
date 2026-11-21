import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/language_toggle_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../requests/domain/entities/request_enums.dart';
import '../../../requests/domain/entities/service_request_entity.dart';
import '../../../requests/presentation/cubit/maintenance_cubit.dart';
import '../../../requests/presentation/cubit/maintenance_state.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _onlyDirectComplaints = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final user = (authState is Authenticated) ? authState.user : null;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primaryDark,
            title: Text(l10n.compoundAdministration),
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
          body: BlocBuilder<MaintenanceCubit, MaintenanceState>(
            builder: (context, mState) {
              if (mState is MaintenanceLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.accentGold),
                );
              }

              final allRequests = (mState is MaintenanceLoaded)
                  ? mState.requests
                  : <ServiceRequestEntity>[];

              final directComplaints = allRequests
                  .where((r) => r.department == 'administration')
                  .toList();

              final openRequestsCount = allRequests
                  .where(
                    (r) =>
                        r.currentStatus != RequestStatus.completed &&
                        r.currentStatus != RequestStatus.cancelled,
                  )
                  .length;

              final displayedList =
                  _onlyDirectComplaints ? directComplaints : allRequests;

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
                              Icons.business_center_rounded,
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
                                      l10n.administratorFallback,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textWhite,
                                  ),
                                ),
                                Text(
                                  l10n.executiveOpsSubtitle,
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

                    // Executive Metrics Row
                    Row(
                      children: [
                        _buildMetricCard(
                          l10n.totalUnits,
                          '180',
                          AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        _buildMetricCard(
                          l10n.occupancy,
                          '92%',
                          AppColors.statusCompleted,
                        ),
                        const SizedBox(width: 10),
                        _buildMetricCard(
                          l10n.openRequests,
                          '$openRequestsCount',
                          AppColors.statusPending,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Filter Toggle Chips
                    Row(
                      children: [
                        _buildFilterChip(
                          label: l10n
                              .adminFilterComplaints(directComplaints.length),
                          isSelected: _onlyDirectComplaints,
                          onTap: () =>
                              setState(() => _onlyDirectComplaints = true),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: l10n.adminFilterAllCompound(allRequests.length),
                          isSelected: !_onlyDirectComplaints,
                          onTap: () =>
                              setState(() => _onlyDirectComplaints = false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text(
                      '${l10n.escalatedComplaints} (${displayedList.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (displayedList.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Text(
                          l10n.noAdminComplaintsYet,
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
                        itemCount: displayedList.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _buildComplaintCard(
                            context,
                            displayedList[index],
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

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.textWhite : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildComplaintCard(BuildContext context, ServiceRequestEntity req) {
    final l10n = context.l10n;
    Color priorityColor;
    switch (req.priority) {
      case RequestPriority.emergency:
      case RequestPriority.high:
        priorityColor = AppColors.statusRejected;
        break;
      case RequestPriority.medium:
        priorityColor = AppColors.statusPending;
        break;
      case RequestPriority.low:
        priorityColor = AppColors.statusCompleted;
        break;
    }

    Color statusColor;
    switch (req.currentStatus) {
      case RequestStatus.completed:
        statusColor = AppColors.statusCompleted;
        break;
      case RequestStatus.assigned:
      case RequestStatus.inProgress:
        statusColor = AppColors.statusAssigned;
        break;
      default:
        statusColor = AppColors.statusPending;
    }

    return InkWell(
      onTap: () => context.push('/request-detail', extra: req),
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
                Text(
                  '${req.category.iconEmoji} ${req.requestNumber} • ${req.priority.localizedName(context).toUpperCase()}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: priorityColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    req.currentStatus.localizedName(context).toUpperCase(),
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
              req.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${req.createdByName} (${l10n.unitWithNumber(req.unitNumber)}) • ${req.category.localizedName(context)}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => context.push('/request-detail', extra: req),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    l10n.manageAndChat,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
