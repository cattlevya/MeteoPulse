import 'package:material_ui/material_ui.dart';
import '../models/location.dart';
import '../models/weather.dart';
import '../theme/app_theme.dart';
import '../utils/day_name.dart';
import '../utils/units.dart';
import '../utils/weather_code.dart';
import 'mascot_blob.dart';

/// Kartu cuaca utama di layar Home bergaya FigCraft.
class WeatherCard extends StatelessWidget {
  final Location location;
  final Weather weather;
  final TempUnit unit;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;

  const WeatherCard({
    super.key,
    required this.location,
    required this.weather,
    required this.unit,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final info = weatherInfo(weather.weatherCode, weather.isDay);
    final bgColor = weatherCardColor(info.visual);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CUACA SAAT INI',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: AppColors.textPrimary.withValues(alpha: 0.65),
                ),
              ),
              InkWell(
                onTap: onToggleFavorite,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isFavorite ? AppColors.blushPink : AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    size: 20,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            location.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            '${location.subtitle} · ${fullDayDate(DateTime.now())}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        formatTemp(weather.temperature, unit),
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w700,
                          height: 1.05,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      info.text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Terasa seperti ${formatTemp(weather.feelsLike, unit)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
              MascotBlob(
                color: AppColors.surface,
                size: 108,
                badgeVisual: info.visual,
              ),
            ],
          ),
          const SizedBox(height: 18),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(28),
            child: Container(
              height: 52,
              padding: const EdgeInsets.only(left: 20, right: 8),
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Lihat Detail',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.surface,
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
