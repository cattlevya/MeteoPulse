import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../utils/units.dart';
import '../utils/weather_tips.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/daily_tile.dart';
import '../widgets/hourly_item.dart';
import '../widgets/info_chip.dart';
import '../widgets/mascot_blob.dart';
import '../widgets/state_message.dart';
import '../widgets/tip_card.dart';
import '../widgets/weather_card.dart';
import '../widgets/weather_icon.dart';
import 'detail_screen.dart';
import 'forecast_screen.dart';
import 'search_screen.dart';

/// Layar 1: Halaman utama cuaca kota aktif.
class HomeScreen extends StatelessWidget {
  final VoidCallback onCityPicked;

  const HomeScreen({super.key, required this.onCityPicked});

  Future<void> _openSearch(BuildContext context) async {
    final picked = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
    if (picked == true) onCityPicked();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<WeatherViewModel, SettingsViewModel, FavoritesViewModel>(
      builder: (context, weatherVm, settingsVm, favVm, _) {
        return SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: _HomeTopBar(onSearchTap: () => _openSearch(context)),
              ),
              Expanded(
                child: _buildBody(context, weatherVm, settingsVm, favVm),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    WeatherViewModel weatherVm,
    SettingsViewModel settingsVm,
    FavoritesViewModel favVm,
  ) {
    switch (weatherVm.state) {
      case ViewState.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.textPrimary),
        );
      case ViewState.error:
      case ViewState.empty:
        return StateMessage(
          message: weatherVm.errorMessage,
          onRetry: weatherVm.refresh,
        );
      case ViewState.success:
        final w = weatherVm.weather!;
        final loc = weatherVm.location!;
        final tips = getTips(w);

        return RefreshIndicator(
          onRefresh: weatherVm.refresh,
          color: AppColors.textPrimary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 112),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WeatherCard(
                  location: loc,
                  weather: w,
                  unit: settingsVm.tempUnit,
                  isFavorite: favVm.isFavorite(loc),
                  onToggleFavorite: () => favVm.toggle(loc),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const DetailScreen()),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InfoChip(
                        iconKind: MetricIconKind.rainOnBlue,
                        backgroundColor: AppColors.skyBlue,
                        value: '${w.rainChance}%',
                        label: 'Hujan',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InfoChip(
                        iconKind: MetricIconKind.wind,
                        backgroundColor: AppColors.mint,
                        value: formatWind(w.windSpeed, settingsVm.windUnit),
                        label: 'Angin',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InfoChip(
                        iconKind: MetricIconKind.humidity,
                        backgroundColor: AppColors.blushPink,
                        value: '${w.humidity}%',
                        label: 'Lembap',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TipCard(
                  tip: tips.first,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const DetailScreen()),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'HARI INI',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 116,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: w.hourly.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (_, i) => HourlyItem(
                      item: w.hourly[i],
                      unit: settingsVm.tempUnit,
                      isNow: i == 0,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(kCardRadius),
                    border: Border.all(color: AppColors.borderSubtle),
                    boxShadow: cardShadow(),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '3 HARI KE DEPAN',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ForecastScreen(),
                              ),
                            ),
                            borderRadius: BorderRadius.circular(16),
                            child: Row(
                              children: [
                                const Text(
                                  'Lihat 7 Hari',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: AppColors.sunYellow,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      for (var i = 0; i < w.daily.take(3).length; i++) ...[
                        if (i > 0)
                          const Divider(
                            height: 12,
                            color: AppColors.borderSubtle,
                          ),
                        DailyTile(
                          item: w.daily[i],
                          unit: settingsVm.tempUnit,
                          isToday: i == 0,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}

class _HomeTopBar extends StatelessWidget {
  final VoidCallback onSearchTap;

  const _HomeTopBar({required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.only(left: 14, right: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: cardShadow(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              MascotBlob(color: AppColors.sunYellow, size: 32),
              SizedBox(width: 10),
              Text(
                'MeteoPulse',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: onSearchTap,
            borderRadius: BorderRadius.circular(22),
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.textPrimary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_rounded,
                size: 20,
                color: AppColors.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
