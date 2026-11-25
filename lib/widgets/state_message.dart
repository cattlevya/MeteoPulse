import 'package:material_ui/material_ui.dart';
import '../theme/app_theme.dart';
import 'mascot_blob.dart';

/// Tampilan pesan untuk kondisi loading, error, atau data kosong.
class StateMessage extends StatelessWidget {
  final Color mascotColor;
  final String message;
  final String? actionLabel;
  final VoidCallback? onRetry;

  const StateMessage({
    super.key,
    this.mascotColor = AppColors.blushPink,
    required this.message,
    this.actionLabel,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MascotBlob(color: mascotColor, size: 72),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              FilledButton(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.textPrimary,
                  foregroundColor: AppColors.surface,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(actionLabel ?? 'Coba Lagi'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
