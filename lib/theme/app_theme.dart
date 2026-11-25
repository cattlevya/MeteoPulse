import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palet warna resmi MeteoPulse sesuai desain FigCraft.
class AppColors {
  static const Color background = Color(0xFFF7F3EF);
  static const Color surface = Color(0xFFFCFAF7);
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF6B665F);
  static const Color borderSubtle = Color(0x1A111111);

  static const Color sunYellow = Color(0xFFFFE59A);
  static const Color skyBlue = Color(0xFFA9D3FF);
  static const Color mint = Color(0xFFB7E1D1);
  static const Color blushPink = Color(0xFFFFB5C1);
  static const Color cloudGrey = Color(0xFFE5E2DC);
  static const Color error = Color(0xFFE5566D);
}

const double kCardRadius = 28.0;
const double kTileRadius = 24.0;

/// Bayangan lembut untuk kartu mengambang.
List<BoxShadow> cardShadow() {
  return const [
    BoxShadow(
      color: Color(0x0A111111),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
}

/// Tema utama aplikasi MeteoPulse.
ThemeData buildLightTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.skyBlue,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.textPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );

  return base.copyWith(
    textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
  );
}
