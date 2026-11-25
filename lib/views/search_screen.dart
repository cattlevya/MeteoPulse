import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../models/location.dart';
import '../theme/app_theme.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../viewmodels/search_viewmodel.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/city_tile.dart';
import '../widgets/mascot_blob.dart';
import '../widgets/state_message.dart';

/// Layar 2: Pencarian kota dengan daftar favorit dan riwayat.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) context.read<SearchViewModel>().search(value);
    });
  }

  Future<void> _selectCity(Location loc) async {
    final searchVm = context.read<SearchViewModel>();
    final weatherVm = context.read<WeatherViewModel>();
    await searchVm.addToHistory(loc);
    weatherVm.loadWeather(loc);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
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
                  const Text(
                    'Cari Kota',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.borderSubtle),
                  boxShadow: cardShadow(),
                ),
                child: TextField(
                  controller: _controller,
                  onChanged: _onChanged,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (v) => context.read<SearchViewModel>().search(v),
                  decoration: InputDecoration(
                    hintText: 'Cari nama kota...',
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.textPrimary,
                    ),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () {
                              _controller.clear();
                              setState(() {});
                              context.read<SearchViewModel>().clear();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Consumer2<SearchViewModel, FavoritesViewModel>(
                  builder: (context, searchVm, favVm, _) {
                    return _buildContent(searchVm, favVm);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(SearchViewModel searchVm, FavoritesViewModel favVm) {
    final state = searchVm.state;
    if (state == ViewState.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.textPrimary),
      );
    }
    if (state == ViewState.empty) {
      return const StateMessage(
        mascotColor: AppColors.skyBlue,
        message: 'Kota tidak ditemukan.',
      );
    }
    if (state == ViewState.error) {
      return StateMessage(
        message: searchVm.errorMessage,
        onRetry: () => searchVm.search(_controller.text),
      );
    }
    if (state == ViewState.success) {
      return ListView.separated(
        itemCount: searchVm.results.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final loc = searchVm.results[i];
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderSubtle),
              boxShadow: cardShadow(),
            ),
            child: CityTile(
              location: loc,
              isFavorite: favVm.isFavorite(loc),
              onTap: () => _selectCity(loc),
              onFavorite: () => favVm.toggle(loc),
            ),
          );
        },
      );
    }

    const chipColors = [
      AppColors.sunYellow,
      AppColors.blushPink,
      AppColors.mint,
      AppColors.skyBlue,
    ];

    return ListView(
      children: [
        if (favVm.favorites.isNotEmpty) ...[
          const Text(
            'FAVORIT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.borderSubtle),
              boxShadow: cardShadow(),
            ),
            child: Column(
              children: [
                for (var i = 0; i < favVm.favorites.length; i++) ...[
                  if (i > 0)
                    const Divider(height: 1, color: AppColors.borderSubtle),
                  Dismissible(
                    key: ValueKey(favVm.favorites[i]),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: AppColors.error.withValues(alpha: 0.15),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.error,
                      ),
                    ),
                    onDismissed: (_) => favVm.remove(favVm.favorites[i]),
                    child: CityTile(
                      location: favVm.favorites[i],
                      dotColor: chipColors[i % chipColors.length],
                      isFavorite: true,
                      onTap: () => _selectCity(favVm.favorites[i]),
                      onFavorite: () => favVm.toggle(favVm.favorites[i]),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
        if (searchVm.history.isNotEmpty) ...[
          const Text(
            'RIWAYAT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < searchVm.history.length; i++)
                ActionChip(
                  label: Text(
                    searchVm.history[i].name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  backgroundColor: chipColors[i % chipColors.length],
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  onPressed: () => _selectCity(searchVm.history[i]),
                ),
            ],
          ),
          const SizedBox(height: 24),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: Column(
            children: const [
              SearchEmptyChara(size: 72),
              SizedBox(height: 14),
              Text(
                'Ketik minimal 2 karakter untuk mencari\ncuaca kota di seluruh dunia.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
