import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/language_toggle_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../domain/entities/request_enums.dart';
import '../../domain/entities/service_request_entity.dart';
import '../cubit/maintenance_cubit.dart';
import '../cubit/maintenance_state.dart';

class CreateRequestScreen extends StatefulWidget {
  final String department;

  const CreateRequestScreen({
    super.key,
    this.department = 'maintenance',
  });

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  late List<RequestCategory> _availableCategories;
  late RequestCategory _selectedCategory;
  RequestPriority _selectedPriority = RequestPriority.medium;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final DateTime _preferredDate = DateTime.now().add(const Duration(days: 1));
  String _preferredTimeSlot = '14:00 - 16:00';

  @override
  void initState() {
    super.initState();
    _availableCategories = RequestCategory.forDepartment(widget.department);
    _selectedCategory = _availableCategories.first;
  }

  final List<String> _timeSlots = [
    '09:00 - 12:00',
    '12:00 - 14:00',
    '14:00 - 16:00',
    '16:00 - 18:00',
    '18:00 - 20:00',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthCubit>().state;
    if (authState is! Authenticated) return;
    final user = authState.user;

    final prefix = widget.department == 'it_support'
        ? 'IT'
        : widget.department == 'administration'
            ? 'ADM'
            : 'REQ';
    final requestId =
        '${prefix.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}';
    final requestNumber =
        '$prefix-2026-${(1000 + DateTime.now().millisecond).toString()}';

    final request = ServiceRequestEntity(
      id: requestId,
      requestNumber: requestNumber,
      compoundId: user.compoundId,
      unitId: user.authorizedUnitIds.isNotEmpty ? user.authorizedUnitIds.first : 'unit_v104',
      unitNumber: user.primaryUnitNumber ?? 'V-104',
      createdByUserId: user.id,
      createdByEmail: user.email,
      createdByName: user.localizedName(context),
      createdByRole: user.role.toDbString(),
      department: widget.department,
      category: _selectedCategory,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _selectedPriority,
      preferredDate: _preferredDate,
      preferredTimeSlot: _preferredTimeSlot,
      currentStatus: RequestStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    context.read<MaintenanceCubit>().createRequest(request);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formattedDate = '${_preferredDate.day}/${_preferredDate.month}/${_preferredDate.year}';

    final screenTitle = widget.department == 'it_support'
        ? l10n.newItSupportTicket
        : widget.department == 'administration'
            ? l10n.newManagementComplaint
            : l10n.newMaintenanceRequest;
    final submitLabel = widget.department == 'it_support'
        ? l10n.submitToItSupport
        : widget.department == 'administration'
            ? l10n.submitToManagement
            : l10n.submitRequestToMaintenance;

    return BlocListener<MaintenanceCubit, MaintenanceState>(
      listener: (context, state) {
        if (state is MaintenanceLoaded && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.statusRejected,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is MaintenanceLoaded && state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: AppColors.statusCompleted,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primaryDark,
          title: Text(screenTitle),
          actions: const [
            LanguageToggleButton(),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Selector
                Text(
                  l10n.selectCategory,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableCategories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return InkWell(
                      onTap: () => setState(() => _selectedCategory = cat),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.accentGold : AppColors.borderLight,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(cat.iconEmoji, style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 6),
                            Text(
                              cat.localizedName(context),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 22),

                // Request Title
                Text(
                  l10n.problemTitle,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: l10n.problemTitleHint,
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.problemTitleRequired : null,
                ),
                const SizedBox(height: 18),

                // Problem Description
                Text(
                  l10n.detailedDescription,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: l10n.detailedDescriptionHint,
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.detailedDescriptionRequired : null,
                ),
                const SizedBox(height: 20),

                // Priority Selection
                Text(
                  l10n.urgencyPriority,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Row(
                  children: RequestPriority.values.map((p) {
                    final isSelected = _selectedPriority == p;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: InkWell(
                          onTap: () => setState(() => _selectedPriority = p),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.surfaceCard,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? AppColors.accentGold : AppColors.borderLight,
                              ),
                            ),
                            child: Text(
                              p.localizedName(context),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppColors.textWhite : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 22),

                // Preferred Date & Time
                Text(
                  l10n.preferredAppointmentSlot,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.accentTeal),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          l10n.tomorrowDate(formattedDate),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      const Spacer(),
                      DropdownButton<String>(
                        value: _preferredTimeSlot,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.accentGoldDark),
                        items: _timeSlots
                            .map((slot) => DropdownMenuItem(value: slot, child: Text(slot, style: const TextStyle(fontSize: 13))))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _preferredTimeSlot = val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                BlocBuilder<MaintenanceCubit, MaintenanceState>(
                  builder: (context, state) {
                    final isSubmitting = (state is MaintenanceLoaded && state.isSubmitting);
                    return ElevatedButton(
                      onPressed: isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textWhite),
                            )
                          : Text(submitLabel),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
