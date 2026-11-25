import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../utils/day_name.dart';
import '../utils/units.dart';
import '../utils/weather_code.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/daily_tile.dart';
import '../widgets/info_chip.dart';
import '../widgets/mascot_blob.dart';
import '../widgets/weather_icon.dart';

/// Layar 4: Prakiraan cuaca 7 hari ke depan.
class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final weatherVm = context.watch<WeatherViewModel>();
    final unit = context.watch<SettingsViewModel>().tempUnit;
    final w = weatherVm.weather!;
    final loc = weatherVm.location!;
    final day = w.daily[_selected];
    final info = weatherInfo(day.weatherCode, true);
    final heroColor = weatherCardColor(info.visual);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '7 Hari ke Depan',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          loc.name,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 108,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: w.daily.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final item = w.daily[i];
                    final itemInfo = weatherInfo(item.weatherCode, true);
                    final isSelected = i == _selected;
                    return InkWell(
                      onTap: () => setState(() => _selected = i),
                      borderRadius: BorderRadius.circular(34),
                      child: Container(
                        width: 68,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(34),
                          border: isSelected
                              ? null
                              : Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WeatherPuffyIcon(visual: itemInfo.visual, size: 22),
                            Text(
                              '${item.date.day}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? AppColors.background
                                    : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              dayShort(item.date),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.background
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: heroColor,
                  borderRadius: BorderRadius.circular(kCardRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullDayDate(day.date),
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textPrimary.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          info.text,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        MascotBlob(
                          color: AppColors.surface,
                          size: 84,
                          badgeVisual: info.visual,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatTemp(day.maxTemp, unit),
                          style: const TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.w700,
                            height: 1.05,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Min ${formatTemp(day.minTemp, unit)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: InfoChip(
                      iconKind: MetricIconKind.rainOnBlue,
                      backgroundColor: AppColors.skyBlue,
                      value: '${day.rainChance}%',
                      label: 'Hujan',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoChip(
                      iconKind: MetricIconKind.uv,
                      backgroundColor: AppColors.sunYellow,
                      value: day.uvIndex.toStringAsFixed(1),
                      label: 'Indeks UV',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InfoChip(
                      iconKind: MetricIconKind.sunrise,
                      backgroundColor: AppColors.blushPink,
                      value: DateFormat('HH:mm').format(day.sunrise),
                      label: 'Terbit',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoChip(
                      iconKind: MetricIconKind.sunset,
                      backgroundColor: AppColors.mint,
                      value: DateFormat('HH:mm').format(day.sunset),
                      label: 'Terbenam',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(kCardRadius),
                  border: Border.all(color: AppColors.borderSubtle),
                  boxShadow: cardShadow(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SEMUA HARI',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (var i = 0; i < w.daily.length; i++) ...[
                      if (i > 0)
                        const Divider(
                          height: 10,
                          color: AppColors.borderSubtle,
                        ),
                      DailyTile(
                        item: w.daily[i],
                        unit: unit,
                        isToday: i == 0,
                        selected: i == _selected,
                        onTap: () => setState(() => _selected = i),
                      ),
                    ],
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
