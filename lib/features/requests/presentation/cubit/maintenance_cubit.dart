import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/request_comment_entity.dart';
import '../../domain/entities/request_enums.dart';
import '../../domain/entities/service_request_entity.dart';
import '../../domain/usecases/maintenance_usecases.dart';
import 'maintenance_state.dart';

class MaintenanceCubit extends Cubit<MaintenanceState> {
  final GetRequestsUseCase _getRequestsUseCase;
  final CreateRequestUseCase _createRequestUseCase;
  final UpdateRequestStatusUseCase _updateStatusUseCase;
  final AssignTechnicianUseCase _assignTechnicianUseCase;
  final AddCommentUseCase _addCommentUseCase;
  final SubmitRatingUseCase _submitRatingUseCase;

  StreamSubscription<List<ServiceRequestEntity>>? _requestsSub;
  StreamSubscription<List<RequestCommentEntity>>? _commentsSub;

  MaintenanceCubit({
    required GetRequestsUseCase getRequestsUseCase,
    required CreateRequestUseCase createRequestUseCase,
    required UpdateRequestStatusUseCase updateStatusUseCase,
    required AssignTechnicianUseCase assignTechnicianUseCase,
    required AddCommentUseCase addCommentUseCase,
    required SubmitRatingUseCase submitRatingUseCase,
  })  : _getRequestsUseCase = getRequestsUseCase,
        _createRequestUseCase = createRequestUseCase,
        _updateStatusUseCase = updateStatusUseCase,
        _assignTechnicianUseCase = assignTechnicianUseCase,
        _addCommentUseCase = addCommentUseCase,
        _submitRatingUseCase = submitRatingUseCase,
        super(MaintenanceInitial());

  void listenToRequests({String? userId, String? department}) {
    emit(MaintenanceLoading());
    _requestsSub?.cancel();

    _requestsSub = _getRequestsUseCase
        .stream(userId: userId, department: department)
        .listen(
      (requests) {
        if (state is MaintenanceLoaded) {
          final cur = state as MaintenanceLoaded;
          emit(cur.copyWith(requests: requests));
        } else {
          emit(MaintenanceLoaded(requests: requests));
        }
      },
      onError: (err) {
        emit(MaintenanceError(err.toString()));
      },
    );
  }

  void filterByCategory(RequestCategory? category) {
    if (state is MaintenanceLoaded) {
      final cur = state as MaintenanceLoaded;
      emit(cur.copyWith(
        selectedCategory: category,
        clearCategory: category == null,
      ));
    }
  }

  void selectRequest(ServiceRequestEntity request) {
    if (state is MaintenanceLoaded) {
      final cur = state as MaintenanceLoaded;
      emit(cur.copyWith(selectedRequest: request));
      _listenToComments(request.id);
    }
  }

  void _listenToComments(String requestId) {
    _commentsSub?.cancel();
    _commentsSub = _addCommentUseCase.stream(requestId).listen((comments) {
      if (state is MaintenanceLoaded) {
        final cur = state as MaintenanceLoaded;
        emit(cur.copyWith(comments: comments));
      }
    });
  }

  Future<void> createRequest(ServiceRequestEntity request) async {
    if (state is! MaintenanceLoaded) return;
    final cur = state as MaintenanceLoaded;
    emit(cur.copyWith(isSubmitting: true));

    try {
      final created = await _createRequestUseCase(request);
      emit(cur.copyWith(
        isSubmitting: false,
        selectedRequest: created,
        successMessage: 'Maintenance request #${created.requestNumber} submitted successfully!',
      ));
    } catch (e) {
      emit(cur.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to submit request: $e',
      ));
    }
  }

  Future<void> updateStatus(String requestId, RequestStatus newStatus) async {
    try {
      await _updateStatusUseCase(requestId: requestId, newStatus: newStatus);
      if (state is MaintenanceLoaded) {
        final cur = state as MaintenanceLoaded;
        if (cur.selectedRequest?.id == requestId) {
          emit(cur.copyWith(
            selectedRequest: cur.selectedRequest!.copyWith(currentStatus: newStatus),
            successMessage: 'Status updated to ${newStatus.displayNameEn}',
          ));
        }
      }
    } catch (e) {
      if (state is MaintenanceLoaded) {
        emit((state as MaintenanceLoaded).copyWith(errorMessage: 'Failed to update status: $e'));
      }
    }
  }

  Future<void> assignTechnician({
    required String requestId,
    required String employeeId,
    required String employeeName,
  }) async {
    try {
      await _assignTechnicianUseCase(
        requestId: requestId,
        employeeId: employeeId,
        employeeName: employeeName,
      );
      if (state is MaintenanceLoaded) {
        final cur = state as MaintenanceLoaded;
        if (cur.selectedRequest?.id == requestId) {
          emit(cur.copyWith(
            selectedRequest: cur.selectedRequest!.copyWith(
              assignedEmployeeId: employeeId,
              assignedEmployeeName: employeeName,
              currentStatus: RequestStatus.assigned,
            ),
            successMessage: '$employeeName assigned successfully',
          ));
        }
      }
    } catch (e) {
      if (state is MaintenanceLoaded) {
        emit((state as MaintenanceLoaded).copyWith(errorMessage: 'Failed to assign: $e'));
      }
    }
  }

  Future<void> addComment({
    required String requestId,
    required String senderId,
    required String senderName,
    required String senderRole,
    required String message,
  }) async {
    if (message.trim().isEmpty) return;

    final comment = RequestCommentEntity(
      id: 'cmt_${DateTime.now().millisecondsSinceEpoch}',
      requestId: requestId,
      senderId: senderId,
      senderName: senderName,
      senderRole: senderRole,
      message: message.trim(),
      createdAt: DateTime.now(),
    );

    try {
      await _addCommentUseCase(requestId: requestId, comment: comment);
    } catch (_) {}
  }

  Future<void> submitRating({
    required String requestId,
    required int rating,
    required String feedback,
  }) async {
    try {
      await _submitRatingUseCase(
        requestId: requestId,
        rating: rating,
        feedback: feedback,
      );
      if (state is MaintenanceLoaded) {
        final cur = state as MaintenanceLoaded;
        if (cur.selectedRequest?.id == requestId) {
          emit(cur.copyWith(
            selectedRequest: cur.selectedRequest!.copyWith(
              hasRating: true,
              ratingValue: rating,
              ratingFeedback: feedback,
            ),
            successMessage: 'Thank you for your rating!',
          ));
        }
      }
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _requestsSub?.cancel();
    _commentsSub?.cancel();
    return super.close();
  }
}
