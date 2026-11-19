import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/visitor_pass_entity.dart';

Future<void> showVisitorPassQrDialog(
  BuildContext context,
  VisitorPassEntity pass,
) {
  return showDialog(
    context: context,
    builder: (_) => VisitorQrPassDialog(pass: pass),
  );
}

class VisitorQrPassDialog extends StatelessWidget {
  final VisitorPassEntity pass;

  const VisitorQrPassDialog({super.key, required this.pass});

  Color _statusColor(VisitorPassStatus status) {
    switch (status) {
      case VisitorPassStatus.expected:
        return AppColors.statusPending;
      case VisitorPassStatus.checkedIn:
        return AppColors.statusCompleted;
      case VisitorPassStatus.checkedOut:
        return AppColors.statusAssigned;
      case VisitorPassStatus.denied:
      case VisitorPassStatus.expired:
        return AppColors.statusRejected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dateStr =
        '${pass.visitDate.day}/${pass.visitDate.month}/${pass.visitDate.year}';
    final statusCol = _statusColor(pass.status);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.accentGold, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Luxury Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.verified_user_rounded,
                        color: AppColors.accentGold,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.digitalGatePass,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: AppColors.accentGold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.compoundName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Status Badge & Pass Code
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pass.passCode,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusCol.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          pass.status.localizedName(context).toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusCol,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Deterministic QR Code Box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.accentGold.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: CustomPaint(
                      size: const Size(150, 150),
                      painter: _QrMatrixPainter(
                        seedData: '${pass.passCode}-${pass.id}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  Text(
                    pass.visitorName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pass.visitorPhone,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Details Grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoCol(
                        l10n.unitLabel,
                        '${pass.unitNumber} (${pass.residentName})',
                      ),
                      _buildInfoCol(
                        l10n.visitDateLabel,
                        '$dateStr • ${pass.expectedArrivalTime}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Vehicle Plate pill
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.directions_car_rounded,
                          size: 16,
                          color: AppColors.accentTeal,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          (pass.vehiclePlate != null &&
                                  pass.vehiclePlate!.trim().isNotEmpty)
                              ? pass.vehiclePlate!
                              : l10n.walkInPedestrian,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.showQrAtGate,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.close),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCol(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QrMatrixPainter extends CustomPainter {
  final String seedData;

  _QrMatrixPainter({required this.seedData});

  @override
  void paint(Canvas canvas, Size size) {
    const gridSize = 15;
    final cellSize = size.width / gridSize;
    final darkPaint = Paint()
      ..color = AppColors.primaryDark
      ..style = PaintingStyle.fill;

    bool isFinderPattern(int r, int c) {
      final topLeft = r < 4 && c < 4;
      final topRight = r < 4 && c >= gridSize - 4;
      final bottomLeft = r >= gridSize - 4 && c < 4;
      return topLeft || topRight || bottomLeft;
    }

    void drawFinder(int startR, int startC) {
      for (int r = 0; r < 4; r++) {
        for (int c = 0; c < 4; c++) {
          final isBorder = r == 0 || r == 3 || c == 0 || c == 3;
          final isCenter = (r == 1 || r == 2) && (c == 1 || c == 2);
          if (isBorder || isCenter) {
            canvas.drawRect(
              Rect.fromLTWH(
                (startC + c) * cellSize,
                (startR + r) * cellSize,
                cellSize - 0.5,
                cellSize - 0.5,
              ),
              darkPaint,
            );
          }
        }
      }
    }

    drawFinder(0, 0);
    drawFinder(0, gridSize - 4);
    drawFinder(gridSize - 4, 0);

    final codeUnits = seedData.codeUnits;
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (isFinderPattern(r, c)) continue;
        final idx = (r * gridSize + c) % codeUnits.length;
        final hash = (codeUnits[idx] * (r + 3) + c * 17) % 7;
        if (hash < 4) {
          canvas.drawRect(
            Rect.fromLTWH(
              c * cellSize,
              r * cellSize,
              cellSize - 0.5,
              cellSize - 0.5,
            ),
            darkPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QrMatrixPainter oldDelegate) =>
      oldDelegate.seedData != seedData;
}
