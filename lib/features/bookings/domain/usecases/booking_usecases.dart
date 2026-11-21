import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetMyBookingsUseCase {
  final BookingRepository _repository;
  const GetMyBookingsUseCase(this._repository);

  Stream<List<BookingEntity>> call({
    required String userEmail,
    String? userId,
  }) =>
      _repository.streamMyBookings(userEmail: userEmail, userId: userId);
}

class GetCompoundBookingsUseCase {
  final BookingRepository _repository;
  const GetCompoundBookingsUseCase(this._repository);

  Stream<List<BookingEntity>> call({
    String compoundId = 'compound_al_mohamedia',
  }) =>
      _repository.streamCompoundBookings(compoundId: compoundId);
}

class CreateBookingUseCase {
  final BookingRepository _repository;
  const CreateBookingUseCase(this._repository);

  Future<BookingEntity> call(BookingEntity booking) =>
      _repository.createBooking(booking);
}

class UpdateBookingStatusUseCase {
  final BookingRepository _repository;
  const UpdateBookingStatusUseCase(this._repository);

  Future<void> call(
    String bookingId,
    BookingStatus status, {
    String? assignedStaffName,
  }) =>
      _repository.updateBookingStatus(
        bookingId,
        status,
        assignedStaffName: assignedStaffName,
      );
}

class SubmitBookingRatingUseCase {
  final BookingRepository _repository;
  const SubmitBookingRatingUseCase(this._repository);

  Future<void> call({
    required String bookingId,
    required int rating,
    required String feedback,
  }) =>
      _repository.submitBookingRating(
        bookingId: bookingId,
        rating: rating,
        feedback: feedback,
      );
}
