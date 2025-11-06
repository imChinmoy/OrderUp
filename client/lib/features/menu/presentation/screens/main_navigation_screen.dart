import 'package:client/features/menu/presentation/screens/search_screen.dart';
import 'package:client/features/order/presentation/screens/cart_screen.dart';
import 'package:client/features/recommendations/presentation/screens/recommendation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/features/menu/presentation/screens/home_screen.dart';
import 'package:client/features/profile/features/screens/profile_screen.dart';

// This is the main screen that manages navigation
class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _selectedBottomIndex = 0;

  // List of screens for each tab
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeNavigator(), // Home
      const NotificationsScreen(), // Notifications
      const Center(
        child: Text('Recommendations', style: TextStyle(color: Colors.white)),
      ), // Placeholder
      const FavoritesScreen(), // Favorites
      const ProfileScreen(), // Profile
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161F),
      body: IndexedStack(index: _selectedBottomIndex, children: _screens),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F2E),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(Icons.home, "Home", 0),
              _buildNavItem(Icons.notifications_outlined, "Notif", 1),
              _buildFloatingActionButton(),
              _buildNavItem(Icons.favorite_border, "Favourites", 3),
              _buildNavItem(Icons.person_outline, "Profile", 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedBottomIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBottomIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.deepOrange
                  : Colors.white.withOpacity(0.4),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.deepOrange
                    : Colors.white.withOpacity(0.4),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return GestureDetector(
      onTap: () {
        // Navigate to RecommendationScreen instead of changing tab
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RecommendationScreen()),
        );
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange.withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(
          Icons.lightbulb_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

// Placeholder screens - replace these with your actual screens
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Notifications',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Favorites',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}

class HomeNavigator extends StatelessWidget {
  const HomeNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'home',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'home':
            builder = (BuildContext _) => const HomeScreenContent();
            break;
          case 'search':
            builder = (BuildContext _) => const SearchScreen();
            break;
          case 'cart':
            builder = (BuildContext _) => const CartScreen();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
