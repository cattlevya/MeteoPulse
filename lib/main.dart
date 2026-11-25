import 'package:material_ui/material_ui.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'viewmodels/favorites_viewmodel.dart';
import 'viewmodels/search_viewmodel.dart';
import 'viewmodels/settings_viewmodel.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'views/splash_screen.dart';

/// Entry point aplikasi MeteoPulse.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');

  final settings = SettingsViewModel();
  await settings.load();

  runApp(MeteoPulseApp(settings: settings));
}

/// Root widget dengan MultiProvider untuk seluruh ViewModel.
class MeteoPulseApp extends StatelessWidget {
  final SettingsViewModel settings;

  const MeteoPulseApp({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settings),
        ChangeNotifierProvider(create: (_) => FavoritesViewModel()),
        ChangeNotifierProvider(create: (_) => WeatherViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MeteoPulse',
        theme: buildLightTheme(),
        home: const SplashScreen(),
      ),
    );
  }
}
