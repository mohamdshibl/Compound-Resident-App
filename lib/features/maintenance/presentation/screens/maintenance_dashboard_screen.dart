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

class MaintenanceDashboardScreen extends StatelessWidget {
  const MaintenanceDashboardScreen({super.key});

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
            title: Text(l10n.maintenanceWorkOrders),
            actions: [
              const LanguageToggleButton(),
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: AppColors.accentGold),
                tooltip: l10n.signOut,
                onPressed: () => context.read<AuthCubit>().logout(),
              ),
            ],
          ),
          body: BlocBuilder<MaintenanceCubit, MaintenanceState>(
            builder: (context, mState) {
              final allRequests = (mState is MaintenanceLoaded) ? mState.requests : <ServiceRequestEntity>[];
              final selectedCat = (mState is MaintenanceLoaded) ? mState.selectedCategory : null;

              final filteredRequests = selectedCat == null
                  ? allRequests
                  : allRequests.where((r) => r.category == selectedCat).toList();

              final newCount = allRequests
                  .where((r) => r.currentStatus == RequestStatus.pending || r.currentStatus == RequestStatus.underReview)
                  .length;
              final assignedCount = allRequests.where((r) => r.currentStatus == RequestStatus.assigned).length;
              final inProgressCount = allRequests.where((r) => r.currentStatus == RequestStatus.inProgress).length;
              final completedCount = allRequests.where((r) => r.currentStatus == RequestStatus.completed).length;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Department Lead Info
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
                            child: const Icon(Icons.handyman_rounded, color: AppColors.accentGold, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.localizedName(context) ?? l10n.maintenanceLeadFallback,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textWhite,
                                  ),
                                ),
                                Text(
                                  l10n.maintenanceOperationsSubtitle,
                                  style: const TextStyle(fontSize: 12, color: AppColors.accentGoldLight),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Metrics Row
                    Row(
                      children: [
                        _buildMetricCard(l10n.metricNew, '$newCount', AppColors.statusPending),
                        const SizedBox(width: 8),
                        _buildMetricCard(l10n.metricAssigned, '$assignedCount', AppColors.statusAssigned),
                        const SizedBox(width: 8),
                        _buildMetricCard(l10n.metricInProgress, '$inProgressCount', AppColors.statusInProgress),
                        const SizedBox(width: 8),
                        _buildMetricCard(l10n.metricCompleted, '$completedCount', AppColors.statusCompleted),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Category Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(
                            context: context,
                            label: l10n.filterAll(allRequests.length),
                            isSelected: selectedCat == null,
                            onTap: () => context.read<MaintenanceCubit>().filterByCategory(null),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            context: context,
                            label: l10n.filterAc,
                            isSelected: selectedCat == RequestCategory.airConditioning,
                            onTap: () => context.read<MaintenanceCubit>().filterByCategory(RequestCategory.airConditioning),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            context: context,
                            label: l10n.filterPlumbing,
                            isSelected: selectedCat == RequestCategory.plumbing,
                            onTap: () => context.read<MaintenanceCubit>().filterByCategory(RequestCategory.plumbing),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            context: context,
                            label: l10n.filterElectrical,
                            isSelected: selectedCat == RequestCategory.electrical,
                            onTap: () => context.read<MaintenanceCubit>().filterByCategory(RequestCategory.electrical),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      l10n.workOrdersCount(filteredRequests.length),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (filteredRequests.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Center(
                          child: Text(l10n.noWorkOrdersFilter, style: const TextStyle(color: AppColors.textSecondary)),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredRequests.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final req = filteredRequests[index];
                          return _buildOrderCard(context, req);
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
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
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight),
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

  Widget _buildOrderCard(BuildContext context, ServiceRequestEntity req) {
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
                  req.requestNumber,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    req.priority.localizedName(context).toUpperCase(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: priorityColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(req.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              '${req.category.localizedName(context)} • ${l10n.unitWithNumber(req.unitNumber)} (${req.createdByName})',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline_rounded, size: 16, color: AppColors.accentTeal),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          req.assignedEmployeeName ?? l10n.unassigned,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: req.assignedEmployeeName != null ? AppColors.textPrimary : AppColors.statusPending,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => context.push('/request-detail', extra: req),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: Size.zero,
                  ),
                  child: Text(l10n.manageAndChat, style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
