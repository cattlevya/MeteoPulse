import 'package:material_ui/material_ui.dart';
import '../utils/weather_code.dart';

/// Jenis ikon metrik cuaca bergaya Pastel Puffy.
enum MetricIconKind {
  rainOnBlue,
  rainOnWhite,
  wind,
  humidity,
  thermometer,
  pressure,
  visibility,
  sunrise,
  sunset,
  uv,
}

/// Ikon cuaca bergaya Pastel Puffy sesuai desain FigCraft.
class WeatherPuffyIcon extends StatelessWidget {
  final WeatherVisual visual;
  final double size;

  const WeatherPuffyIcon({
    super.key,
    required this.visual,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _WeatherPuffyPainter(visual)),
    );
  }
}

/// Ikon metrik cuaca bergaya Pastel Puffy.
class MetricPuffyIcon extends StatelessWidget {
  final MetricIconKind kind;
  final double size;

  const MetricPuffyIcon({
    super.key,
    required this.kind,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _MetricPuffyPainter(kind)),
    );
  }
}

class _WeatherPuffyPainter extends CustomPainter {
  final WeatherVisual visual;

  _WeatherPuffyPainter(this.visual);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24.0;
    canvas.scale(s, s);

    switch (visual) {
      case WeatherVisual.clear:
        _drawSun(canvas);
        break;
      case WeatherVisual.partlyCloudy:
        _drawSun(canvas, offset: const Offset(4.5, -3.5), scale: 0.52);
        _drawCloud(canvas, const Color(0xFF7BB8FF), dy: 2.0);
        break;
      case WeatherVisual.cloudy:
        _drawCloud(canvas, const Color(0xFF7BB8FF), dy: 1.5);
        break;
      case WeatherVisual.rain:
        _drawCloud(canvas, const Color(0xFF7BB8FF), dy: -0.5);
        _drawRainDrops(canvas, const Color(0xFF2563EB));
        break;
      case WeatherVisual.storm:
        _drawCloud(canvas, const Color(0xFFB7E1D1), dy: -0.5);
        _drawBolt(canvas);
        break;
      case WeatherVisual.snow:
        _drawCloud(canvas, const Color(0xFFA9D3FF), dy: -0.5);
        _drawSnowDots(canvas);
        break;
      case WeatherVisual.night:
        _drawMoon(canvas);
        break;
    }
  }

  void _drawSun(
    Canvas canvas, {
    Offset offset = Offset.zero,
    double scale = 1.0,
  }) {
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.scale(scale, scale);
    canvas.drawCircle(
      const Offset(12, 12),
      9.5,
      Paint()..color = const Color(0x8CFFDE7D),
    );
    canvas.drawCircle(
      const Offset(12, 12),
      6.5,
      Paint()..color = const Color(0xFFFFB800),
    );
    canvas.drawOval(
      const Rect.fromLTWH(8.5, 8.2, 4.2, 2.8),
      Paint()..color = const Color(0xFFFFF7D6),
    );
    canvas.restore();
  }

  void _drawMoon(Canvas canvas) {
    final moonPaint = Paint()..color = const Color(0xFFFFB800);
    canvas.drawCircle(const Offset(11.5, 12.5), 7, moonPaint);
    canvas.drawCircle(
      const Offset(14.5, 9.8),
      5.5,
      Paint()..color = const Color(0xFFE5E2DC),
    );
    canvas.drawCircle(
      const Offset(18.5, 6.5),
      1.6,
      Paint()..color = const Color(0xFF7BB8FF),
    );
  }

  void _drawCloud(Canvas canvas, Color color, {double dy = 0}) {
    final p = Paint()..color = color;
    canvas.drawCircle(Offset(11, 8.5 + dy), 5.2, p);
    canvas.drawCircle(Offset(7.5, 10.5 + dy), 4.2, p);
    canvas.drawCircle(Offset(16.2, 10.8 + dy), 4.0, p);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(4.5, 8.2 + dy, 15, 6.8),
        const Radius.circular(3.4),
      ),
      p,
    );
  }

  void _drawRainDrops(Canvas canvas, Color color) {
    final p = Paint()..color = color;
    for (final rect in const [
      Rect.fromLTWH(6.5, 16.5, 2.6, 4.2),
      Rect.fromLTWH(10.8, 18.0, 2.6, 4.2),
      Rect.fromLTWH(15.0, 16.5, 2.6, 4.2),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(1.3)),
        p,
      );
    }
  }

  void _drawSnowDots(Canvas canvas) {
    final p = Paint()..color = const Color(0xFF2563EB);
    canvas.drawCircle(const Offset(8, 18.5), 1.5, p);
    canvas.drawCircle(const Offset(12, 20), 1.5, p);
    canvas.drawCircle(const Offset(16, 18.5), 1.5, p);
  }

  void _drawBolt(Canvas canvas) {
    final path = Path()
      ..moveTo(13, 12.5)
      ..lineTo(9.8, 17)
      ..lineTo(12.6, 17)
      ..lineTo(11.8, 21)
      ..lineTo(15.8, 16)
      ..lineTo(13, 16)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFF5B82E));
  }

  @override
  bool shouldRepaint(covariant _WeatherPuffyPainter oldDelegate) =>
      oldDelegate.visual != visual;
}

