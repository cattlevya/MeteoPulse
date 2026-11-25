import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../utils/units.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../viewmodels/search_viewmodel.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../widgets/mascot_blob.dart';

/// Layar 6: Pengaturan satuan suhu, satuan angin, dan manajemen data lokal.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmClear(
    BuildContext context, {
    required String title,
    required String content,
    required Future<void> Function() onConfirm,
    required String doneMessage,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.textPrimary,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await onConfirm();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(doneMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 112),
        child: Consumer<SettingsViewModel>(
          builder: (context, settings, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Pengaturan',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    MascotBlob(color: AppColors.sunYellow, size: 42),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'PREFERENSI',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(kTileRadius),
                    border: Border.all(color: AppColors.borderSubtle),
                    boxShadow: cardShadow(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Satuan Suhu',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _PillSegmented<TempUnit>(
                        items: const [
                          MapEntry(TempUnit.celsius, '°C'),
                          MapEntry(TempUnit.fahrenheit, '°F'),
                        ],
                        selected: settings.tempUnit,
                        onSelect: settings.setTempUnit,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Satuan Angin',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _PillSegmented<WindUnit>(
                        items: const [
                          MapEntry(WindUnit.kmh, 'km/h'),
                          MapEntry(WindUnit.ms, 'm/s'),
                        ],
                        selected: settings.windUnit,
                        onSelect: settings.setWindUnit,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'DATA',
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
                    borderRadius: BorderRadius.circular(kTileRadius),
                    border: Border.all(color: AppColors.borderSubtle),
                    boxShadow: cardShadow(),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: AppColors.skyBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.history_rounded,
                            size: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        title: const Text(
                          'Hapus Riwayat Pencarian',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        onTap: () => _confirmClear(
                          context,
                          title: 'Hapus Riwayat?',
                          content: 'Semua riwayat pencarian kota akan dihapus.',
                          onConfirm: () =>
                              context.read<SearchViewModel>().clearHistory(),
                          doneMessage: 'Riwayat dihapus',
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.borderSubtle),
                      ListTile(
                        leading: Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: AppColors.blushPink,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            size: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        title: const Text(
                          'Hapus Semua Favorit',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        onTap: () => _confirmClear(
                          context,
                          title: 'Hapus Favorit?',
                          content: 'Semua kota favorit akan dihapus.',
                          onConfirm: () =>
                              context.read<FavoritesViewModel>().clearAll(),
                          doneMessage: 'Favorit dihapus',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.sunYellow,
                    borderRadius: BorderRadius.circular(kTileRadius),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const MascotBlob(
                          color: AppColors.surface,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'MeteoPulse v1.0.0',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Data cuaca oleh Open-Meteo.com',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PillSegmented<T> extends StatelessWidget {
  final List<MapEntry<T, String>> items;
  final T selected;
  final ValueChanged<T> onSelect;

  const _PillSegmented({
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(21),
      ),
      child: Row(
        children: [
          for (final entry in items)
            Expanded(
              child: InkWell(
                onTap: () => onSelect(entry.key),
                borderRadius: BorderRadius.circular(17),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: entry.key == selected
                        ? AppColors.textPrimary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: entry.key == selected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: entry.key == selected
                          ? AppColors.background
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
