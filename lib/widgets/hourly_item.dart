import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import '../models/weather.dart';
import '../theme/app_theme.dart';
import '../utils/units.dart';
import '../utils/weather_code.dart';
import 'weather_icon.dart';

/// Item kapsul prakiraan per jam di layar Home.
class HourlyItem extends StatelessWidget {
  final HourlyForecast item;
  final TempUnit unit;
  final bool isNow;

  const HourlyItem({
    super.key,
    required this.item,
    required this.unit,
    required this.isNow,
  });

  @override
  Widget build(BuildContext context) {
    final info = weatherInfo(item.weatherCode, true);
    final bg = isNow ? AppColors.textPrimary : AppColors.surface;
    final fg = isNow ? AppColors.background : AppColors.textPrimary;
    final sub = isNow
        ? AppColors.background.withValues(alpha: 0.75)
        : AppColors.textSecondary;

    return Container(
      width: 68,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(34),
        border: isNow ? null : Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('HH:mm').format(item.time),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: sub,
            ),
          ),
          WeatherPuffyIcon(visual: info.visual, size: 24),
          Text(
            formatTemp(item.temperature, unit),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
