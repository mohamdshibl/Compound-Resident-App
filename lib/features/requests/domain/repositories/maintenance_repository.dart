import '../entities/request_comment_entity.dart';
import '../entities/request_enums.dart';
import '../entities/service_request_entity.dart';

abstract class MaintenanceRepository {
  Future<List<ServiceRequestEntity>> getRequests({
    String? compoundId,
    String? userId,
    String? department,
    RequestCategory? category,
    RequestStatus? status,
  });

  Stream<List<ServiceRequestEntity>> streamRequests({
    String? compoundId,
    String? userId,
    String? department,
    RequestCategory? category,
  });

  Future<ServiceRequestEntity> getRequestById(String id);

  Future<ServiceRequestEntity> createRequest(ServiceRequestEntity request);

  Future<void> updateStatus({
    required String requestId,
    required RequestStatus newStatus,
  });

  Future<void> assignTechnician({
    required String requestId,
    required String employeeId,
    required String employeeName,
  });

  Future<void> addComment({
    required String requestId,
    required RequestCommentEntity comment,
  });

  Future<List<RequestCommentEntity>> getComments(String requestId);

  Stream<List<RequestCommentEntity>> streamComments(String requestId);

  Future<void> submitRating({
    required String requestId,
    required int rating,
    required String feedback,
  });
}
