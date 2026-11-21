import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/requests/data/models/request_comment_model.dart';
import '../../features/requests/data/models/service_request_model.dart';
import '../../features/requests/domain/entities/request_enums.dart';

class FirebaseSeederService {
  final FirebaseFirestore _firestore;

  FirebaseSeederService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Seeds Al-Mohamedia Compound metadata, facilities, initial maintenance
  /// requests (+ comments), and visitor passes into Cloud Firestore.
  Future<void> seedDemoData() async {
    final now = DateTime.now();
    final batch = _firestore.batch();

    // 1. Compound document
    batch.set(
      _firestore.collection('compounds').doc('compound_al_mohamedia'),
      {
        'id': 'compound_al_mohamedia',
        'name': 'Al-Mohamedia Compound',
        'nameAr': 'مجمع المحمدية',
        'city': 'Riyadh',
        'country': 'Saudi Arabia',
        'currency': 'SAR',
        'timezone': 'Asia/Riyadh',
        'contactNumber': '+966 11 400 1234',
        'emergencyNumber': '+966 11 400 9999',
        'facilitiesCount': 4,
        'unitsCount': 180,
        'createdAt': now.toIso8601String(),
      },
      SetOptions(merge: true),
    );

    // 2. Service Requests
    final requests = [
      ServiceRequestModel(
        id: 'req_2026_1042',
        requestNumber: 'REQ-2026-1042',
        compoundId: 'compound_al_mohamedia',
        unitId: 'unit_v104',
        unitNumber: 'V-104',
        createdByUserId: 'usr_owner_tarek',
        createdByEmail: 'owner@compound.demo',
        createdByName: 'Dr. Tarek Mansour',
        createdByRole: 'owner',
        department: 'maintenance',
        category: RequestCategory.airConditioning,
        title: 'Master Bedroom AC Not Cooling',
        description:
            'Central AC is blowing warm air and making a low humming noise since yesterday evening.',
        priority: RequestPriority.high,
        preferredDate: now.add(const Duration(days: 1)),
        preferredTimeSlot: '14:00 - 16:00',
        currentStatus: RequestStatus.assigned,
        assignedEmployeeId: 'usr_maint_hassan',
        assignedEmployeeName: 'Eng. Hassan Al-Najjar',
        commentsCount: 2,
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      ServiceRequestModel(
        id: 'req_2026_1049',
        requestNumber: 'REQ-2026-1049',
        compoundId: 'compound_al_mohamedia',
        unitId: 'unit_b2_301',
        unitNumber: 'B2-301',
        createdByUserId: 'usr_tenant_sara',
        createdByEmail: 'tenant@compound.demo',
        createdByName: 'Sara Al-Husseini',
        createdByRole: 'tenant',
        department: 'maintenance',
        category: RequestCategory.plumbing,
        title: 'Water Pressure Drop in Master Bath',
        description:
            'Shower mixer has low water pressure during morning hours.',
        priority: RequestPriority.medium,
        preferredDate: now.add(const Duration(days: 1)),
        preferredTimeSlot: '10:00 - 12:00',
        currentStatus: RequestStatus.underReview,
        commentsCount: 0,
        createdAt: now.subtract(const Duration(hours: 8)),
        updatedAt: now.subtract(const Duration(hours: 8)),
      ),
      ServiceRequestModel(
        id: 'req_2026_1030',
        requestNumber: 'REQ-2026-1030',
        compoundId: 'compound_al_mohamedia',
        unitId: 'unit_v104',
        unitNumber: 'V-104',
        createdByUserId: 'usr_owner_tarek',
        createdByEmail: 'owner@compound.demo',
        createdByName: 'Dr. Tarek Mansour',
        createdByRole: 'owner',
        department: 'maintenance',
        category: RequestCategory.electrical,
        title: 'Garden Floodlight Bulb Replacement',
        description:
            'Two LED perimeter lights flickered and stopped turning on with the timer.',
        priority: RequestPriority.low,
        preferredDate: now.subtract(const Duration(days: 2)),
        preferredTimeSlot: '16:00 - 18:00',
        currentStatus: RequestStatus.completed,
        assignedEmployeeId: 'usr_maint_hassan',
        assignedEmployeeName: 'Eng. Hassan Al-Najjar',
        hasRating: true,
        ratingValue: 5,
        ratingFeedback:
            'Prompt replacement and tested the timer. Excellent service.',
        commentsCount: 1,
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      ServiceRequestModel(
        id: 'it_2026_088',
        requestNumber: 'IT-2026-088',
        compoundId: 'compound_al_mohamedia',
        unitId: 'unit_v104',
        unitNumber: 'V-104',
        createdByUserId: 'usr_owner_tarek',
        createdByEmail: 'owner@compound.demo',
        createdByName: 'Dr. Tarek Mansour',
        createdByRole: 'owner',
        department: 'it_support',
        category: RequestCategory.smartIntercom,
        title: 'Smart Intercom Connection Offline',
        description:
            'Main gate video intercom screen in the villa lobby lost network connectivity.',
        priority: RequestPriority.high,
        preferredDate: now.add(const Duration(days: 1)),
        preferredTimeSlot: '10:00 - 12:00',
        currentStatus: RequestStatus.inProgress,
        assignedEmployeeId: 'usr_it_omar',
        assignedEmployeeName: 'Omar Al-Ghamdi',
        commentsCount: 0,
        createdAt: now.subtract(const Duration(hours: 5)),
        updatedAt: now.subtract(const Duration(hours: 3)),
      ),
      ServiceRequestModel(
        id: 'it_2026_091',
        requestNumber: 'IT-2026-091',
        compoundId: 'compound_al_mohamedia',
        unitId: 'unit_b2_301',
        unitNumber: 'B2-301',
        createdByUserId: 'usr_tenant_sara',
        createdByEmail: 'tenant@compound.demo',
        createdByName: 'Sara Al-Husseini',
        createdByRole: 'tenant',
        department: 'it_support',
        category: RequestCategory.internetFiber,
        title: 'Fiber Internet Speed Degradation',
        description:
            'Download speed dropped below 20 Mbps since last night across all rooms.',
        priority: RequestPriority.medium,
        preferredDate: now.add(const Duration(days: 1)),
        preferredTimeSlot: '14:00 - 16:00',
        currentStatus: RequestStatus.pending,
        commentsCount: 0,
        createdAt: now.subtract(const Duration(hours: 6)),
        updatedAt: now.subtract(const Duration(hours: 6)),
      ),
      ServiceRequestModel(
        id: 'adm_2026_014',
        requestNumber: 'ADM-2026-014',
        compoundId: 'compound_al_mohamedia',
        unitId: 'unit_v104',
        unitNumber: 'V-104',
        createdByUserId: 'usr_owner_tarek',
        createdByEmail: 'owner@compound.demo',
        createdByName: 'Dr. Tarek Mansour',
        createdByRole: 'owner',
        department: 'administration',
        category: RequestCategory.managementComplaint,
        title: 'Visitor Gate Access Delay Complaint',
        description:
            'Pre-registered family guests waited 10 minutes at Gate 1 during evening peak hours.',
        priority: RequestPriority.high,
        preferredDate: now,
        preferredTimeSlot: '16:00 - 18:00',
        currentStatus: RequestStatus.underReview,
        assignedEmployeeId: 'usr_adm_laila',
        assignedEmployeeName: 'Laila Al-Qahtani',
        commentsCount: 0,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
    ];

    for (final req in requests) {
      batch.set(
        _firestore.collection('service_requests').doc(req.id),
        req.toJson(),
        SetOptions(merge: true),
      );
    }

    // 3. Initial Comments for req_2026_1042
    final comments = [
      RequestCommentModel(
        id: 'cmt_001',
        requestId: 'req_2026_1042',
        senderId: 'usr_maint_hassan',
        senderName: 'Eng. Hassan Al-Najjar',
        senderRole: 'maintenance',
        message:
            'Hello Dr. Tarek. We have received your AC ticket. Technician Mahmoud will arrive tomorrow at 2:00 PM with the pressure gauge and refrigerant kit.',
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      RequestCommentModel(
        id: 'cmt_002',
        requestId: 'req_2026_1042',
        senderId: 'usr_owner_tarek',
        senderName: 'Dr. Tarek Mansour',
        senderRole: 'owner',
        message:
            'Thank you Hassan. The side villa gate will be open for Mahmoud.',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
    ];

    for (final c in comments) {
      batch.set(
        _firestore
            .collection('service_requests')
            .doc('req_2026_1042')
            .collection('comments')
            .doc(c.id),
        c.toJson(),
        SetOptions(merge: true),
      );
    }

    // 4. Facilities
    final facilities = [
      {
        'id': 'fac_padel_1',
        'compoundId': 'compound_al_mohamedia',
        'name': 'Padel Court 1 (Glass Court)',
        'nameAr': 'ملعب البادل ١ (ملعب زجاجي)',
        'category': 'sports',
        'hourlyRate': 80,
        'currency': 'SAR',
        'isAvailable': true,
      },
      {
        'id': 'fac_pool',
        'compoundId': 'compound_al_mohamedia',
        'name': 'Olympic Swimming Pool',
        'nameAr': 'المسبح الأولمبي',
        'category': 'pool',
        'hourlyRate': 0,
        'currency': 'SAR',
        'isAvailable': true,
      },
    ];

    for (final fac in facilities) {
      batch.set(
        _firestore.collection('facilities').doc(fac['id'] as String),
        fac,
        SetOptions(merge: true),
      );
    }

    // 5. Visitor Passes
    final todayDate = DateTime(now.year, now.month, now.day);
    final passes = [
      {
        'id': 'vp_001',
        'passCode': 'VP-4823',
        'compoundId': 'compound_al_mohamedia',
        'unitId': 'unit_v104',
        'unitNumber': 'V-104',
        'residentId': 'usr_owner_tarek',
        'residentEmail': 'owner@compound.demo',
        'residentName': 'Dr. Tarek Mansour',
        'visitorName': 'Khalid Al-Ghamdi',
        'visitorPhone': '+966 50 123 4567',
        'visitDate': todayDate.toIso8601String(),
        'expectedArrivalTime': '18:30',
        'vehiclePlate': 'ABC 4567',
        'status': 'expected',
        'createdAt': now.subtract(const Duration(hours: 2)).toIso8601String(),
      },
      {
        'id': 'vp_002',
        'passCode': 'VP-7291',
        'compoundId': 'compound_al_mohamedia',
        'unitId': 'unit_b2_301',
        'unitNumber': 'B2-301',
        'residentId': 'usr_tenant_sara',
        'residentEmail': 'tenant@compound.demo',
        'residentName': 'Sara Al-Husseini',
        'visitorName': 'Fahad Al-Shehri',
        'visitorPhone': '+966 55 987 6543',
        'visitDate': todayDate.toIso8601String(),
        'expectedArrivalTime': '19:15',
        'vehiclePlate': 'XYZ 9921',
        'status': 'expected',
        'createdAt': now.subtract(const Duration(hours: 5)).toIso8601String(),
      },
      {
        'id': 'vp_003',
        'passCode': 'VP-3344',
        'compoundId': 'compound_al_mohamedia',
        'unitId': 'unit_v104',
        'unitNumber': 'V-104',
        'residentId': 'usr_owner_tarek',
        'residentEmail': 'owner@compound.demo',
        'residentName': 'Dr. Tarek Mansour',
        'visitorName': 'Noura Al-Salem',
        'visitorPhone': '+966 56 444 5555',
        'visitDate': todayDate.toIso8601String(),
        'expectedArrivalTime': '14:00',
        'vehiclePlate': 'MNO 1122',
        'status': 'checkedIn',
        'checkInTime': now.subtract(const Duration(hours: 2)).toIso8601String(),
        'createdAt': now.subtract(const Duration(hours: 8)).toIso8601String(),
      },
    ];

    for (final p in passes) {
      batch.set(
        _firestore.collection('visitor_passes').doc(p['id'] as String),
        p,
        SetOptions(merge: true),
      );
    }

    // 6. Bookings (Recreation & Housekeeping)
    final bookings = [
      {
        'id': 'bk_rec_001',
        'bookingNumber': 'BK-2026-3310',
        'compoundId': 'compound_al_mohamedia',
        'facilityOrServiceId': 'fac_padel_1',
        'title': 'Padel Court 1 (Glass Court)',
        'titleAr': 'ملعب البادل ١ (ملعب زجاجي)',
        'bookingType': 'recreation',
        'userId': 'usr_owner_tarek',
        'userEmail': 'owner@compound.demo',
        'userName': 'Dr. Tarek Mansour',
        'unitNumber': 'V-104',
        'bookingDate': todayDate.toIso8601String(),
        'startTime': '19:00',
        'endTime': '20:00',
        'durationHours': 1,
        'totalPrice': 80,
        'currency': 'SAR',
        'status': 'confirmed',
        'hasRating': false,
        'createdAt': now.subtract(const Duration(hours: 3)).toIso8601String(),
      },
      {
        'id': 'bk_rec_002',
        'bookingNumber': 'BK-2026-3314',
        'compoundId': 'compound_al_mohamedia',
        'facilityOrServiceId': 'fac_pool',
        'title': 'Olympic Swimming Pool',
        'titleAr': 'المسبح الأولمبي',
        'bookingType': 'recreation',
        'userId': 'usr_tenant_sara',
        'userEmail': 'tenant@compound.demo',
        'userName': 'Sara Al-Husseini',
        'unitNumber': 'B2-301',
        'bookingDate': todayDate.toIso8601String(),
        'startTime': '16:00',
        'endTime': '17:00',
        'durationHours': 1,
        'totalPrice': 0,
        'currency': 'SAR',
        'status': 'confirmed',
        'hasRating': false,
        'createdAt': now.subtract(const Duration(hours: 6)).toIso8601String(),
      },
      {
        'id': 'bk_hk_001',
        'bookingNumber': 'HK-2026-8102',
        'compoundId': 'compound_al_mohamedia',
        'facilityOrServiceId': 'hk_deep',
        'title': 'Deep Villa & Sanitization Cleaning',
        'titleAr': 'تنظيف عميق وتعقيم شامل للفيلا',
        'bookingType': 'housekeeping',
        'userId': 'usr_owner_tarek',
        'userEmail': 'owner@compound.demo',
        'userName': 'Dr. Tarek Mansour',
        'unitNumber': 'V-104',
        'bookingDate': todayDate.toIso8601String(),
        'startTime': '10:00',
        'endTime': '13:00',
        'durationHours': 3,
        'totalPrice': 300,
        'currency': 'SAR',
        'status': 'confirmed',
        'assignedStaffName': 'Fatima & Sunita',
        'hasRating': false,
        'createdAt': now.subtract(const Duration(hours: 7)).toIso8601String(),
      },
      {
        'id': 'bk_hk_002',
        'bookingNumber': 'HK-2026-8109',
        'compoundId': 'compound_al_mohamedia',
        'facilityOrServiceId': 'hk_standard',
        'title': 'Standard Residence Cleaning',
        'titleAr': 'تنظيف قياسي للوحدة السكنية',
        'bookingType': 'housekeeping',
        'userId': 'usr_tenant_sara',
        'userEmail': 'tenant@compound.demo',
        'userName': 'Sara Al-Husseini',
        'unitNumber': 'B2-301',
        'bookingDate': todayDate.toIso8601String(),
        'startTime': '15:00',
        'endTime': '17:00',
        'durationHours': 2,
        'totalPrice': 200,
        'currency': 'SAR',
        'status': 'scheduled',
        'hasRating': false,
        'createdAt': now.subtract(const Duration(hours: 1)).toIso8601String(),
      },
    ];

    for (final b in bookings) {
      batch.set(
        _firestore.collection('bookings').doc(b['id'] as String),
        b,
        SetOptions(merge: true),
      );
    }

    await batch.commit();
  }
}
