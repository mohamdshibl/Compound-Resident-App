import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../l10n/l10n_extension.dart';
import '../l10n/locale_cubit.dart';
import '../theme/app_colors.dart';

class LanguageToggleButton extends StatelessWidget {
  final bool onDark;

  const LanguageToggleButton({
    super.key,
    this.onDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final foreground = onDark ? AppColors.accentGold : AppColors.primaryDark;
    final borderColor = onDark
        ? AppColors.accentGold.withValues(alpha: 0.45)
        : AppColors.accentGold;
    final backgroundColor = onDark
        ? AppColors.accentGold.withValues(alpha: 0.12)
        : AppColors.accentGold.withValues(alpha: 0.14);

    return Tooltip(
      message: l10n.switchLanguage,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: InkWell(
          onTap: () => context.read<LocaleCubit>().toggleLocale(),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.language_rounded, size: 16, color: foreground),
                const SizedBox(width: 5),
                Text(
                  l10n.languageToggleLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: foreground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
