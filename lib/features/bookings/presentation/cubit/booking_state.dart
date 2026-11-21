import '../../domain/entities/booking_entity.dart';

abstract class BookingState {
  const BookingState();
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingLoading extends BookingState {
  const BookingLoading();
}

class BookingLoaded extends BookingState {
  final List<BookingEntity> bookings;
  final bool isSubmitting;
  final String? successMessage;
  final String? errorMessage;

  const BookingLoaded({
    required this.bookings,
    this.isSubmitting = false,
    this.successMessage,
    this.errorMessage,
  });

  List<BookingEntity> get recreationBookings => bookings
      .where((b) => b.bookingType == BookingType.recreation)
      .toList();

  List<BookingEntity> get housekeepingBookings => bookings
      .where((b) => b.bookingType == BookingType.housekeeping)
      .toList();

  BookingLoaded copyWith({
    List<BookingEntity>? bookings,
    bool? isSubmitting,
    String? successMessage,
    String? errorMessage,
  }) {
    return BookingLoaded(
      bookings: bookings ?? this.bookings,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);
}
