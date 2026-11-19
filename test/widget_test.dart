import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:compound_resident/core/l10n/locale_cubit.dart';
import 'package:compound_resident/features/auth/domain/entities/user_entity.dart';
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
}
