import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/booking_entity.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Stream<List<BookingModel>> streamMyBookings({
    required String userEmail,
    String? userId,
    String compoundId = 'compound_al_mohamedia',
  });

  Stream<List<BookingModel>> streamCompoundBookings({
    String compoundId = 'compound_al_mohamedia',
    BookingType? bookingType,
  });

  Future<BookingModel> createBooking(BookingModel booking);

  Future<void> updateBookingStatus(
    String bookingId,
    BookingStatus status, {
    String? assignedStaffName,
  });

  Future<void> submitBookingRating({
    required String bookingId,
    required int rating,
    required String feedback,
  });
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final FirebaseFirestore _firestore;

  BookingRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _bookingsCol =>
      _firestore.collection('bookings');

  List<BookingModel> _mapAndSort(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    final list = snapshot.docs
        .map((d) => BookingModel.fromJson(d.data(), id: d.id))
        .toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Stream<List<BookingModel>> streamMyBookings({
    required String userEmail,
    String? userId,
    String compoundId = 'compound_al_mohamedia',
  }) {
    Query<Map<String, dynamic>> query = _bookingsCol.where(
      'compoundId',
      isEqualTo: compoundId,
    );
    if (userEmail.isNotEmpty) {
      query = query.where(
        'userEmail',
        isEqualTo: userEmail.trim().toLowerCase(),
      );
    } else if (userId != null && userId.isNotEmpty) {
      query = query.where('userId', isEqualTo: userId);
    }

    return query.limit(20).snapshots().map(_mapAndSort);
  }

  @override
  Stream<List<BookingModel>> streamCompoundBookings({
    String compoundId = 'compound_al_mohamedia',
    BookingType? bookingType,
  }) {
    Query<Map<String, dynamic>> query = _bookingsCol.where(
      'compoundId',
      isEqualTo: compoundId,
    );
    if (bookingType != null) {
      query = query.where('bookingType', isEqualTo: bookingType.toDbString());
    }
    return query.limit(20).snapshots().map(_mapAndSort);
  }

  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    final normalized = BookingModel.fromEntity(
      booking.copyWith(userEmail: booking.userEmail.trim().toLowerCase()),
    );
    await _bookingsCol.doc(normalized.id).set(normalized.toJson());
    return normalized;
  }

  @override
  Future<void> updateBookingStatus(
    String bookingId,
    BookingStatus status, {
    String? assignedStaffName,
  }) async {
    final data = <String, dynamic>{
      'status': status.toDbString(),
    };
    if (assignedStaffName != null && assignedStaffName.trim().isNotEmpty) {
      data['assignedStaffName'] = assignedStaffName.trim();
    }
    await _bookingsCol.doc(bookingId).update(data);
  }

  @override
  Future<void> submitBookingRating({
    required String bookingId,
    required int rating,
    required String feedback,
  }) async {
    final now = DateTime.now().toIso8601String();
    final batch = _firestore.batch();

    batch.update(_bookingsCol.doc(bookingId), {
      'hasRating': true,
      'ratingValue': rating,
      'ratingFeedback': feedback,
    });

    final ratingRef = _firestore.collection('ratings').doc();
    batch.set(ratingRef, {
      'id': ratingRef.id,
      'referenceId': bookingId,
      'serviceType': 'booking',
      'compoundId': 'compound_al_mohamedia',
      'userId': fb.FirebaseAuth.instance.currentUser?.uid ?? '',
      'rating': rating,
      'feedback': feedback,
      'createdAt': now,
    });

    await batch.commit();
  }
}