class _MetricPuffyPainter extends CustomPainter {
  final MetricIconKind kind;

  _MetricPuffyPainter(this.kind);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24.0;
    canvas.scale(s, s);

    switch (kind) {
      case MetricIconKind.rainOnBlue:
        _drawCloud(canvas, const Color(0xFFFCFAF7));
        _drawRainDrops(canvas, const Color(0xFF2563EB));
        break;
      case MetricIconKind.rainOnWhite:
        _drawCloud(canvas, const Color(0xFF7BB8FF));
        _drawRainDrops(canvas, const Color(0xFF2563EB));
        break;
      case MetricIconKind.wind:
        _drawWind(canvas);
        break;
      case MetricIconKind.humidity:
        _drawHumidity(canvas);
        break;
      case MetricIconKind.thermometer:
        _drawThermometer(canvas);
        break;
      case MetricIconKind.pressure:
        _drawPressure(canvas);
        break;
      case MetricIconKind.visibility:
        _drawVisibility(canvas);
        break;
      case MetricIconKind.sunrise:
        _drawSunrise(canvas);
        break;
      case MetricIconKind.sunset:
        _drawSunset(canvas);
        break;
      case MetricIconKind.uv:
        _drawUvSun(canvas);
        break;
    }
  }

  void _drawCloud(Canvas canvas, Color color) {
    final p = Paint()..color = color;
    canvas.drawCircle(const Offset(11, 8.2), 5.2, p);
    canvas.drawCircle(const Offset(7.5, 10.2), 4.2, p);
    canvas.drawCircle(const Offset(16.2, 10.5), 4.0, p);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(4.5, 8.0, 15, 6.8),
        const Radius.circular(3.4),
      ),
      p,
    );
  }

  void _drawRainDrops(Canvas canvas, Color color) {
    final p = Paint()..color = color;
    for (final rect in const [
      Rect.fromLTWH(6.5, 16.5, 2.6, 4.2),
      Rect.fromLTWH(10.8, 18.0, 2.6, 4.2),
      Rect.fromLTWH(15.0, 16.5, 2.6, 4.2),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(1.3)),
        p,
      );
    }
  }

  void _drawWind(Canvas canvas) {
    final p = Paint()
      ..color = const Color(0xFF0F766E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final path1 = Path()
      ..moveTo(2, 12)
      ..lineTo(18.5, 12)
      ..arcToPoint(
        const Offset(16.8, 8.2),
        radius: const Radius.circular(2.2),
        clockwise: false,
      );
    final path2 = Path()
      ..moveTo(2, 8)
      ..lineTo(10.8, 8)
      ..arcToPoint(
        const Offset(9.4, 4.8),
        radius: const Radius.circular(1.8),
        clockwise: false,
      );
    final path3 = Path()
      ..moveTo(2, 16)
      ..lineTo(13.8, 16)
      ..arcToPoint(
        const Offset(12.4, 19.2),
        radius: const Radius.circular(1.8),
      );
    canvas.drawPath(path1, p);
    canvas.drawPath(path2, p);
    canvas.drawPath(path3, p);
  }

  void _drawHumidity(Canvas canvas) {
    final big = Path()
      ..moveTo(10, 3.5)
      ..lineTo(14.8, 8.5)
      ..arcToPoint(
        const Offset(5.2, 8.5),
        radius: const Radius.circular(6.8),
      )
      ..close();
    canvas.drawPath(big, Paint()..color = const Color(0xFFE11D48));

    final small = Path()
      ..moveTo(18.2, 11.5)
      ..lineTo(20.4, 13.8)
      ..arcToPoint(
        const Offset(16.0, 13.8),
        radius: const Radius.circular(3.1),
      )
      ..close();
    canvas.drawPath(small, Paint()..color = const Color(0xFFFFB5C1));
  }

  void _drawThermometer(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(9, 2, 6, 14),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFFFE4E6),
    );
    canvas.drawCircle(
      const Offset(12, 17.5),
      4.5,
      Paint()..color = const Color(0xFFFB7185),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(10.5, 6, 3, 9),
        const Radius.circular(1.5),
      ),
      Paint()..color = const Color(0xFFFB7185),
    );
  }

  void _drawPressure(Canvas canvas) {
    final arcPaint = Paint()
      ..color = const Color(0xFFFCFAF7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      const Rect.fromLTWH(4, 7, 16, 16),
      3.14159,
      3.14159,
      false,
      arcPaint,
    );
    final needlePaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(12, 15), const Offset(16, 10), needlePaint);
    canvas.drawCircle(
      const Offset(12, 15),
      2.5,
      Paint()..color = const Color(0xFF2563EB),
    );
  }

  void _drawVisibility(Canvas canvas) {
    final eye = Path()
      ..moveTo(2, 12)
      ..quadraticBezierTo(12, 4, 22, 12)
      ..quadraticBezierTo(12, 20, 2, 12)
      ..close();
    canvas.drawPath(eye, Paint()..color = const Color(0xFFFCFAF7));
    canvas.drawCircle(
      const Offset(12, 12),
      3.5,
      Paint()..color = const Color(0xFF0F766E),
    );
  }

  void _drawSunrise(Canvas canvas) {
    final rayPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(12, 2.2), const Offset(12, 4.6), rayPaint);
    canvas.drawLine(const Offset(5.6, 5), const Offset(7.2, 6.6), rayPaint);
    canvas.drawLine(const Offset(18.4, 5), const Offset(16.8, 6.6), rayPaint);
    canvas.drawCircle(
      const Offset(12, 12.5),
      6.8,
      Paint()..color = const Color(0xFFFFE59A),
    );
    canvas.drawCircle(
      const Offset(12, 12.5),
      4.5,
      Paint()..color = const Color(0xFFFFB800),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(2, 14.5, 20, 5.5),
        const Radius.circular(2.75),
      ),
      Paint()..color = const Color(0xFFFFB5C1),
    );
  }

  void _drawSunset(Canvas canvas) {
    canvas.drawCircle(
      const Offset(12, 13),
      6.8,
      Paint()..color = const Color(0xFFFFE59A),
    );
    canvas.drawCircle(
      const Offset(12, 13),
      4.5,
      Paint()..color = const Color(0xFFFF7849),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(2, 14.5, 20, 5.5),
        const Radius.circular(2.75),
      ),
      Paint()..color = const Color(0xFFB7E1D1),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(6.5, 21.2, 11, 2),
        const Radius.circular(1),
      ),
      Paint()..color = const Color(0xFF7BB8FF),
    );
  }

  void _drawUvSun(Canvas canvas) {
    final rayPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(12, 2), const Offset(12, 4), rayPaint);
    canvas.drawLine(const Offset(12, 20), const Offset(12, 22), rayPaint);
    canvas.drawLine(const Offset(2, 12), const Offset(4, 12), rayPaint);
    canvas.drawLine(const Offset(20, 12), const Offset(22, 12), rayPaint);
    canvas.drawLine(const Offset(4.9, 4.9), const Offset(6.3, 6.3), rayPaint);
    canvas.drawLine(const Offset(17.7, 17.7), const Offset(19.1, 19.1), rayPaint);
    canvas.drawLine(const Offset(4.9, 19.1), const Offset(6.3, 17.7), rayPaint);
    canvas.drawLine(const Offset(17.7, 6.3), const Offset(19.1, 4.9), rayPaint);
    canvas.drawCircle(
      const Offset(12, 12),
      6.2,
      Paint()..color = const Color(0xFFFFE59A),
    );
    canvas.drawCircle(
      const Offset(12, 12),
      4.2,
      Paint()..color = const Color(0xFFFFB800),
    );
  }

  @override
  bool shouldRepaint(covariant _MetricPuffyPainter oldDelegate) =>
      oldDelegate.kind != kind;
}
