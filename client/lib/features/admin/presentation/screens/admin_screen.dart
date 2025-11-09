import 'dart:convert';
import 'dart:ui';
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0D0D14),
              const Color(0xFF1A1A2E),
              const Color(0xFF0D0D14),
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
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
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _buildHeader() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive sizing based on screen dimensions
    final avatarRadius = screenWidth < 360 ? 20.0 : 24.0;
    final settingsRadius = screenWidth < 360 ? 18.0 : 20.0;
    final titleFontSize = screenWidth < 360 ? 14.0 : 16.0;
    final nameFontSize = screenWidth < 360 ? 26.0 : (screenWidth < 400 ? 28.0 : 32.0);
    final emailFontSize = screenWidth < 360 ? 12.0 : 13.0;
    
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        screenHeight < 700 ? 12 : 16,
        20,
        screenHeight < 700 ? 16 : 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with avatar and settings
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF8C42), Colors.deepOrange.shade700],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepOrange.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: Colors.transparent,
                  child: Text(
                    adminName.isNotEmpty ? adminName[0].toUpperCase() : "A",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: avatarRadius * 0.85,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => context.push('/admin-profile'),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF8C42), Colors.deepOrange.shade700],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrange.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: settingsRadius,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: settingsRadius * 1.1,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: screenHeight < 700 ? 16 : 20),

          // Greeting section
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0.9)],
            ).createShader(bounds),
            child: Text(
              "Admin Panel",
              style: TextStyle(
                color: Colors.white,
                fontSize: titleFontSize,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 4),

          loadingUser
              ? Shimmer.fromColors(
                  baseColor: Colors.grey.shade800,
                  highlightColor: Colors.grey.shade600,
                  child: Container(
                    height: nameFontSize * 1.3,
                    width: screenWidth * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              : ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.white, Colors.deepOrange.shade200],
                  ).createShader(bounds),
                  child: Text(
                    "$adminName 👋",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: nameFontSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

          if (!loadingUser) ...[
            const SizedBox(height: 3),
            Text(
              adminEmail,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: emailFontSize,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrdersTab() {
    final ordersAsync = ref.watch(adminOrdersStreamProvider);

    return ordersAsync.when(
      data: (orders) {
        if (orders.isEmpty) return _emptyUI();

        // Create a copy and sort by most recent first
        final sortedOrders = List.from(orders);
        sortedOrders.sort((a, b) {
          final aDate = a.createdAt ?? DateTime(1970);
          final bDate = b.createdAt ?? DateTime(1970);
          return bDate.compareTo(aDate); // Most recent first
        });

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.deepOrange,
                            Colors.deepOrange.shade700,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Active Orders",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepOrange.withOpacity(0.2),
                            Colors.deepOrange.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.deepOrange.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "${sortedOrders.length}",
                        style: TextStyle(
                          color: Colors.deepOrange.shade400,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: OrderTile(order: sortedOrders[index]),
                  ),
                  childCount: sortedOrders.length,
                ),
              ),
            ),
          ],
        );
      },
      loading: () => _loadingShimmer(),
      error: (err, _) => _errorUI(err),
    );
  }

  Widget _emptyUI() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.05),
                Colors.white.withOpacity(0.02),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Icon(
            Icons.inbox_rounded,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "No Orders Yet",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "New orders will appear here",
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );

  Widget _loadingShimmer() => CustomScrollView(
    slivers: [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, __) => Shimmer.fromColors(
              baseColor: Colors.grey.shade900,
              highlightColor: Colors.grey.shade700,
              child: Container(
                height: 180,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.05),
                      Colors.white.withOpacity(0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
            ),
            childCount: 6,
          ),
        ),
      ),
    ],
  );

  Widget _errorUI(error) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline_rounded,
          size: 80,
          color: Colors.redAccent.withOpacity(0.8),
        ),
        const SizedBox(height: 16),
        Text(
          "Something went wrong",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "$error",
          style: TextStyle(
            color: Colors.redAccent.withOpacity(0.8),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _bottomNav() {
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
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _navButton(Icons.receipt_long_outlined, "Orders", 0),
              ),
              Expanded(
                child: _navButton(Icons.restaurant_menu_outlined, "Menu", 1),
              ),
              Expanded(
                child: _navButton(Icons.analytics_outlined, "Analytics", 2),
              ),
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
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: selected ? -10.0 : 0.0),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: Transform.scale(
                    scale: selected ? 1.25 : 1.0,
                    child: Icon(
                      icon,
                      color: selected
                          ? Colors.deepOrange
                          : Colors.white.withOpacity(0.4),
                      size: 24,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? Colors.deepOrange
                    : Colors.white.withOpacity(0.4),
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
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