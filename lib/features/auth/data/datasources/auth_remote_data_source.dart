import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
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

  AuthRemoteDataSourceImpl({
    fb.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel?> getCurrentUser() async {
    final fbUser = _firebaseAuth.currentUser;
    if (fbUser == null) return null;
    return _fetchOrCreateUserProfile(fbUser);
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final demoAcc = DemoAccounts.findByEmail(normalizedEmail);

    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      return _fetchOrCreateUserProfile(
        credential.user!,
        template: demoAcc?.user,
      );
    } on fb.FirebaseAuthException catch (e) {
      // Auto-provision known demo accounts in Firebase Auth on first login
      final canAutoProvision = demoAcc != null &&
          password == demoAcc.password &&
          (e.code == 'user-not-found' || e.code == 'invalid-credential');

      if (canAutoProvision) {
        return _provisionDemoUser(demoAcc);
      }

      throw Exception(_mapAuthError(e));
    }
  }

  @override
  Future<UserModel> loginWithDemoAccount(UserRole role) async {
    final account = DemoAccounts.list.firstWhere(
      (a) => a.user.role == role,
      orElse: () => DemoAccounts.list.first,
    );

    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: account.email,
        password: account.password,
      );
      return _fetchOrCreateUserProfile(
        credential.user!,
        template: account.user,
      );
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        return _provisionDemoUser(account);
      }
      throw Exception(_mapAuthError(e));
    }
  }

  Future<UserModel> _provisionDemoUser(DemoAccount account) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: account.email,
        password: account.password,
      );
      final fbUser = credential.user!;
      await fbUser.updateDisplayName(account.user.fullName);

      final model = _buildModelFromTemplate(fbUser.uid, account.user);
      await _firestore
          .collection('users')
          .doc(fbUser.uid)
          .set(model.toJson(), SetOptions(merge: true));
      return model;
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: account.email,
          password: account.password,
        );
        return _fetchOrCreateUserProfile(
          credential.user!,
          template: account.user,
        );
      }
      throw Exception(_mapAuthError(e));
    }
  }

  Future<UserModel> _fetchOrCreateUserProfile(
    fb.User fbUser, {
    UserEntity? template,
  }) async {
    final docRef = _firestore.collection('users').doc(fbUser.uid);
    final doc = await docRef.get();

    if (doc.exists && doc.data() != null) {
      return UserModel.fromJson(doc.data()!, id: doc.id);
    }

    final demoFallback =
        template ?? DemoAccounts.findByEmail(fbUser.email ?? '')?.user;
    final model = demoFallback != null
        ? _buildModelFromTemplate(fbUser.uid, demoFallback)
        : UserModel(
            id: fbUser.uid,
            email: fbUser.email ?? '',
            fullName: fbUser.displayName ??
                (fbUser.email?.split('@').first ?? 'Resident'),
            phone: fbUser.phoneNumber ?? '',
            role: UserRole.owner,
            compoundId: 'compound_al_mohamedia',
            compoundName: 'Al-Mohamedia Compound',
          );

    await docRef.set(model.toJson(), SetOptions(merge: true));
    return model;
  }

  UserModel _buildModelFromTemplate(String uid, UserEntity template) {
    return UserModel(
      id: uid,
      email: template.email,
      fullName: template.fullName,
      fullNameAr: template.fullNameAr,
      phone: template.phone,
      role: template.role,
      department: template.department,
      compoundId: template.compoundId,
      compoundName: template.compoundName,
      authorizedUnitIds: template.authorizedUnitIds,
      primaryUnitNumber: template.primaryUnitNumber,
      avatarUrl: template.avatarUrl,
      isActive: template.isActive,
    );
  }

  String _mapAuthError(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'operation-not-allowed':
        return 'Email/Password Sign-In is disabled in Firebase Console. Enable it under Authentication > Sign-in method.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'user-not-found':
        return 'No account found for this email.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'Authentication failed (${e.code}).';
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((fbUser) async {
      if (fbUser == null) return null;
      return _fetchOrCreateUserProfile(fbUser);
    });
  }
}
