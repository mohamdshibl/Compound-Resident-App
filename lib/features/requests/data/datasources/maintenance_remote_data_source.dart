import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/request_enums.dart';
import '../models/request_comment_model.dart';
import '../models/service_request_model.dart';

abstract class MaintenanceRemoteDataSource {
  Future<List<ServiceRequestModel>> getRequests({
    String? compoundId,
    String? userId,
    String? userEmail,
    String? department,
    RequestCategory? category,
    RequestStatus? status,
  });

  Stream<List<ServiceRequestModel>> streamRequests({
    String? compoundId,
    String? userId,
    String? userEmail,
    String? department,
    RequestCategory? category,
  });

  Future<ServiceRequestModel> getRequestById(String id);

  Future<ServiceRequestModel> createRequest(ServiceRequestModel request);

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
    required RequestCommentModel comment,
  });

  Future<List<RequestCommentModel>> getComments(String requestId);

  Stream<List<RequestCommentModel>> streamComments(String requestId);

  Future<void> submitRating({
    required String requestId,
    required int rating,
    required String feedback,
  });
}

class MaintenanceRemoteDataSourceImpl implements MaintenanceRemoteDataSource {
  final FirebaseFirestore _firestore;

  MaintenanceRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _requestsCol =>
      _firestore.collection('service_requests');

  Query<Map<String, dynamic>> _buildQuery({
    String? compoundId,
    String? userId,
    String? userEmail,
    String? department,
  }) {
    Query<Map<String, dynamic>> query = _requestsCol;

    // Residents scope strictly by email (or userId) to satisfy Firestore RBAC rules
    if (userEmail != null && userEmail.isNotEmpty) {
      query = query.where('createdByEmail', isEqualTo: userEmail.toLowerCase());
    } else if (userId != null && userId.isNotEmpty) {
      query = query.where('createdByUserId', isEqualTo: userId);
    } else if (compoundId != null && compoundId.isNotEmpty) {
      query = query.where('compoundId', isEqualTo: compoundId);
    }

    if (department != null && department.isNotEmpty && userEmail == null && userId == null) {
      query = query.where('department', isEqualTo: department);
    }

    // Spark-tier cost guardrail: cap document reads
    return query.limit(20);
  }

  List<ServiceRequestModel> _mapAndSort(
    QuerySnapshot<Map<String, dynamic>> snapshot, {
    RequestCategory? category,
    RequestStatus? status,
  }) {
    final list = snapshot.docs
        .map((d) => ServiceRequestModel.fromJson(d.data(), id: d.id))
        .where((r) {
          if (category != null && r.category != category) return false;
          if (status != null && r.currentStatus != status) return false;
          return true;
        })
        .toList();

    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<List<ServiceRequestModel>> getRequests({
    String? compoundId,
    String? userId,
    String? userEmail,
    String? department,
    RequestCategory? category,
    RequestStatus? status,
  }) async {
    final snapshot = await _buildQuery(
      compoundId: compoundId,
      userId: userId,
      userEmail: userEmail,
      department: department,
    ).get();

    return _mapAndSort(snapshot, category: category, status: status);
  }

  @override
  Stream<List<ServiceRequestModel>> streamRequests({
    String? compoundId,
    String? userId,
    String? userEmail,
    String? department,
    RequestCategory? category,
  }) {
    return _buildQuery(
      compoundId: compoundId,
      userId: userId,
      userEmail: userEmail,
      department: department,
    ).snapshots().map((snapshot) => _mapAndSort(snapshot, category: category));
  }

  @override
  Future<ServiceRequestModel> getRequestById(String id) async {
    final doc = await _requestsCol.doc(id).get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('Service request not found');
    }
    return ServiceRequestModel.fromJson(doc.data()!, id: doc.id);
  }

  @override
  Future<ServiceRequestModel> createRequest(ServiceRequestModel request) async {
    final normalized = ServiceRequestModel.fromEntity(
      request.copyWith(createdByEmail: request.createdByEmail.toLowerCase()),
    );
    await _requestsCol.doc(normalized.id).set(normalized.toJson());
    return normalized;
  }

  @override
  Future<void> updateStatus({
    required String requestId,
    required RequestStatus newStatus,
  }) async {
    await _requestsCol.doc(requestId).update({
      'currentStatus': newStatus.toDbString(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> assignTechnician({
    required String requestId,
    required String employeeId,
    required String employeeName,
  }) async {
    await _requestsCol.doc(requestId).update({
      'assignedEmployeeId': employeeId,
      'assignedEmployeeName': employeeName,
      'currentStatus': RequestStatus.assigned.toDbString(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> addComment({
    required String requestId,
    required RequestCommentModel comment,
  }) async {
    final batch = _firestore.batch();
    final commentRef = _requestsCol
        .doc(requestId)
        .collection('comments')
        .doc(comment.id);

    batch.set(commentRef, comment.toJson());
    batch.update(_requestsCol.doc(requestId), {
      'commentsCount': FieldValue.increment(1),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    await batch.commit();
  }

  @override
  Future<List<RequestCommentModel>> getComments(String requestId) async {
    final snapshot = await _requestsCol
        .doc(requestId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .limit(50)
        .get();

    return snapshot.docs
        .map((d) => RequestCommentModel.fromJson(d.data(), id: d.id))
        .toList();
  }

  @override
  Stream<List<RequestCommentModel>> streamComments(String requestId) {
    return _requestsCol
        .doc(requestId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .limit(50)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((d) => RequestCommentModel.fromJson(d.data(), id: d.id))
              .toList(),
        );
  }

  @override
  Future<void> submitRating({
    required String requestId,
    required int rating,
    required String feedback,
  }) async {
    final now = DateTime.now().toIso8601String();
    final batch = _firestore.batch();

    batch.update(_requestsCol.doc(requestId), {
      'hasRating': true,
      'ratingValue': rating,
      'ratingFeedback': feedback,
      'updatedAt': now,
    });

    final ratingRef = _firestore.collection('ratings').doc();
    batch.set(ratingRef, {
      'id': ratingRef.id,
      'referenceId': requestId,
      'serviceType': 'maintenance',
      'rating': rating,
      'feedback': feedback,
      'createdAt': now,
    });

    await batch.commit();
  }
}
