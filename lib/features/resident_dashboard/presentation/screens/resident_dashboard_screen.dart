import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../requests/domain/entities/request_enums.dart';
import '../../../requests/domain/entities/service_request_entity.dart';
import '../../../requests/presentation/cubit/maintenance_cubit.dart';
import '../../../requests/presentation/cubit/maintenance_state.dart';

class ResidentDashboardScreen extends StatelessWidget {
  const ResidentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = (state is Authenticated) ? state.user : null;
        final name = user?.fullName ?? 'Resident';
        final unit = user?.primaryUnitNumber ?? 'V-104';
        final isOwner = user?.role.toDbString() == 'owner';

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primaryDark,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.apartment_rounded, color: AppColors.accentGold, size: 20),
                const SizedBox(width: 8),
                Text(
                  user?.compoundName ?? 'Al-Nakheel Prestige',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: AppColors.accentGold),
                tooltip: 'Sign Out',
                onPressed: () => context.read<AuthCubit>().logout(),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryDark, AppColors.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryDark.withValues(alpha: 0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.accentGold,
                        child: Text(
                          name.isNotEmpty ? name[0] : 'R',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textWhite,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isOwner ? AppColors.accentGold : AppColors.accentTeal,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    isOwner ? 'OWNER' : 'TENANT',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Unit $unit • Authorized Residence',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.accentGoldLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Services Header
                const Text(
                  'Resident Services',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),

                // Quick Services 2x2 Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.35,
                  children: [
                    _buildServiceTile(
                      icon: Icons.badge_outlined,
                      color: AppColors.accentTeal,
                      title: 'Visitor Pass',
                      subtitle: 'Expected guests & QR',
                      onTap: () {},
                    ),
                    _buildServiceTile(
                      icon: Icons.handyman_outlined,
                      color: AppColors.statusAssigned,
                      title: 'Maintenance',
                      subtitle: 'AC, plumbing & repairs',
                      onTap: () => context.push('/create-request'),
                    ),
                    _buildServiceTile(
                      icon: Icons.sports_tennis_rounded,
                      color: AppColors.accentGold,
                      title: 'Recreation',
                      subtitle: 'Padel, gym & pool',
                      onTap: () {},
                    ),
                    _buildServiceTile(
                      icon: Icons.cleaning_services_outlined,
                      color: AppColors.statusInProgress,
                      title: 'Housekeeping',
                      subtitle: 'Book certified cleaning',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Active Requests Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Active Requests',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.add, size: 16, color: AppColors.accentTeal),
                      label: const Text('New Request', style: TextStyle(color: AppColors.accentTeal)),
                      onPressed: () => context.push('/create-request'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Real Requests Stream from MaintenanceCubit
                BlocBuilder<MaintenanceCubit, MaintenanceState>(
                  builder: (context, mState) {
                    final requests = (mState is MaintenanceLoaded) ? mState.requests : <ServiceRequestEntity>[];

                    if (requests.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: const Center(
                          child: Text(
                            'No active service requests right now.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: requests.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final req = requests[index];
                        return _buildRequestCard(context, req);
                      },
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

  Widget _buildRequestCard(BuildContext context, ServiceRequestEntity req) {
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.statusAssigned.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(req.category.iconEmoji, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    req.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${req.requestNumber} • ${req.preferredTimeSlot}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _buildStatusBadge(req.currentStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(RequestStatus status) {
    Color bg;
    Color fg;
    switch (status) {
      case RequestStatus.pending:
      case RequestStatus.underReview:
        bg = AppColors.statusPending.withValues(alpha: 0.12);
        fg = AppColors.statusPending;
        break;
      case RequestStatus.assigned:
      case RequestStatus.inProgress:
        bg = AppColors.statusAssigned.withValues(alpha: 0.12);
        fg = AppColors.statusAssigned;
        break;
      case RequestStatus.completed:
        bg = AppColors.statusCompleted.withValues(alpha: 0.12);
        fg = AppColors.statusCompleted;
        break;
      default:
        bg = AppColors.statusCancelled.withValues(alpha: 0.12);
        fg = AppColors.statusCancelled;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayNameEn.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }

  Widget _buildServiceTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
