import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class MaintenanceDashboardScreen extends StatelessWidget {
  const MaintenanceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = (state is Authenticated) ? state.user : null;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primaryDark,
            title: const Text('Maintenance Work Orders'),
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
                              user?.fullName ?? 'Maintenance Lead',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textWhite,
                              ),
                            ),
                            const Text(
                              'Technical Operations • 4 Technicians on Duty',
                              style: TextStyle(fontSize: 12, color: AppColors.accentGoldLight),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Metrics
                Row(
                  children: [
                    _buildMetricCard('New', '3', AppColors.statusPending),
                    const SizedBox(width: 10),
                    _buildMetricCard('Assigned', '5', AppColors.statusAssigned),
                    const SizedBox(width: 10),
                    _buildMetricCard('In Progress', '2', AppColors.statusInProgress),
                    const SizedBox(width: 10),
                    _buildMetricCard('Completed', '24', AppColors.statusCompleted),
                  ],
                ),
                const SizedBox(height: 20),

                // Category Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All (10)', true),
                      const SizedBox(width: 8),
                      _buildFilterChip('AC / HVAC ❄️', false),
                      const SizedBox(width: 8),
                      _buildFilterChip('Plumbing 🚿', false),
                      const SizedBox(width: 8),
                      _buildFilterChip('Electrical ⚡', false),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Active Work Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                // Sample Work Order 1
                _buildOrderCard(
                  ticketId: 'REQ-2026-1042',
                  title: 'Master Bedroom AC Not Cooling',
                  category: 'Air Conditioning',
                  unit: 'Villa V-104 (Dr. Tarek)',
                  priority: 'HIGH PRIORITY',
                  priorityColor: AppColors.statusRejected,
                  status: 'ASSIGNED',
                  statusColor: AppColors.statusAssigned,
                  technician: 'Technician Mahmoud Assigned',
                ),
                const SizedBox(height: 12),

                // Sample Work Order 2
                _buildOrderCard(
                  ticketId: 'REQ-2026-1049',
                  title: 'Water Pressure Drop in Bathroom',
                  category: 'Plumbing',
                  unit: 'Apt B2-301 (Sara)',
                  priority: 'MEDIUM',
                  priorityColor: AppColors.statusPending,
                  status: 'NEW',
                  statusColor: AppColors.statusPending,
                  technician: 'Unassigned',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
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

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
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
    );
  }

  Widget _buildOrderCard({
    required String ticketId,
    required String title,
    required String category,
    required String unit,
    required String priority,
    required Color priorityColor,
    required String status,
    required Color statusColor,
    required String technician,
  }) {
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
              Text(
                ticketId,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  priority,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: priorityColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('$category • $unit', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.person_outline_rounded, size: 16, color: AppColors.accentTeal),
                  const SizedBox(width: 4),
                  Text(technician, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: Size.zero,
                ),
                child: const Text('Manage', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
