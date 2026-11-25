import 'package:material_ui/material_ui.dart';
import '../theme/app_theme.dart';
import 'weather_icon.dart';

/// Chip info ringkas (Hujan, Angin, Lembap) di layar Home.
class InfoChip extends StatelessWidget {
  final MetricIconKind iconKind;
  final Color backgroundColor;
  final String value;
  final String label;

  const InfoChip({
    super.key,
    required this.iconKind,
    required this.backgroundColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MetricPuffyIcon(kind: iconKind, size: 24),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
