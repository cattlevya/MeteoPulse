import 'package:material_ui/material_ui.dart';
import '../theme/app_theme.dart';
import '../utils/weather_code.dart';
import 'weather_icon.dart';

/// Maskot karakter lembut MeteoPulse dengan lencana ikon cuaca opsional.
class MascotBlob extends StatelessWidget {
  final Color color;
  final double size;
  final WeatherVisual? badgeVisual;

  const MascotBlob({
    super.key,
    required this.color,
    this.size = 96,
    this.badgeVisual,
  });

  @override
  Widget build(BuildContext context) {
    final badgeSize = size * 0.42;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _BlobPainter(color),
          ),
          if (badgeVisual != null)
            Positioned(
              right: -size * 0.04,
              bottom: -size * 0.04,
              child: Container(
                width: badgeSize,
                height: badgeSize,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: cardShadow(),
                ),
                alignment: Alignment.center,
                child: WeatherPuffyIcon(
                  visual: badgeVisual!,
                  size: badgeSize * 0.56,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Karakter pink menggemaskan untuk tampilan kosong layar Cari Kota.
class SearchEmptyChara extends StatelessWidget {
  final double size;

  const SearchEmptyChara({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _SearchCharaPainter()),
    );
  }
}

class _BlobPainter extends CustomPainter {
  final Color color;

  _BlobPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final bodyRect = Rect.fromLTWH(w * 0.04, h * 0.06, w * 0.92, h * 0.86);
    final rrect = RRect.fromRectAndRadius(bodyRect, Radius.circular(w * 0.46));
    canvas.drawRRect(rrect, Paint()..color = color);

    final eyePaint = Paint()..color = AppColors.textPrimary;
    final eyeW = w * 0.075;
    final eyeH = h * 0.12;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.37, h * 0.40, eyeW, eyeH),
        Radius.circular(eyeW / 2),
      ),
      eyePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.54, h * 0.40, eyeW, eyeH),
        Radius.circular(eyeW / 2),
      ),
      eyePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _BlobPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _SearchCharaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.drawOval(
      Rect.fromLTWH(w * 0.03, h * 0.02, w * 0.94, h * 0.96),
      Paint()..color = AppColors.blushPink,
    );

    final ink = Paint()..color = const Color(0xFF1A1A1A);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.31, h * 0.37, w * 0.10, h * 0.15),
        Radius.circular(w * 0.05),
      ),
      ink,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.59, h * 0.37, w * 0.10, h * 0.15),
        Radius.circular(w * 0.05),
      ),
      ink,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.40, h * 0.65, w * 0.20, h * 0.07),
        Radius.circular(w * 0.035),
      ),
      ink,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
