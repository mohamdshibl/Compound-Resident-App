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

class ItDashboardScreen extends StatefulWidget {
  const ItDashboardScreen({super.key});

  @override
  State<ItDashboardScreen> createState() => _ItDashboardScreenState();
}

class _ItDashboardScreenState extends State<ItDashboardScreen> {
  RequestCategory? _selectedCategory;

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
            title: Text(l10n.itSmartSupport),
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

              final allItTickets = (mState is MaintenanceLoaded)
                  ? mState.requests
                      .where((r) => r.department == 'it_support')
                      .toList()
                  : <ServiceRequestEntity>[];

              final filteredTickets = _selectedCategory == null
                  ? allItTickets
                  : allItTickets
                      .where((r) => r.category == _selectedCategory)
                      .toList();

              final openCount = allItTickets
                  .where(
                    (r) =>
                        r.currentStatus == RequestStatus.pending ||
                        r.currentStatus == RequestStatus.underReview,
                  )
                  .length;
              final activeCount = allItTickets
                  .where(
                    (r) =>
                        r.currentStatus == RequestStatus.assigned ||
                        r.currentStatus == RequestStatus.inProgress,
                  )
                  .length;
              final doneCount = allItTickets
                  .where((r) => r.currentStatus == RequestStatus.completed)
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
                              color: AppColors.statusAssigned.withValues(
                                alpha: 0.2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.computer_rounded,
                              color: AppColors.statusAssigned,
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
                                      l10n.itSupportFallback,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textWhite,
                                  ),
                                ),
                                Text(
                                  l10n.fiberNetworkSubtitle,
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
                          l10n.metricNew,
                          '$openCount',
                          AppColors.statusPending,
                        ),
                        const SizedBox(width: 10),
                        _buildMetricCard(
                          l10n.metricInProgress,
                          '$activeCount',
                          AppColors.statusAssigned,
                        ),
                        const SizedBox(width: 10),
                        _buildMetricCard(
                          l10n.metricCompleted,
                          '$doneCount',
                          AppColors.statusCompleted,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // IT Category Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(
                            label: l10n.filterAll(allItTickets.length),
                            isSelected: _selectedCategory == null,
                            onTap: () =>
                                setState(() => _selectedCategory = null),
                          ),
                          const SizedBox(width: 8),
                          ...RequestCategory.forDepartment('it_support').map(
                            (cat) => Padding(
                              padding: const EdgeInsetsDirectional.only(end: 8),
                              child: _buildFilterChip(
                                label:
                                    '${cat.localizedName(context)} ${cat.iconEmoji}',
                                isSelected: _selectedCategory == cat,
                                onTap: () =>
                                    setState(() => _selectedCategory = cat),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      '${l10n.activeTechnicalTickets} (${filteredTickets.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (filteredTickets.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Text(
                          l10n.noItTicketsYet,
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
                        itemCount: filteredTickets.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _buildTicketCard(
                            context,
                            filteredTickets[index],
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

  Widget _buildTicketCard(BuildContext context, ServiceRequestEntity req) {
    final l10n = context.l10n;
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
                  '${req.category.iconEmoji} ${req.requestNumber}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
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
              '${req.category.localizedName(context)} • ${l10n.unitWithNumber(req.unitNumber)} (${req.createdByName})',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        size: 16,
                        color: AppColors.accentTeal,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          req.assignedEmployeeName ?? l10n.unassigned,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: req.assignedEmployeeName != null
                                ? AppColors.textPrimary
                                : AppColors.statusPending,
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
