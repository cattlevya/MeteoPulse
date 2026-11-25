import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../utils/day_name.dart';
import '../utils/units.dart';
import '../utils/weather_code.dart';
import '../utils/weather_tips.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/detail_tile.dart';
import '../widgets/mascot_blob.dart';
import '../widgets/tip_card.dart';
import '../widgets/weather_icon.dart';

/// Layar 5: Detail cuaca lengkap, matahari, dan saran aktivitas.
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherVm = context.watch<WeatherViewModel>();
    final settingsVm = context.watch<SettingsViewModel>();
    final w = weatherVm.weather!;
    final loc = weatherVm.location!;
    final info = weatherInfo(w.weatherCode, w.isDay);
    final summaryBg = detailSummaryCardColor(info.visual);
    final mascotBg = mascotWeatherColor(info.visual);
    final tips = getTips(w);

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
                          'Detail Cuaca',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${loc.name}, ${loc.subtitle} · ${fullDayDate(DateTime.now())}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: summaryBg,
                  borderRadius: BorderRadius.circular(kCardRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MascotBlob(
                      color: mascotBg,
                      size: 92,
                      badgeVisual: info.visual,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatTemp(w.temperature, settingsVm.tempUnit),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            height: 1.05,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            info.text,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Terasa ${formatTemp(w.feelsLike, settingsVm.tempUnit)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textPrimary.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.48,
                children: [
                  DetailTile(
                    iconKind: MetricIconKind.thermometer,
                    label: 'Terasa Seperti',
                    value: formatTemp(w.feelsLike, settingsVm.tempUnit),
                    backgroundColor: AppColors.sunYellow,
                  ),
                  DetailTile(
                    iconKind: MetricIconKind.humidity,
                    label: 'Kelembapan',
                    value: '${w.humidity}%',
                  ),
                  DetailTile(
                    iconKind: MetricIconKind.wind,
                    label: 'Angin',
                    value: formatWind(w.windSpeed, settingsVm.windUnit),
                  ),
                  DetailTile(
                    iconKind: MetricIconKind.pressure,
                    label: 'Tekanan',
                    value: '${w.pressure.round()} hPa',
                    backgroundColor: AppColors.skyBlue,
                  ),
                  DetailTile(
                    iconKind: MetricIconKind.visibility,
                    label: 'Pandang',
                    value: '${(w.visibility / 1000).toStringAsFixed(1)} km',
                    backgroundColor: AppColors.mint,
                  ),
                  DetailTile(
                    iconKind: MetricIconKind.rainOnWhite,
                    label: 'Curah Hujan',
                    value: '${w.precipitation.toStringAsFixed(1)} mm',
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(kTileRadius),
                  border: Border.all(color: AppColors.borderSubtle),
                  boxShadow: cardShadow(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SunColumn(
                      kind: MetricIconKind.sunrise,
                      value: DateFormat('HH:mm').format(w.sunrise),
                      label: 'Terbit',
                    ),
                    _SunColumn(
                      kind: MetricIconKind.sunset,
                      value: DateFormat('HH:mm').format(w.sunset),
                      label: 'Terbenam',
                    ),
                    _SunColumn(
                      kind: MetricIconKind.uv,
                      value: 'UV ${w.uvIndex.toStringAsFixed(1)}',
                      label: 'Indeks UV',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              for (var i = 0; i < tips.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                TipCard(tip: tips[i]),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SunColumn extends StatelessWidget {
  final MetricIconKind kind;
  final String value;
  final String label;

  const _SunColumn({
    required this.kind,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MetricPuffyIcon(kind: kind, size: 26),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
