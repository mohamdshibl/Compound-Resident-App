import 'package:flutter/widgets.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/requests/domain/entities/request_enums.dart';
import '../../l10n/generated/app_localizations.dart';

extension BuildContextL10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';
}

extension UserEntityL10nX on UserEntity {
  String localizedName(BuildContext context) {
    if (context.isArabic && fullNameAr.trim().isNotEmpty) {
      return fullNameAr;
    }
    return fullName;
  }

  String localizedCompoundName(BuildContext context) {
    return context.l10n.compoundName;
  }
}

extension UserRoleL10nX on UserRole {
  String localizedName(BuildContext context) =>
      context.isArabic ? displayNameAr : displayNameEn;
}

extension RequestCategoryL10nX on RequestCategory {
  String localizedName(BuildContext context) =>
      context.isArabic ? displayNameAr : displayNameEn;
}

extension RequestPriorityL10nX on RequestPriority {
  String localizedName(BuildContext context) =>
      context.isArabic ? displayNameAr : displayNameEn;
}

extension RequestStatusL10nX on RequestStatus {
  String localizedName(BuildContext context) =>
      context.isArabic ? displayNameAr : displayNameEn;
}
