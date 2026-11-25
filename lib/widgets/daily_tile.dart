import 'package:material_ui/material_ui.dart';
import '../models/weather.dart';
import '../theme/app_theme.dart';
import '../utils/day_name.dart';
import '../utils/units.dart';
import '../utils/weather_code.dart';
import 'weather_icon.dart';

/// Baris prakiraan harian untuk daftar di Home dan Forecast 7 Hari.
class DailyTile extends StatelessWidget {
  final DailyForecast item;
  final TempUnit unit;
  final bool isToday;
  final bool selected;
  final VoidCallback? onTap;

  const DailyTile({
    super.key,
    required this.item,
    required this.unit,
    required this.isToday,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final info = weatherInfo(item.weatherCode, true);
    final dotColor = mascotWeatherColor(info.visual);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.sunYellow.withValues(alpha: 0.35)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayName(item.date, isToday: isToday),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    shortDate(item.date),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            WeatherPuffyIcon(visual: info.visual, size: 24),
            const SizedBox(width: 12),
            Text(
              '${formatTemp(item.maxTemp, unit)} / ${formatTemp(item.minTemp, unit)}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
