import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/system_admin_dashboard_screen.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/housekeeping/presentation/screens/housekeeping_dashboard_screen.dart';
import '../../features/it_support/presentation/screens/it_dashboard_screen.dart';
import '../../features/maintenance/presentation/screens/maintenance_dashboard_screen.dart';
import '../../features/recreation/presentation/screens/recreation_dashboard_screen.dart';
import '../../features/requests/domain/entities/service_request_entity.dart';
import '../../features/requests/presentation/screens/create_request_screen.dart';
import '../../features/requests/presentation/screens/request_detail_screen.dart';
import '../../features/resident_dashboard/presentation/screens/resident_dashboard_screen.dart';
import '../../features/security/presentation/screens/security_dashboard_screen.dart';

class AppRouter {
  static GoRouter createRouter(AuthCubit authCubit) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: (context, state) {
        final authState = authCubit.state;
        final isLoggingIn = state.matchedLocation == '/login';
        final isSplashing = state.matchedLocation == '/';

        if (authState is Unauthenticated || authState is AuthError) {
          return isLoggingIn ? null : '/login';
        }

        if (authState is Authenticated) {
          if (isLoggingIn || isSplashing) {
            return '/dashboard';
          }
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) {
            final authState = context.watch<AuthCubit>().state;
            if (authState is! Authenticated) {
              return const LoginScreen();
            }

            final role = authState.user.role;
            switch (role) {
              case UserRole.owner:
              case UserRole.tenant:
                return const ResidentDashboardScreen();
              case UserRole.security:
                return const SecurityDashboardScreen();
              case UserRole.maintenance:
                return const MaintenanceDashboardScreen();
              case UserRole.housekeeping:
                return const HousekeepingDashboardScreen();
              case UserRole.recreation:
                return const RecreationDashboardScreen();
              case UserRole.itSupport:
                return const ItDashboardScreen();
              case UserRole.administration:
              case UserRole.finance:
              case UserRole.reception:
                return const AdminDashboardScreen();
              case UserRole.systemAdmin:
                return const SystemAdminDashboardScreen();
            }
          },
        ),
        GoRoute(
          path: '/create-request',
          builder: (context, state) => const CreateRequestScreen(),
        ),
        GoRoute(
          path: '/request-detail',
          builder: (context, state) {
            final req = state.extra as ServiceRequestEntity;
            return RequestDetailScreen(initialRequest: req);
          },
        ),
      ],
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
