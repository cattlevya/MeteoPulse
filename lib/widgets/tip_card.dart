import 'package:material_ui/material_ui.dart';
import '../theme/app_theme.dart';
import '../utils/weather_tips.dart';
import 'mascot_blob.dart';

/// Kartu saran aktivitas harian dengan maskot mengintip di pojok kanan atas.
class TipCard extends StatelessWidget {
  final WeatherTip tip;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const TipCard({
    super.key,
    required this.tip,
    this.backgroundColor = AppColors.mint,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(kTileRadius),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kTileRadius),
        child: Container(
          width: double.infinity,
          color: backgroundColor,
          child: Stack(
            children: [
              const Positioned(
                right: 12,
                top: -16,
                child: MascotBlob(color: AppColors.surface, size: 64),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 86, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SARAN HARI INI',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: AppColors.textPrimary.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      tip.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
