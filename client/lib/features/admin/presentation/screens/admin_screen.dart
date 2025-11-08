import 'dart:convert';
import 'package:client/features/admin/presentation/providers/admin_order_providers.dart';
import 'package:client/features/admin/presentation/providers/order_socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../auth/data/datasource/hive_session_storage.dart';
import '../../../auth/data/models/session_model.dart';
import '../widgets/order_tile.dart';
import 'admin_menu_screen.dart';
import 'admin_analytics_screen.dart';
import 'admin_profile_screen.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  int _tabIndex = 0;
  String adminName = "";
  String adminEmail = "";
  bool loadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadAdmin();
  }

  Future<void> _loadAdmin() async {
    final session = await HiveSessionStorage().getSession();
    if (session != null && session.user.isNotEmpty) {
      final parsed = session.safeDecodeUser();
      setState(() {
        adminName = parsed['name'] ?? "Admin";
        adminEmail = parsed['email'] ?? "admin@gmail.com";
        loadingUser = false;
      });
    } else {
      setState(() => loadingUser = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D14),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: IndexedStack(
                index: _tabIndex,
                children: [
                  _buildOrdersTab(),
                  const AdminMenuScreen(),
                  const AdminAnalyticsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: const BoxDecoration(
        color: Color(0xFF17171F),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.deepOrange,
            child: Text(
              adminName.isNotEmpty ? adminName[0].toUpperCase() : "A",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: loadingUser
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade800,
                    highlightColor: Colors.grey.shade600,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 16, width: 100, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(height: 12, width: 160, color: Colors.white),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Admin Panel",
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        adminName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        adminEmail,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
          ),

          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              /* Navigator.push(
                context,
                //MaterialPageRoute(builder: (_) => const AdminProfileScreen()),
              ); */
              context.push('/admin-profile');
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepOrange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.settings, color: Colors.deepOrange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTab() {
    final ordersAsync = ref.watch(adminOrdersStreamProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) return _emptyUI();
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => OrderTile(order: orders[i]),
          );
        },
        loading: () => _loadingShimmer(),
        error: (err, _) => _errorUI(err),
      ),
    );
  }

  Widget _emptyUI() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.inbox_rounded,
          size: 90,
          color: Colors.white.withOpacity(0.2),
        ),
        const SizedBox(height: 10),
        const Text(
          "No Orders Yet",
          style: TextStyle(color: Colors.white70, fontSize: 20),
        ),
      ],
    ),
  );

  Widget _loadingShimmer() => ListView.builder(
    itemCount: 6,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    itemBuilder: (_, __) => Shimmer.fromColors(
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.grey.shade700,
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
  );

  Widget _errorUI(error) => Center(
    child: Text(
      "Error: $error",
      style: const TextStyle(color: Colors.redAccent, fontSize: 16),
    ),
  );

  Widget _bottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF17171F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navButton(Icons.receipt_long_outlined, "Orders", 0),
              _navButton(Icons.restaurant_menu_outlined, "Menu", 1),
              _navButton(Icons.analytics_outlined, "Analytics", 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navButton(IconData icon, String label, int index) {
    bool selected = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                )
              : null,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : Colors.white54,
              size: 22,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on SessionModel {
  Map<String, dynamic> safeDecodeUser() {
    try {
      final first = jsonDecode(user);
      return first is String ? jsonDecode(first) : first;
    } catch (_) {
      return {};
    }
  }
}
