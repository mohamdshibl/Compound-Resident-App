import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/di/injection_container.dart';
import 'core/l10n/locale_cubit.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/requests/presentation/cubit/maintenance_cubit.dart';
import 'l10n/generated/app_localizations.dart';

class CompoundResidentApp extends StatefulWidget {
  const CompoundResidentApp({super.key});

  @override
  State<CompoundResidentApp> createState() => _CompoundResidentAppState();
}

class _CompoundResidentAppState extends State<CompoundResidentApp> {
  late final LocaleCubit _localeCubit;
  late final AuthCubit _authCubit;
  late final MaintenanceCubit _maintenanceCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _localeCubit = sl<LocaleCubit>();
    _authCubit = sl<AuthCubit>();
    _maintenanceCubit = sl<MaintenanceCubit>()..listenToRequests();
    _router = AppRouter.createRouter(_authCubit);
  }

  @override
  void dispose() {
    _localeCubit.close();
    _authCubit.close();
    _maintenanceCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>.value(value: _localeCubit),
        BlocProvider<AuthCubit>.value(value: _authCubit),
        BlocProvider<MaintenanceCubit>.value(value: _maintenanceCubit),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            onGenerateTitle: (ctx) => AppLocalizations.of(ctx).appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: _router,
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
