import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/language_toggle_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../visitor_management/domain/entities/visitor_pass_entity.dart';
import '../../../visitor_management/presentation/cubit/visitor_cubit.dart';
import '../../../visitor_management/presentation/cubit/visitor_state.dart';
import '../../../visitor_management/presentation/widgets/visitor_qr_pass_dialog.dart';

class SecurityDashboardScreen extends StatefulWidget {
  const SecurityDashboardScreen({super.key});

  @override
  State<SecurityDashboardScreen> createState() =>
      _SecurityDashboardScreenState();
}

class _SecurityDashboardScreenState extends State<SecurityDashboardScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openVerifyQrDialog() {
    final l10n = context.l10n;
    final codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.verifyQrCodeTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        content: TextField(
          controller: codeController,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            hintText: l10n.verifyQrCodeHint,
            prefixIcon: const Icon(
              Icons.qr_code_scanner_rounded,
              color: AppColors.accentTeal,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final q = codeController.text.trim();
              Navigator.pop(ctx);
              _searchController.text = q;
              context.read<VisitorCubit>().setSearchQuery(q);
            },
            child: Text(l10n.verifyButton),
          ),
        ],
      ),
    );
  }

  void _openDenyDialog(VisitorPassEntity pass) {
    final l10n = context.l10n;
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.denyVisitorTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${pass.visitorName} (${pass.passCode})',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: l10n.denyReasonHint,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final notes = reasonController.text.trim().isNotEmpty
                  ? reasonController.text.trim()
                  : 'Denied at gate';
              Navigator.pop(ctx);
              context.read<VisitorCubit>().denyEntry(pass.id, notes: notes);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusRejected,
            ),
            child: Text(l10n.confirmDeny),
          ),
        ],
      ),
    );
  }

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
            title: Text(l10n.securityGateOperations),
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
          body: BlocConsumer<VisitorCubit, VisitorState>(
            listener: (context, vState) {
              if (vState is VisitorLoaded && vState.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(vState.errorMessage!),
                    backgroundColor: AppColors.statusRejected,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (vState is VisitorLoaded &&
                  vState.successMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(vState.successMessage!),
                    backgroundColor: AppColors.statusCompleted,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            builder: (context, vState) {
              if (vState is VisitorLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.accentGold),
                );
              }

              if (vState is VisitorError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      vState.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.statusRejected),
                    ),
                  ),
                );
              }

              final loaded = (vState is VisitorLoaded)
                  ? vState
                  : const VisitorLoaded(passes: []);

              final expectedList = loaded.expectedPasses;
              final checkedInList = loaded.checkedInPasses;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gate status header
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
                              color: AppColors.accentTeal.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.shield_rounded,
                              color: AppColors.accentTeal,
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
                                      l10n.officerOnDuty,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textWhite,
                                  ),
                                ),
                                Text(
                                  l10n.gateShiftActive,
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

                    // Live Firestore Metrics row
                    Row(
                      children: [
                        _buildMetricCard(
                          l10n.expectedToday,
                          '${loaded.totalExpectedCount}',
                          AppColors.statusPending,
                        ),
                        const SizedBox(width: 10),
                        _buildMetricCard(
                          l10n.onCompound,
                          '${loaded.totalCheckedInCount}',
                          AppColors.statusCompleted,
                        ),
                        const SizedBox(width: 10),
                        _buildMetricCard(
                          l10n.recentGateActivity,
                          '${loaded.totalHistoryCount}',
                          AppColors.statusAssigned,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Vehicle Plate / Visitor Name / Pass Code Search
                    TextField(
                      controller: _searchController,
                      onChanged: (val) =>
                          context.read<VisitorCubit>().setSearchQuery(val),
                      decoration: InputDecoration(
                        hintText: l10n.searchPlateOrVisitor,
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.accentTeal,
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (loaded.searchQuery.isNotEmpty)
                              IconButton(
                                icon: const Icon(
                                  Icons.clear_rounded,
                                  size: 18,
                                  color: AppColors.textMuted,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  context
                                      .read<VisitorCubit>()
                                      .setSearchQuery('');
                                },
                              ),
                            IconButton(
                              icon: const Icon(
                                Icons.qr_code_scanner_rounded,
                                color: AppColors.accentGold,
                              ),
                              onPressed: _openVerifyQrDialog,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Expected Visitors Section
                    Text(
                      '${l10n.expectedVisitors} (${expectedList.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (expectedList.isEmpty)
                      _buildEmptyCard(l10n.noExpectedVisitors)
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: expectedList.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return _buildVisitorCard(
                            context,
                            expectedList[index],
                            isExpected: true,
                          );
                        },
                      ),

                    const SizedBox(height: 24),

                    // Currently on Compound Section
                    Text(
                      '${l10n.currentlyOnCompound} (${checkedInList.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (checkedInList.isEmpty)
                      _buildEmptyCard(l10n.noVisitorsOnCompound)
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: checkedInList.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return _buildVisitorCard(
                            context,
                            checkedInList[index],
                            isExpected: false,
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

  Widget _buildEmptyCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ),
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
                fontSize: 22,
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

  Widget _buildVisitorCard(
    BuildContext context,
    VisitorPassEntity pass, {
    required bool isExpected,
  }) {
    final l10n = context.l10n;
    final statusCol = isExpected
        ? AppColors.statusPending
        : AppColors.statusCompleted;
    final plateText = (pass.vehiclePlate != null &&
            pass.vehiclePlate!.trim().isNotEmpty)
        ? pass.vehiclePlate!
        : l10n.walkInPedestrian;

    String timeInfo = '${pass.expectedArrivalTime} ${l10n.todaySuffix}';
    if (!isExpected && pass.checkInTime != null) {
      final hh = pass.checkInTime!.hour.toString().padLeft(2, '0');
      final mm = pass.checkInTime!.minute.toString().padLeft(2, '0');
      timeInfo = l10n.checkedInAt('$hh:$mm');
    }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          pass.visitorName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        pass.passCode,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentGoldDark,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusCol.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    pass.status.localizedName(context),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusCol,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.hostPrefix('${pass.unitNumber} (${pass.residentName})'),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.directions_car_rounded,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        plateText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    timeInfo,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                const Spacer(),
                if (isExpected) ...[
                  OutlinedButton(
                    onPressed: () => _openDenyDialog(pass),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.statusRejected,
                      side: const BorderSide(color: AppColors.statusRejected),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                    ),
                    child: Text(
                      l10n.denyEntry,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<VisitorCubit>().checkIn(pass.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.statusCompleted,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                    ),
                    child: Text(
                      l10n.checkIn,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ] else
                  ElevatedButton(
                    onPressed: () =>
                        context.read<VisitorCubit>().checkOut(pass.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                    ),
                    child: Text(
                      l10n.checkOut,
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
