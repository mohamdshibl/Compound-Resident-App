import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/request_enums.dart';
import '../models/request_comment_model.dart';
import '../models/service_request_model.dart';

abstract class MaintenanceRemoteDataSource {
  Future<List<ServiceRequestModel>> getRequests({
    String? compoundId,
    String? userId,
    String? department,
    RequestCategory? category,
    RequestStatus? status,
  });

  Stream<List<ServiceRequestModel>> streamRequests({
    String? compoundId,
    String? userId,
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

  // In-memory demo store to ensure 100% demo stability and instant reactivity
  final List<ServiceRequestModel> _inMemoryRequests = [];
  final Map<String, List<RequestCommentModel>> _inMemoryComments = {};

  final _requestsStreamController = StreamController<List<ServiceRequestModel>>.broadcast();
  final Map<String, StreamController<List<RequestCommentModel>>> _commentsStreamControllers = {};

  MaintenanceRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance {
    _initSeedData();
  }

  void _initSeedData() {
    final now = DateTime.now();

    final r1 = ServiceRequestModel(
      id: 'req_2026_1042',
      requestNumber: 'REQ-2026-1042',
      compoundId: 'compound_al_nakheel',
      unitId: 'unit_v104',
      unitNumber: 'V-104',
      createdByUserId: 'usr_owner_tarek',
      createdByName: 'Dr. Tarek Mansour',
      createdByRole: 'owner',
      department: 'maintenance',
      category: RequestCategory.airConditioning,
      title: 'Master Bedroom AC Not Cooling',
      description: 'Central AC is blowing warm air and making a low humming noise since yesterday evening.',
      priority: RequestPriority.high,
      preferredDate: now.add(const Duration(days: 1)),
      preferredTimeSlot: '14:00 - 16:00',
      currentStatus: RequestStatus.assigned,
      assignedEmployeeId: 'usr_maint_hassan',
      assignedEmployeeName: 'Eng. Hassan Al-Najjar',
      commentsCount: 2,
      createdAt: now.subtract(const Duration(hours: 4)),
      updatedAt: now.subtract(const Duration(hours: 2)),
    );

    final r2 = ServiceRequestModel(
      id: 'req_2026_1049',
      requestNumber: 'REQ-2026-1049',
      compoundId: 'compound_al_nakheel',
      unitId: 'unit_b2_301',
      unitNumber: 'B2-301',
      createdByUserId: 'usr_tenant_sara',
      createdByName: 'Sara Al-Husseini',
      createdByRole: 'tenant',
      department: 'maintenance',
      category: RequestCategory.plumbing,
      title: 'Water Pressure Drop in Master Bath',
      description: 'Shower mixer has low water pressure during morning hours.',
      priority: RequestPriority.medium,
      preferredDate: now.add(const Duration(days: 1)),
      preferredTimeSlot: '10:00 - 12:00',
      currentStatus: RequestStatus.underReview,
      commentsCount: 0,
      createdAt: now.subtract(const Duration(hours: 8)),
      updatedAt: now.subtract(const Duration(hours: 8)),
    );

    final r3 = ServiceRequestModel(
      id: 'req_2026_1030',
      requestNumber: 'REQ-2026-1030',
      compoundId: 'compound_al_nakheel',
      unitId: 'unit_v104',
      unitNumber: 'V-104',
      createdByUserId: 'usr_owner_tarek',
      createdByName: 'Dr. Tarek Mansour',
      createdByRole: 'owner',
      department: 'maintenance',
      category: RequestCategory.electrical,
      title: 'Garden Floodlight Bulb Replacement',
      description: 'Two LED perimeter lights flickered and stopped turning on with the timer.',
      priority: RequestPriority.low,
      preferredDate: now.subtract(const Duration(days: 2)),
      preferredTimeSlot: '16:00 - 18:00',
      currentStatus: RequestStatus.completed,
      assignedEmployeeId: 'usr_maint_hassan',
      assignedEmployeeName: 'Eng. Hassan Al-Najjar',
      hasRating: true,
      ratingValue: 5,
      ratingFeedback: 'Prompt replacement and tested the timer. Excellent service.',
      commentsCount: 1,
      createdAt: now.subtract(const Duration(days: 3)),
      updatedAt: now.subtract(const Duration(days: 2)),
    );

    _inMemoryRequests.addAll([r1, r2, r3]);

    _inMemoryComments['req_2026_1042'] = [
      RequestCommentModel(
        id: 'cmt_001',
        requestId: 'req_2026_1042',
        senderId: 'usr_maint_hassan',
        senderName: 'Eng. Hassan Al-Najjar',
        senderRole: 'maintenance',
        message: 'Hello Dr. Tarek. We have received your AC ticket. Technician Mahmoud will arrive tomorrow at 2:00 PM with the pressure gauge and refrigerant kit.',
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      RequestCommentModel(
        id: 'cmt_002',
        requestId: 'req_2026_1042',
        senderId: 'usr_owner_tarek',
        senderName: 'Dr. Tarek Mansour',
        senderRole: 'owner',
        message: 'Thank you Hassan. The side villa gate will be open for Mahmoud.',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
    ];
  }

  void _notifyRequests() {
    _requestsStreamController.add(List.unmodifiable(_inMemoryRequests));
  }

  void _notifyComments(String requestId) {
    final list = _inMemoryComments[requestId] ?? [];
    if (!_commentsStreamControllers.containsKey(requestId)) {
      _commentsStreamControllers[requestId] = StreamController<List<RequestCommentModel>>.broadcast();
    }
    _commentsStreamControllers[requestId]!.add(List.unmodifiable(list));
  }

  @override
  Future<List<ServiceRequestModel>> getRequests({
    String? compoundId,
    String? userId,
    String? department,
    RequestCategory? category,
    RequestStatus? status,
  }) async {
    // Attempt Firestore fetch
    try {
      Query query = _firestore.collection('service_requests');
      if (compoundId != null) query = query.where('compoundId', isEqualTo: compoundId);
      if (userId != null) query = query.where('createdByUserId', isEqualTo: userId);
      if (department != null) query = query.where('department', isEqualTo: department);

      final snapshot = await query.get();
      if (snapshot.docs.isNotEmpty) {
        final docs = snapshot.docs.map((d) => ServiceRequestModel.fromJson(d.data() as Map<String, dynamic>, id: d.id)).toList();
        return docs;
      }
    } catch (_) {}

    // In-memory filter
    var filtered = _inMemoryRequests.where((r) {
      if (userId != null && r.createdByUserId != userId) return false;
      if (department != null && r.department != department) return false;
      if (category != null && r.category != category) return false;
      if (status != null && r.currentStatus != status) return false;
      return true;
    }).toList();

    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  @override
  Stream<List<ServiceRequestModel>> streamRequests({
    String? compoundId,
    String? userId,
    String? department,
    RequestCategory? category,
  }) {
    // Return stream controller stream and trigger initial event
    Timer.run(() => _notifyRequests());
    return _requestsStreamController.stream.map((list) {
      return list.where((r) {
        if (userId != null && r.createdByUserId != userId) return false;
        if (department != null && r.department != department) return false;
        if (category != null && r.category != category) return false;
        return true;
      }).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  @override
  Future<ServiceRequestModel> getRequestById(String id) async {
    try {
      final doc = await _firestore.collection('service_requests').doc(id).get();
      if (doc.exists && doc.data() != null) {
        return ServiceRequestModel.fromJson(doc.data()!, id: doc.id);
      }
    } catch (_) {}

    return _inMemoryRequests.firstWhere(
      (r) => r.id == id,
      orElse: () => throw Exception('Service request not found'),
    );
  }

  @override
  Future<ServiceRequestModel> createRequest(ServiceRequestModel request) async {
    _inMemoryRequests.insert(0, request);
    _notifyRequests();

    try {
      await _firestore.collection('service_requests').doc(request.id).set(request.toJson());
    } catch (_) {}

    return request;
  }

  @override
  Future<void> updateStatus({
    required String requestId,
    required RequestStatus newStatus,
  }) async {
    final idx = _inMemoryRequests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      final updated = _inMemoryRequests[idx].copyWith(
        currentStatus: newStatus,
        updatedAt: DateTime.now(),
      );
      _inMemoryRequests[idx] = ServiceRequestModel.fromEntity(updated);
      _notifyRequests();
    }

    try {
      await _firestore.collection('service_requests').doc(requestId).update({
        'currentStatus': newStatus.toDbString(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (_) {}
  }

  @override
  Future<void> assignTechnician({
    required String requestId,
    required String employeeId,
    required String employeeName,
  }) async {
    final idx = _inMemoryRequests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      final updated = _inMemoryRequests[idx].copyWith(
        assignedEmployeeId: employeeId,
        assignedEmployeeName: employeeName,
        currentStatus: RequestStatus.assigned,
        updatedAt: DateTime.now(),
      );
      _inMemoryRequests[idx] = ServiceRequestModel.fromEntity(updated);
      _notifyRequests();
    }

    try {
      await _firestore.collection('service_requests').doc(requestId).update({
        'assignedEmployeeId': employeeId,
        'assignedEmployeeName': employeeName,
        'currentStatus': RequestStatus.assigned.toDbString(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (_) {}
  }

  @override
  Future<void> addComment({
    required String requestId,
    required RequestCommentModel comment,
  }) async {
    if (!_inMemoryComments.containsKey(requestId)) {
      _inMemoryComments[requestId] = [];
    }
    _inMemoryComments[requestId]!.add(comment);

    // Update count in request
    final idx = _inMemoryRequests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      _inMemoryRequests[idx] = ServiceRequestModel.fromEntity(
        _inMemoryRequests[idx].copyWith(commentsCount: _inMemoryComments[requestId]!.length),
      );
      _notifyRequests();
    }

    _notifyComments(requestId);

    try {
      await _firestore
          .collection('service_requests')
          .doc(requestId)
          .collection('comments')
          .doc(comment.id)
          .set(comment.toJson());

      await _firestore.collection('service_requests').doc(requestId).update({
        'commentsCount': FieldValue.increment(1),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (_) {}
  }

  @override
  Future<List<RequestCommentModel>> getComments(String requestId) async {
    try {
      final snapshot = await _firestore
          .collection('service_requests')
          .doc(requestId)
          .collection('comments')
          .orderBy('createdAt', descending: false)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((d) => RequestCommentModel.fromJson(d.data(), id: d.id))
            .toList();
      }
    } catch (_) {}

    return _inMemoryComments[requestId] ?? [];
  }

  @override
  Stream<List<RequestCommentModel>> streamComments(String requestId) {
    if (!_commentsStreamControllers.containsKey(requestId)) {
      _commentsStreamControllers[requestId] = StreamController<List<RequestCommentModel>>.broadcast();
    }
    Timer.run(() => _notifyComments(requestId));
    return _commentsStreamControllers[requestId]!.stream;
  }

  @override
  Future<void> submitRating({
    required String requestId,
    required int rating,
    required String feedback,
  }) async {
    final idx = _inMemoryRequests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      _inMemoryRequests[idx] = ServiceRequestModel.fromEntity(
        _inMemoryRequests[idx].copyWith(
          hasRating: true,
          ratingValue: rating,
          ratingFeedback: feedback,
        ),
      );
      _notifyRequests();
    }

    try {
      await _firestore.collection('service_requests').doc(requestId).update({
        'hasRating': true,
        'ratingValue': rating,
        'ratingFeedback': feedback,
      });

      await _firestore.collection('ratings').add({
        'referenceId': requestId,
        'serviceType': 'maintenance',
        'rating': rating,
        'feedback': feedback,
        'createdAt': DateTime.now().toIso8601String(),
      });
    } catch (_) {}
  }
}
