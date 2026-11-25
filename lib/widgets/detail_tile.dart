import 'package:material_ui/material_ui.dart';
import '../theme/app_theme.dart';
import 'weather_icon.dart';

/// Kartu metrik detail cuaca (2x3 grid di DetailScreen).
class DetailTile extends StatelessWidget {
  final MetricIconKind iconKind;
  final String label;
  final String value;
  final Color? backgroundColor;

  const DetailTile({
    super.key,
    required this.iconKind,
    required this.label,
    required this.value,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.surface;
    final hasPastelBg = backgroundColor != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(kTileRadius),
        border: hasPastelBg ? null : Border.all(color: AppColors.borderSubtle),
        boxShadow: cardShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              MetricPuffyIcon(kind: iconKind, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: hasPastelBg
                        ? AppColors.textPrimary.withValues(alpha: 0.7)
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
