import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/booking_usecases.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final GetMyBookingsUseCase _getMyBookingsUseCase;
  final GetCompoundBookingsUseCase _getCompoundBookingsUseCase;
  final CreateBookingUseCase _createBookingUseCase;
  final UpdateBookingStatusUseCase _updateBookingStatusUseCase;
  final SubmitBookingRatingUseCase _submitBookingRatingUseCase;

  StreamSubscription<List<BookingEntity>>? _bookingsSub;

  BookingCubit({
    required GetMyBookingsUseCase getMyBookingsUseCase,
    required GetCompoundBookingsUseCase getCompoundBookingsUseCase,
    required CreateBookingUseCase createBookingUseCase,
    required UpdateBookingStatusUseCase updateBookingStatusUseCase,
    required SubmitBookingRatingUseCase submitBookingRatingUseCase,
  })  : _getMyBookingsUseCase = getMyBookingsUseCase,
        _getCompoundBookingsUseCase = getCompoundBookingsUseCase,
        _createBookingUseCase = createBookingUseCase,
        _updateBookingStatusUseCase = updateBookingStatusUseCase,
        _submitBookingRatingUseCase = submitBookingRatingUseCase,
        super(const BookingInitial());

  void listenToMyBookings({
    required String userEmail,
    String? userId,
  }) {
    emit(const BookingLoading());
    _bookingsSub?.cancel();

    _bookingsSub = _getMyBookingsUseCase(
      userEmail: userEmail,
      userId: userId,
    ).listen(
      (bookings) {
        if (state is BookingLoaded) {
          emit((state as BookingLoaded).copyWith(bookings: bookings));
        } else {
          emit(BookingLoaded(bookings: bookings));
        }
      },
      onError: (err) {
        emit(BookingError(err.toString()));
      },
    );
  }

  void listenToCompoundBookings({
    String compoundId = 'compound_al_mohamedia',
    BookingType? bookingType,
  }) {
    emit(const BookingLoading());
    _bookingsSub?.cancel();

    _bookingsSub = _getCompoundBookingsUseCase(
      compoundId: compoundId,
      bookingType: bookingType,
    ).listen(
      (bookings) {
        if (state is BookingLoaded) {
          emit((state as BookingLoaded).copyWith(bookings: bookings));
        } else {
          emit(BookingLoaded(bookings: bookings));
        }
      },
      onError: (err) {
        emit(BookingError(err.toString()));
      },
    );
  }

  void clear() {
    _bookingsSub?.cancel();
    emit(const BookingInitial());
  }

  Future<void> createBooking(BookingEntity booking) async {
    final cur = state is BookingLoaded
        ? state as BookingLoaded
        : const BookingLoaded(bookings: []);
    emit(cur.copyWith(isSubmitting: true));

    try {
      final created = await _createBookingUseCase(booking);
      final latest = state is BookingLoaded ? state as BookingLoaded : cur;
      emit(latest.copyWith(
        isSubmitting: false,
        successMessage: 'Reservation ${created.bookingNumber} confirmed!',
      ));
    } catch (e) {
      final latest = state is BookingLoaded ? state as BookingLoaded : cur;
      emit(latest.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to create reservation: $e',
      ));
    }
  }

  Future<void> updateStatus(
    String bookingId,
    BookingStatus status, {
    String? assignedStaffName,
  }) async {
    try {
      await _updateBookingStatusUseCase(
        bookingId,
        status,
        assignedStaffName: assignedStaffName,
      );
      if (state is BookingLoaded) {
        emit((state as BookingLoaded).copyWith(
          successMessage: assignedStaffName != null
              ? '$assignedStaffName dispatched (${status.displayNameEn})'
              : 'Booking updated to ${status.displayNameEn}',
        ));
      }
    } catch (e) {
      if (state is BookingLoaded) {
        emit((state as BookingLoaded).copyWith(
          errorMessage: 'Update failed: $e',
        ));
      }
    }
  }

  Future<void> submitRating({
    required String bookingId,
    required int rating,
    required String feedback,
  }) async {
    try {
      await _submitBookingRatingUseCase(
        bookingId: bookingId,
        rating: rating,
        feedback: feedback,
      );
      if (state is BookingLoaded) {
        emit((state as BookingLoaded).copyWith(
          successMessage: 'Thank you for rating your experience!',
        ));
      }
    } catch (e) {
      if (state is BookingLoaded) {
        emit((state as BookingLoaded).copyWith(
          errorMessage: 'Failed to submit rating: $e',
        ));
      }
    }
  }

  @override
  Future<void> close() {
    _bookingsSub?.cancel();
    return super.close();
  }
}
