import '../entities/request_comment_entity.dart';
import '../entities/request_enums.dart';
import '../entities/service_request_entity.dart';
import '../repositories/maintenance_repository.dart';

class GetRequestsUseCase {
  final MaintenanceRepository repository;
  const GetRequestsUseCase(this.repository);

  Stream<List<ServiceRequestEntity>> stream({
    String? compoundId,
    String? userId,
    String? userEmail,
    String? department,
    RequestCategory? category,
  }) {
    return repository.streamRequests(
      compoundId: compoundId,
      userId: userId,
      userEmail: userEmail,
      department: department,
      category: category,
    );
  }

  Future<List<ServiceRequestEntity>> call({
    String? compoundId,
    String? userId,
    String? userEmail,
    String? department,
    RequestCategory? category,
    RequestStatus? status,
  }) {
    return repository.getRequests(
      compoundId: compoundId,
      userId: userId,
      userEmail: userEmail,
      department: department,
      category: category,
      status: status,
    );
  }
}

class CreateRequestUseCase {
  final MaintenanceRepository repository;
  const CreateRequestUseCase(this.repository);

  Future<ServiceRequestEntity> call(ServiceRequestEntity request) {
    return repository.createRequest(request);
  }
}

class UpdateRequestStatusUseCase {
  final MaintenanceRepository repository;
  const UpdateRequestStatusUseCase(this.repository);

  Future<void> call({
    required String requestId,
    required RequestStatus newStatus,
  }) {
    return repository.updateStatus(requestId: requestId, newStatus: newStatus);
  }
}

class AssignTechnicianUseCase {
  final MaintenanceRepository repository;
  const AssignTechnicianUseCase(this.repository);

  Future<void> call({
    required String requestId,
    required String employeeId,
    required String employeeName,
  }) {
    return repository.assignTechnician(
      requestId: requestId,
      employeeId: employeeId,
      employeeName: employeeName,
    );
  }
}

class AddCommentUseCase {
  final MaintenanceRepository repository;
  const AddCommentUseCase(this.repository);

  Future<void> call({
    required String requestId,
    required RequestCommentEntity comment,
  }) {
    return repository.addComment(requestId: requestId, comment: comment);
  }

  Stream<List<RequestCommentEntity>> stream(String requestId) {
    return repository.streamComments(requestId);
  }
}

class SubmitRatingUseCase {
  final MaintenanceRepository repository;
  const SubmitRatingUseCase(this.repository);

  Future<void> call({
    required String requestId,
    required int rating,
    required String feedback,
  }) {
    return repository.submitRating(
      requestId: requestId,
      rating: rating,
      feedback: feedback,
    );
  }
}
