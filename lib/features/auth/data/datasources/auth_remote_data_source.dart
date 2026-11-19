import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/demo_accounts.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserModel> loginWithDemoAccount(UserRole role);
  Future<void> logout();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final fb.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  // Active in-memory user for demo sessions
  UserModel? _currentDemoUser;
  final _demoUserStreamController = StreamController<UserModel?>.broadcast();

  AuthRemoteDataSourceImpl({
    fb.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel?> getCurrentUser() async {
    if (_currentDemoUser != null) {
      return _currentDemoUser;
    }

    final fbUser = _firebaseAuth.currentUser;
    if (fbUser == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(fbUser.uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!, id: doc.id);
      }
    } catch (_) {
      // Fallback
    }

    // Default fallback from auth
    return UserModel(
      id: fbUser.uid,
      email: fbUser.email ?? '',
      fullName: fbUser.displayName ?? 'Resident User',
      phone: fbUser.phoneNumber ?? '',
      role: UserRole.owner,
      compoundId: 'compound_al_mohamedia',
    );
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    // Check if it's a known demo email
    final demoAcc = DemoAccounts.findByEmail(email);
    if (demoAcc != null && password == demoAcc.password) {
      _currentDemoUser = UserModel.fromEntity(demoAcc.user);
      _demoUserStreamController.add(_currentDemoUser);
      return _currentDemoUser!;
    }

    // Attempt Firebase Authentication
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = credential.user!.uid;

      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final model = UserModel.fromJson(doc.data()!, id: doc.id);
        _currentDemoUser = model;
        return model;
      }

      // If no doc in firestore, create one
      final newModel = UserModel(
        id: uid,
        email: email,
        fullName: credential.user?.displayName ?? email.split('@').first,
        phone: credential.user?.phoneNumber ?? '',
        role: UserRole.owner,
        compoundId: 'compound_al_mohamedia',
      );
      await _firestore.collection('users').doc(uid).set(newModel.toJson());
      _currentDemoUser = newModel;
      return newModel;
    } on fb.FirebaseAuthException catch (e) {
      // If user not found in firebase auth, check demo accounts or throw friendly message
      if (demoAcc != null) {
        _currentDemoUser = UserModel.fromEntity(demoAcc.user);
        _demoUserStreamController.add(_currentDemoUser);
        return _currentDemoUser!;
      }
      throw Exception(e.message ?? 'Authentication failed');
    }
  }

  @override
  Future<UserModel> loginWithDemoAccount(UserRole role) async {
    final account = DemoAccounts.list.firstWhere(
      (a) => a.user.role == role,
      orElse: () => DemoAccounts.list.first,
    );

    _currentDemoUser = UserModel.fromEntity(account.user);
    _demoUserStreamController.add(_currentDemoUser);

    // Optionally ensure user doc exists in Firestore in background
    try {
      await _firestore
          .collection('users')
          .doc(account.user.id)
          .set(_currentDemoUser!.toJson(), SetOptions(merge: true));
    } catch (_) {
      // Offline/Spark read-only fallback works fine
    }

    return _currentDemoUser!;
  }

  @override
  Future<void> logout() async {
    _currentDemoUser = null;
    _demoUserStreamController.add(null);
    try {
      await _firebaseAuth.signOut();
    } catch (_) {}
  }

  @override
  Stream<UserModel?> get authStateChanges => _demoUserStreamController.stream;
}
