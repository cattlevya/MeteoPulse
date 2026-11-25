import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../widgets/floating_nav_bar.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

/// Wadah navigasi utama 3 tab (Beranda, Favorit, Pengaturan).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _selectTab(int index) {
    setState(() => _index = index);
    if (index == 1) {
      context.read<FavoritesViewModel>().loadAllWeather();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onCityPicked: () => _selectTab(0)),
          FavoritesScreen(onCitySelected: () => _selectTab(0)),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: FloatingNavBar(
        currentIndex: _index,
        onTap: _selectTab,
      ),
    );
  }
}
