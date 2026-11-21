import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<BookingEntity>> streamMyBookings({
    required String userEmail,
    String? userId,
  }) {
    return remoteDataSource.streamMyBookings(
      userEmail: userEmail,
      userId: userId,
    );
  }

  @override
  Stream<List<BookingEntity>> streamCompoundBookings({
    String compoundId = 'compound_al_mohamedia',
    BookingType? bookingType,
  }) {
    return remoteDataSource.streamCompoundBookings(
      compoundId: compoundId,
      bookingType: bookingType,
    );
  }

  @override
  Future<BookingEntity> createBooking(BookingEntity booking) {
    return remoteDataSource.createBooking(BookingModel.fromEntity(booking));
  }

  @override
  Future<void> updateBookingStatus(
    String bookingId,
    BookingStatus status, {
    String? assignedStaffName,
  }) {
    return remoteDataSource.updateBookingStatus(
      bookingId,
      status,
      assignedStaffName: assignedStaffName,
    );
  }

  @override
  Future<void> submitBookingRating({
    required String bookingId,
    required int rating,
    required String feedback,
  }) {
    return remoteDataSource.submitBookingRating(
      bookingId: bookingId,
      rating: rating,
      feedback: feedback,
    );
  }
}
