import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'core/di/injection_container.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/requests/presentation/cubit/maintenance_cubit.dart';

class CompoundResidentApp extends StatefulWidget {
  const CompoundResidentApp({super.key});

  @override
  State<CompoundResidentApp> createState() => _CompoundResidentAppState();
}

class _CompoundResidentAppState extends State<CompoundResidentApp> {
  late final AuthCubit _authCubit;
  late final MaintenanceCubit _maintenanceCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authCubit = sl<AuthCubit>();
    _maintenanceCubit = sl<MaintenanceCubit>()..listenToRequests();
    _router = AppRouter.createRouter(_authCubit);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: _authCubit),
        BlocProvider<MaintenanceCubit>.value(value: _maintenanceCubit),
      ],
      child: MaterialApp.router(
        title: 'Compound Resident App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _router,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ar', 'SA'),
        ],
      ),
    );
  }
}
