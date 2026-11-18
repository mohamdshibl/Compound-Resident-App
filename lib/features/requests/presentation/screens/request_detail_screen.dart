import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../domain/entities/request_enums.dart';
import '../../domain/entities/service_request_entity.dart';
import '../cubit/maintenance_cubit.dart';
import '../cubit/maintenance_state.dart';

class RequestDetailScreen extends StatefulWidget {
  final ServiceRequestEntity initialRequest;

  const RequestDetailScreen({super.key, required this.initialRequest});

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MaintenanceCubit>().selectRequest(widget.initialRequest);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _sendComment(ServiceRequestEntity req) {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final auth = context.read<AuthCubit>().state;
    if (auth is! Authenticated) return;

    context.read<MaintenanceCubit>().addComment(
          requestId: req.id,
          senderId: auth.user.id,
          senderName: auth.user.fullName,
          senderRole: auth.user.role.toDbString(),
          message: text,
        );

    _commentController.clear();
  }

  void _openAssignSheet(ServiceRequestEntity req) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final techs = [
          {'id': 'usr_tech_mahmoud', 'name': 'Technician Mahmoud (HVAC & AC)'},
          {'id': 'usr_tech_salem', 'name': 'Technician Salem (Plumbing)'},
          {'id': 'usr_maint_hassan', 'name': 'Eng. Hassan Al-Najjar (Maintenance Lead)'},
        ];

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Assign Technician', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              ...techs.map(
                (t) => ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, color: AppColors.accentGold),
                  ),
                  title: Text(t['name']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  trailing: const Icon(Icons.check_circle_outline_rounded, color: AppColors.accentTeal),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.read<MaintenanceCubit>().assignTechnician(
                          requestId: req.id,
                          employeeId: t['id']!,
                          employeeName: t['name']!,
                        );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openRatingDialog(ServiceRequestEntity req) {
    int rating = 5;
    final feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Rate Completed Service', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How satisfied are you with this maintenance repair?', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starNum = index + 1;
                  return IconButton(
                    icon: Icon(
                      starNum <= rating ? Icons.star_rounded : Icons.star_border_rounded,
                      color: AppColors.accentGold,
                      size: 32,
                    ),
                    onPressed: () => setDialogState(() => rating = starNum),
                  );
                }),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: feedbackController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Add feedback or notes (optional)...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.read<MaintenanceCubit>().submitRating(
                      requestId: req.id,
                      rating: rating,
                      feedback: feedbackController.text.trim(),
                    );
              },
              child: const Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MaintenanceCubit, MaintenanceState>(
      listener: (context, state) {
        if (state is MaintenanceLoaded && state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: AppColors.statusCompleted,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final req = (state is MaintenanceLoaded && state.selectedRequest != null)
            ? state.selectedRequest!
            : widget.initialRequest;

        final comments = (state is MaintenanceLoaded) ? state.comments : [];
        final auth = context.watch<AuthCubit>().state;
        final isEmployee = (auth is Authenticated && auth.user.isEmployee);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primaryDark,
            title: Text(req.requestNumber),
            actions: [
              if (isEmployee)
                PopupMenuButton<RequestStatus>(
                  icon: const Icon(Icons.more_vert_rounded, color: AppColors.accentGold),
                  tooltip: 'Update Status',
                  onSelected: (newStatus) {
                    context.read<MaintenanceCubit>().updateStatus(req.id, newStatus);
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      value: RequestStatus.underReview,
                      child: Text('Set: Under Review'),
                    ),
                    const PopupMenuItem(
                      value: RequestStatus.inProgress,
                      child: Text('Set: In Progress'),
                    ),
                    const PopupMenuItem(
                      value: RequestStatus.completed,
                      child: Text('Set: Completed'),
                    ),
                  ],
                ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header card
                      Container(
                        padding: const EdgeInsets.all(18),
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
                                Row(
                                  children: [
                                    Text(req.category.iconEmoji, style: const TextStyle(fontSize: 20)),
                                    const SizedBox(width: 8),
                                    Text(
                                      req.category.displayNameEn,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ],
                                ),
                                _buildStatusBadge(req.currentStatus),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              req.title,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              req.description,
                              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildInfoItem(Icons.home_outlined, 'Unit', req.unitNumber),
                                _buildInfoItem(Icons.calendar_today_outlined, 'Appointment', req.preferredTimeSlot),
                                _buildInfoItem(Icons.warning_amber_rounded, 'Priority', req.priority.displayNameEn),
                              ],
                            ),
                            if (req.assignedEmployeeName != null) ...[
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.statusAssigned.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.engineering_rounded, color: AppColors.statusAssigned, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Assigned: ${req.assignedEmployeeName}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.statusAssigned),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Status Progression Stepper
                      _buildStatusTimeline(req.currentStatus),
                      const SizedBox(height: 16),

                      // Employee Action: Assign Technician
                      if (isEmployee) ...[
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _openAssignSheet(req),
                                icon: const Icon(Icons.person_add_rounded, size: 18),
                                label: const Text('Assign Technician'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (req.currentStatus != RequestStatus.completed)
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => context.read<MaintenanceCubit>().updateStatus(req.id, RequestStatus.completed),
                                  icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                                  label: const Text('Mark Complete'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.statusCompleted,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Resident Rating Card
                      if (req.currentStatus == RequestStatus.completed) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.accentGold.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.3)),
                          ),
                          child: req.hasRating
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ...List.generate(
                                          5,
                                          (i) => Icon(
                                            i < (req.ratingValue ?? 5) ? Icons.star_rounded : Icons.star_border_rounded,
                                            color: AppColors.accentGold,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Resident Feedback',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    if (req.ratingFeedback != null && req.ratingFeedback!.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        '"${req.ratingFeedback}"',
                                        style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: AppColors.textPrimary),
                                      ),
                                    ],
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Service Completed!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                        Text('Rate your experience with our team', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _openRatingDialog(req),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.accentGold,
                                        foregroundColor: AppColors.primaryDark,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      ),
                                      child: const Text('Rate (1-5 ⭐)'),
                                    ),
                                  ],
                                ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Comments Header
                      Row(
                        children: [
                          const Icon(Icons.forum_outlined, size: 18, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Request Updates & Chat (${comments.length})',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Comments Thread
                      if (comments.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: Text(
                              'No comments yet. Send a message below to communicate directly.',
                              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                          ),
                        )
                      else
                        ...comments.map((c) => _buildCommentBubble(c, auth is Authenticated && auth.user.id == c.senderId)),
                    ],
                  ),
                ),
              ),

              // Comment Input Field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: const Border(top: BorderSide(color: AppColors.borderLight)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Type an update or question...',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: const BorderSide(color: AppColors.borderLight),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: IconButton(
                          icon: const Icon(Icons.send_rounded, color: AppColors.accentGold, size: 18),
                          onPressed: () => _sendComment(req),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildStatusTimeline(RequestStatus current) {
    final steps = ['Pending', 'Review', 'Assigned', 'In Progress', 'Done'];
    final currentIdx = current.stepIndex;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final isPast = index <= currentIdx;
          final isCurrent = index == currentIdx;

          return Expanded(
            child: Row(
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: isPast ? AppColors.statusCompleted : AppColors.borderLight,
                      child: isPast
                          ? const Icon(Icons.check, size: 14, color: AppColors.textWhite)
                          : Text('${index + 1}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      steps[index],
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: isCurrent ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (index < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index < currentIdx ? AppColors.statusCompleted : AppColors.borderLight,
                      margin: const EdgeInsets.only(bottom: 14),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCommentBubble(dynamic c, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isMe ? AppColors.primary : AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              '${c.senderName} (${c.senderRole})',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isMe ? AppColors.accentGoldLight : AppColors.accentTeal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              c.message,
              style: TextStyle(
                fontSize: 13,
                color: isMe ? AppColors.textWhite : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
