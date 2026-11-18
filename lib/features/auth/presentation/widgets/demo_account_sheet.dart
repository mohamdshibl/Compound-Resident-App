import 'package:flutter/material.dart';
import '../../../../core/constants/demo_accounts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_entity.dart';

class DemoAccountSheet extends StatelessWidget {
  final Function(UserRole role) onSelectRole;

  const DemoAccountSheet({super.key, required this.onSelectRole});

  @override
  Widget build(BuildContext context) {
    final residents = DemoAccounts.list.where((a) => a.user.isResident).toList();
    final employees = DemoAccounts.list.where((a) => a.user.isEmployee).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Icon(Icons.stars_rounded, color: AppColors.accentGold, size: 24),
              SizedBox(width: 8),
              Text(
                'Instant Demo Access',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Select any predefined role below to test its dedicated dashboard immediately.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  'RESIDENT IDENTITIES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: AppColors.accentGoldDark,
                  ),
                ),
                const SizedBox(height: 8),
                ...residents.map((acc) => _buildAccountItem(context, acc)),
                const SizedBox(height: 16),
                const Text(
                  'DEPARTMENT & EMPLOYEE IDENTITIES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: AppColors.accentGoldDark,
                  ),
                ),
                const SizedBox(height: 8),
                ...employees.map((acc) => _buildAccountItem(context, acc)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountItem(BuildContext context, DemoAccount acc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(acc.icon, style: const TextStyle(fontSize: 20)),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                acc.user.fullName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: acc.user.isResident
                    ? AppColors.accentTeal.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                acc.user.role.displayNameEn.toUpperCase(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: acc.user.isResident ? AppColors.accentTeal : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          acc.subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        trailing: const Icon(Icons.arrow_forward_rounded, size: 18, color: AppColors.accentGold),
        onTap: () {
          Navigator.pop(context);
          onSelectRole(acc.user.role);
        },
      ),
    );
  }
}
