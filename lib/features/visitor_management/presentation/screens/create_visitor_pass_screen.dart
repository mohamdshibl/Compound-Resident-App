import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/language_toggle_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../domain/entities/visitor_pass_entity.dart';
import '../cubit/visitor_cubit.dart';
import '../cubit/visitor_state.dart';
import '../widgets/visitor_qr_pass_dialog.dart';

class CreateVisitorPassScreen extends StatefulWidget {
  const CreateVisitorPassScreen({super.key});

  @override
  State<CreateVisitorPassScreen> createState() =>
      _CreateVisitorPassScreenState();
}

class _CreateVisitorPassScreenState extends State<CreateVisitorPassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _visitorNameController = TextEditingController();
  final _visitorPhoneController = TextEditingController();
  final _vehiclePlateController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _visitDate = DateTime.now();
  String _expectedArrivalTime = '18:00';

  final List<String> _arrivalSlots = const [
    '09:00',
    '12:00',
    '14:00',
    '16:00',
    '18:00',
    '19:30',
    '21:00',
  ];

  @override
  void dispose() {
    _visitorNameController.dispose();
    _visitorPhoneController.dispose();
    _vehiclePlateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickVisitDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _visitDate,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _visitDate = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthCubit>().state;
    if (authState is! Authenticated) return;
    final user = authState.user;

    final passId = 'vp_${DateTime.now().millisecondsSinceEpoch}';
    final passCode = 'VP-${1000 + Random().nextInt(8999)}';
    final plate = _vehiclePlateController.text.trim();
    final notes = _notesController.text.trim();

    final pass = VisitorPassEntity(
      id: passId,
      passCode: passCode,
      compoundId: user.compoundId,
      unitId: user.authorizedUnitIds.isNotEmpty
          ? user.authorizedUnitIds.first
          : 'unit_v104',
      unitNumber: user.primaryUnitNumber ?? 'V-104',
      residentId: user.id,
      residentEmail: user.email,
      residentName: user.localizedName(context),
      visitorName: _visitorNameController.text.trim(),
      visitorPhone: _visitorPhoneController.text.trim(),
      visitDate: DateTime(_visitDate.year, _visitDate.month, _visitDate.day),
      expectedArrivalTime: _expectedArrivalTime,
      vehiclePlate: plate.isNotEmpty ? plate.toUpperCase() : null,
      status: VisitorPassStatus.expected,
      securityNotes: notes.isNotEmpty ? notes : null,
      createdAt: DateTime.now(),
    );

    context.read<VisitorCubit>().createPass(pass);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formattedDate =
        '${_visitDate.day}/${_visitDate.month}/${_visitDate.year}';

    return BlocListener<VisitorCubit, VisitorState>(
      listener: (context, state) async {
        if (state is VisitorLoaded && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.statusRejected,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is VisitorLoaded &&
            state.lastCreatedPass != null &&
            state.successMessage != null) {
          final created = state.lastCreatedPass!;
          await showVisitorPassQrDialog(context, created);
          if (context.mounted) {
            context.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primaryDark,
          title: Text(l10n.createVisitorPassTitle),
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
                // Visitor Full Name
                Text(
                  l10n.visitorFullName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _visitorNameController,
                  decoration: InputDecoration(
                    hintText: l10n.visitorFullNameHint,
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.visitorFullNameRequired
                      : null,
                ),
                const SizedBox(height: 18),

                // Visitor Phone Number
                Text(
                  l10n.visitorPhone,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _visitorPhoneController,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    hintText: l10n.visitorPhoneHint,
                    prefixIcon: const Icon(
                      Icons.phone_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.visitorPhoneRequired
                      : null,
                ),
                const SizedBox(height: 18),

                // Visit Date & Expected Arrival Time
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.visitDateLabel,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _pickVisitDate,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceCard,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.borderLight,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_rounded,
                                    size: 18,
                                    color: AppColors.accentTeal,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.expectedArrivalTimeLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _expectedArrivalTime,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.access_time_rounded,
                                  color: AppColors.accentGoldDark,
                                  size: 18,
                                ),
                                items: _arrivalSlots
                                    .map(
                                      (t) => DropdownMenuItem(
                                        value: t,
                                        child: Text(
                                          t,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _expectedArrivalTime = val);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Vehicle Plate Number (Optional)
                Text(
                  l10n.vehiclePlateOptional,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _vehiclePlateController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: l10n.vehiclePlateHint,
                    prefixIcon: const Icon(
                      Icons.directions_car_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Security Notes (Optional)
                Text(
                  l10n.securityNotesOptional,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: l10n.securityNotesHint,
                    prefixIcon: const Icon(
                      Icons.notes_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                BlocBuilder<VisitorCubit, VisitorState>(
                  builder: (context, state) {
                    final isSubmitting =
                        state is VisitorLoaded && state.isSubmitting;
                    return ElevatedButton.icon(
                      onPressed: isSubmitting ? null : _submit,
                      icon: isSubmitting
                          ? const SizedBox.shrink()
                          : const Icon(Icons.qr_code_2_rounded),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      label: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.textWhite,
                              ),
                            )
                          : Text(l10n.generateQrPass),
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
