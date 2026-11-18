import '../../domain/entities/request_comment_entity.dart';
import '../../domain/entities/request_enums.dart';
import '../../domain/entities/service_request_entity.dart';

abstract class MaintenanceState {
  const MaintenanceState();
}

class MaintenanceInitial extends MaintenanceState {}

class MaintenanceLoading extends MaintenanceState {}

class MaintenanceLoaded extends MaintenanceState {
  final List<ServiceRequestEntity> requests;
  final RequestCategory? selectedCategory;
  final ServiceRequestEntity? selectedRequest;
  final List<RequestCommentEntity> comments;
  final bool isSubmitting;
  final String? successMessage;
  final String? errorMessage;

  const MaintenanceLoaded({
    required this.requests,
    this.selectedCategory,
    this.selectedRequest,
    this.comments = const [],
    this.isSubmitting = false,
    this.successMessage,
    this.errorMessage,
  });

  MaintenanceLoaded copyWith({
    List<ServiceRequestEntity>? requests,
    RequestCategory? selectedCategory,
    bool clearCategory = false,
    ServiceRequestEntity? selectedRequest,
    List<RequestCommentEntity>? comments,
    bool? isSubmitting,
    String? successMessage,
    String? errorMessage,
  }) {
    return MaintenanceLoaded(
      requests: requests ?? this.requests,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedRequest: selectedRequest ?? this.selectedRequest,
      comments: comments ?? this.comments,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}

class MaintenanceError extends MaintenanceState {
  final String message;
  const MaintenanceError(this.message);
}
