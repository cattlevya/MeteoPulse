import 'package:material_ui/material_ui.dart';
import '../models/location.dart';
import '../theme/app_theme.dart';

/// Baris kota untuk hasil pencarian, daftar favorit, atau riwayat di Cari Kota.
class CityTile extends StatelessWidget {
  final Location location;
  final Color dotColor;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const CityTile({
    super.key,
    required this.location,
    this.dotColor = AppColors.sunYellow,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            const SizedBox(width: 14),
            Expanded(
              child: Column(
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
                  if (location.subtitle.isNotEmpty)
                    Text(
                      location.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            InkWell(
              onTap: onFavorite,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isFavorite ? AppColors.blushPink : AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 18,
                  color: isFavorite
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
