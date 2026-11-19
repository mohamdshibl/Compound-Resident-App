import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../l10n/locale_cubit.dart';
import '../services/firebase_seeder_service.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/requests/data/datasources/maintenance_remote_data_source.dart';
import '../../features/requests/data/repositories/maintenance_repository_impl.dart';
import '../../features/requests/domain/repositories/maintenance_repository.dart';
import '../../features/requests/domain/usecases/maintenance_usecases.dart';
import '../../features/requests/presentation/cubit/maintenance_cubit.dart';
import '../../features/visitor_management/data/datasources/visitor_remote_data_source.dart';
import '../../features/visitor_management/data/repositories/visitor_repository_impl.dart';
import '../../features/visitor_management/domain/repositories/visitor_repository.dart';
import '../../features/visitor_management/domain/usecases/visitor_usecases.dart';
import '../../features/visitor_management/presentation/cubit/visitor_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseSeederService>(
    () => FirebaseSeederService(firestore: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );
  sl.registerLazySingleton<MaintenanceRemoteDataSource>(
    () => MaintenanceRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<VisitorRemoteDataSource>(
    () => VisitorRemoteDataSourceImpl(firestore: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<MaintenanceRepository>(
    () => MaintenanceRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<VisitorRepository>(
    () => VisitorRepositoryImpl(remoteDataSource: sl()),
  );

  // Auth Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LoginDemoUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Maintenance Use Cases
  sl.registerLazySingleton(() => GetRequestsUseCase(sl()));
  sl.registerLazySingleton(() => CreateRequestUseCase(sl()));
  sl.registerLazySingleton(() => UpdateRequestStatusUseCase(sl()));
  sl.registerLazySingleton(() => AssignTechnicianUseCase(sl()));
  sl.registerLazySingleton(() => AddCommentUseCase(sl()));
  sl.registerLazySingleton(() => SubmitRatingUseCase(sl()));

  // Visitor Use Cases
  sl.registerLazySingleton(() => GetMyPassesUseCase(sl()));
  sl.registerLazySingleton(() => GetCompoundPassesUseCase(sl()));
  sl.registerLazySingleton(() => SearchVisitorsUseCase(sl()));
  sl.registerLazySingleton(() => CreateVisitorPassUseCase(sl()));
  sl.registerLazySingleton(() => CheckInVisitorUseCase(sl()));
  sl.registerLazySingleton(() => CheckOutVisitorUseCase(sl()));
  sl.registerLazySingleton(() => DenyVisitorEntryUseCase(sl()));

  // Cubits / Blocs
  sl.registerFactory(() => LocaleCubit());

  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      loginDemoUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => MaintenanceCubit(
      getRequestsUseCase: sl(),
      createRequestUseCase: sl(),
      updateStatusUseCase: sl(),
      assignTechnicianUseCase: sl(),
      addCommentUseCase: sl(),
      submitRatingUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => VisitorCubit(
      getMyPassesUseCase: sl(),
      getCompoundPassesUseCase: sl(),
      createVisitorPassUseCase: sl(),
      checkInVisitorUseCase: sl(),
      checkOutVisitorUseCase: sl(),
      denyVisitorEntryUseCase: sl(),
    ),
  );
}
