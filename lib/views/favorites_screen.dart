import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../models/location.dart';
import '../theme/app_theme.dart';
import '../utils/units.dart';
import '../utils/weather_code.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/mascot_blob.dart';
import '../widgets/state_message.dart';
import 'search_screen.dart';

/// Layar 3: Daftar kota favorit beserta suhu terkini.
class FavoritesScreen extends StatelessWidget {
  final VoidCallback onCitySelected;

  const FavoritesScreen({super.key, required this.onCitySelected});

  Future<void> _openSearch(BuildContext context) async {
    final picked = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
    if (picked == true) onCitySelected();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Favorit',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                InkWell(
                  onTap: () => _openSearch(context),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 48,
                    height: 48,
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
            const SizedBox(height: 16),
            Expanded(
              child: Consumer2<FavoritesViewModel, SettingsViewModel>(
                builder: (context, favVm, settingsVm, _) {
                  if (favVm.favorites.isEmpty) {
                    return StateMessage(
                      mascotColor: AppColors.sunYellow,
                      message:
                          'Belum ada favorit. Cari kota lalu ketuk hati untuk menyimpan.',
                      actionLabel: 'Cari Kota',
                      onRetry: () => _openSearch(context),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: favVm.loadAllWeather,
                    color: AppColors.textPrimary,
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 112),
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.80,
                      ),
                      itemCount: favVm.favorites.length + 1,
                      itemBuilder: (context, index) {
                        if (index == favVm.favorites.length) {
                          return _AddCityCard(
                            onTap: () => _openSearch(context),
                          );
                        }
                        final loc = favVm.favorites[index];
                        return _FavoriteCityCard(
                          location: loc,
                          favVm: favVm,
                          unit: settingsVm.tempUnit,
                          onTap: () {
                            context.read<WeatherViewModel>().loadWeather(loc);
                            onCitySelected();
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteCityCard extends StatelessWidget {
  final Location location;
  final FavoritesViewModel favVm;
  final TempUnit unit;
  final VoidCallback onTap;

  const _FavoriteCityCard({
    required this.location,
    required this.favVm,
    required this.unit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = favVm.weathers[location];
    final isFailed = favVm.failed.contains(location);
    final info =
        w != null ? weatherInfo(w.weatherCode, w.isDay) : null;
    final mascotColor =
        info != null ? mascotWeatherColor(info.visual) : AppColors.cloudGrey;
    final tempText = w != null ? formatTemp(w.temperature, unit) : '--°';
    final condText =
        info?.text ?? (isFailed ? 'Gagal memuat' : 'Memuat...');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(kTileRadius),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(kTileRadius),
          border: Border.all(color: AppColors.borderSubtle),
          boxShadow: cardShadow(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MascotBlob(
                  color: mascotColor,
                  size: 56,
                  badgeVisual: info?.visual,
                ),
                InkWell(
                  onTap: () => favVm.toggle(location),
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.blushPink,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      size: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  tempText,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: mascotColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    condText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddCityCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddCityCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(kTileRadius),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(kTileRadius),
          border: Border.all(color: AppColors.borderSubtle, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: const Icon(Icons.add_rounded, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tambah Kota',
              style: TextStyle(
                fontSize: 14,
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
