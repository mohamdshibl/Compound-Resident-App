import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:compound_resident/core/l10n/locale_cubit.dart';
import 'package:compound_resident/features/auth/domain/entities/user_entity.dart';
import 'package:compound_resident/features/bookings/domain/entities/booking_entity.dart';
import 'package:compound_resident/features/bookings/presentation/cubit/booking_state.dart';
import 'package:compound_resident/features/visitor_management/domain/entities/visitor_pass_entity.dart';
import 'package:compound_resident/features/visitor_management/presentation/cubit/visitor_state.dart';
import 'package:compound_resident/l10n/generated/app_localizations.dart';

void main() {
  test('UserRole parsing smoke test', () {
    expect(UserRole.fromString('owner'), UserRole.owner);
    expect(UserRole.fromString('security'), UserRole.security);
    expect(UserRole.fromString('maintenance'), UserRole.maintenance);
    expect(UserRole.fromString('unknown'), UserRole.tenant);
  });

  test('LocaleCubit toggles between EN and AR', () {
    final cubit = LocaleCubit();
    expect(cubit.state.languageCode, 'en');
    expect(cubit.isArabic, isFalse);

    cubit.toggleLocale();
    expect(cubit.state.languageCode, 'ar');
    expect(cubit.isArabic, isTrue);

    cubit.toggleLocale();
    expect(cubit.state.languageCode, 'en');
    cubit.close();
  });

  testWidgets('AppLocalizations renders EN LTR and AR RTL', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context).compoundName),
        ),
      ),
    );
    expect(find.text('Al-Mohamedia Compound'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('Al-Mohamedia Compound'))),
      TextDirection.ltr,
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context).compoundName),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('مجمع المحمدية'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('مجمع المحمدية'))),
      TextDirection.rtl,
    );
  });

  test('VisitorLoaded filters expected, checked-in, and plate search', () {
    final now = DateTime.now();
    final p1 = VisitorPassEntity(
      id: 'vp_1',
      passCode: 'VP-4823',
      compoundId: 'compound_al_mohamedia',
      unitId: 'unit_v104',
      unitNumber: 'V-104',
      residentId: 'usr_1',
      residentEmail: 'owner@compound.demo',
      residentName: 'Dr. Tarek',
      visitorName: 'Khalid Al-Ghamdi',
      visitorPhone: '+966500000000',
      visitDate: now,
      expectedArrivalTime: '18:30',
      vehiclePlate: 'ABC 4567',
      status: VisitorPassStatus.expected,
      createdAt: now,
    );
    final p2 = p1.copyWith(
      id: 'vp_2',
      passCode: 'VP-3344',
      status: VisitorPassStatus.checkedIn,
    );

    final state = VisitorLoaded(passes: [p1, p2], searchQuery: 'ABC 4567');
    expect(state.expectedPasses.length, 1);
    expect(state.checkedInPasses.length, 1);

    final stateByCode = state.copyWith(searchQuery: 'VP-3344');
    expect(stateByCode.expectedPasses.length, 0);
    expect(stateByCode.checkedInPasses.length, 1);
  });

  test('BookingLoaded separates recreation and housekeeping bookings', () {
    final now = DateTime.now();
    final b1 = BookingEntity(
      id: 'bk_1',
      bookingNumber: 'BK-2026-3310',
      compoundId: 'compound_al_mohamedia',
      facilityOrServiceId: 'fac_padel_1',
      title: 'Padel Court 1',
      titleAr: 'ملعب البادل ١',
      bookingType: BookingType.recreation,
      userId: 'usr_1',
      userEmail: 'owner@compound.demo',
      userName: 'Dr. Tarek',
      unitNumber: 'V-104',
      bookingDate: now,
      startTime: '19:00',
      endTime: '20:00',
      durationHours: 1,
      totalPrice: 80,
      status: BookingStatus.confirmed,
      createdAt: now,
    );
    final b2 = BookingEntity(
      id: 'bk_2',
      bookingNumber: 'HK-2026-8102',
      compoundId: 'compound_al_mohamedia',
      facilityOrServiceId: 'hk_deep',
      title: 'Deep Villa Cleaning',
      titleAr: 'تنظيف عميق للفيلا',
      bookingType: BookingType.housekeeping,
      userId: 'usr_1',
      userEmail: 'owner@compound.demo',
      userName: 'Dr. Tarek',
      unitNumber: 'V-104',
      bookingDate: now,
      startTime: '10:00',
      endTime: '13:00',
      durationHours: 3,
      totalPrice: 300,
      status: BookingStatus.scheduled,
      createdAt: now,
    );

    final state = BookingLoaded(bookings: [b1, b2]);
    expect(state.recreationBookings.length, 1);
    expect(state.housekeepingBookings.length, 1);
    expect(state.recreationBookings.first.localizedTitle(true), 'ملعب البادل ١');
    expect(state.housekeepingBookings.first.totalPrice, 300);
  });
}
