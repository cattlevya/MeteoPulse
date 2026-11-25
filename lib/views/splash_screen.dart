import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../utils/weather_code.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../viewmodels/search_viewmodel.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/mascot_blob.dart';
import 'main_shell.dart';

/// Layar 0: Splash screen MeteoPulse.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final weatherVm = context.read<WeatherViewModel>();
    final favoritesVm = context.read<FavoritesViewModel>();
    final searchVm = context.read<SearchViewModel>();

    await Future.wait([
      weatherVm.init(),
      favoritesVm.load(),
      searchVm.loadHistory(),
      Future.delayed(const Duration(milliseconds: 1500)),
    ]);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MascotBlob(
              color: AppColors.sunYellow,
              size: 112,
              badgeVisual: WeatherVisual.partlyCloudy,
            ),
            const SizedBox(height: 20),
            const Text(
              'MeteoPulse',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Cek cuaca kotamu dengan cepat',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                _Dot(AppColors.sunYellow),
                SizedBox(width: 8),
                _Dot(AppColors.blushPink),
                SizedBox(width: 8),
                _Dot(AppColors.mint),
                SizedBox(width: 8),
                _Dot(AppColors.skyBlue),
              ],
            ),
            const SizedBox(height: 24),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;

  const _Dot(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
