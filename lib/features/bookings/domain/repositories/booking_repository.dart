import '../entities/booking_entity.dart';

abstract class BookingRepository {
  /// Live Cloud Firestore stream of bookings for a specific resident.
  Stream<List<BookingEntity>> streamMyBookings({
    required String userEmail,
    String? userId,
  });

  /// Live Cloud Firestore stream of all compound bookings (Recreation & Housekeeping staff).
  Stream<List<BookingEntity>> streamCompoundBookings({
    String compoundId = 'compound_al_mohamedia',
    BookingType? bookingType,
  });

  /// Create a new facility or housekeeping booking in Cloud Firestore.
  Future<BookingEntity> createBooking(BookingEntity booking);

  /// Update booking status (and optional assigned staff name).
  Future<void> updateBookingStatus(
    String bookingId,
    BookingStatus status, {
    String? assignedStaffName,
  });

  /// Submit a 1-5 star rating for a completed booking.
  Future<void> submitBookingRating({
    required String bookingId,
    required int rating,
    required String feedback,
  });
}
