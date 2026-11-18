import '../../domain/entities/request_comment_entity.dart';
import '../../domain/entities/request_enums.dart';
import '../../domain/entities/service_request_entity.dart';
import '../../domain/repositories/maintenance_repository.dart';
import '../datasources/maintenance_remote_data_source.dart';
import '../models/request_comment_model.dart';
import '../models/service_request_model.dart';

class MaintenanceRepositoryImpl implements MaintenanceRepository {
  final MaintenanceRemoteDataSource remoteDataSource;

  MaintenanceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ServiceRequestEntity>> getRequests({
    String? compoundId,
    String? userId,
    String? department,
    RequestCategory? category,
    RequestStatus? status,
  }) {
    return remoteDataSource.getRequests(
      compoundId: compoundId,
      userId: userId,
      department: department,
      category: category,
      status: status,
    );
  }

  @override
  Stream<List<ServiceRequestEntity>> streamRequests({
    String? compoundId,
    String? userId,
    String? department,
    RequestCategory? category,
  }) {
    return remoteDataSource.streamRequests(
      compoundId: compoundId,
      userId: userId,
      department: department,
      category: category,
    );
  }

  @override
  Future<ServiceRequestEntity> getRequestById(String id) {
    return remoteDataSource.getRequestById(id);
  }

  @override
  Future<ServiceRequestEntity> createRequest(ServiceRequestEntity request) {
    return remoteDataSource.createRequest(ServiceRequestModel.fromEntity(request));
  }

  @override
  Future<void> updateStatus({
    required String requestId,
    required RequestStatus newStatus,
  }) {
    return remoteDataSource.updateStatus(
      requestId: requestId,
      newStatus: newStatus,
    );
  }

  @override
  Future<void> assignTechnician({
    required String requestId,
    required String employeeId,
    required String employeeName,
  }) {
    return remoteDataSource.assignTechnician(
      requestId: requestId,
      employeeId: employeeId,
      employeeName: employeeName,
    );
  }

  @override
  Future<void> addComment({
    required String requestId,
    required RequestCommentEntity comment,
  }) {
    return remoteDataSource.addComment(
      requestId: requestId,
      comment: RequestCommentModel.fromEntity(comment),
    );
  }

  @override
  Future<List<RequestCommentEntity>> getComments(String requestId) {
    return remoteDataSource.getComments(requestId);
  }

  @override
  Stream<List<RequestCommentEntity>> streamComments(String requestId) {
    return remoteDataSource.streamComments(requestId);
  }

  @override
  Future<void> submitRating({
    required String requestId,
    required int rating,
    required String feedback,
  }) {
    return remoteDataSource.submitRating(
      requestId: requestId,
      rating: rating,
      feedback: feedback,
    );
  }
}
