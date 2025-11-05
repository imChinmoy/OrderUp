import 'package:client/features/menu/presentation/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../domain/entities/menu_item_entity.dart';


class HomeScreenContent extends ConsumerStatefulWidget {
  const HomeScreenContent({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedBottomIndex = 0;
  int _selectedCatIndex = 0;
  List<String> _categories = ['All'];

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final trendingState = ref.watch(trendingMenuProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF16161F),
      body: menuState.when(
        loading: () => _buildLoadingPlaceholder(),
        error: (_, __) => _buildContent(context, [], trendingState),
        data: (menuItems) {
          _setCategories(menuItems);
          return _buildContent(context, menuItems, trendingState);
        },
      ),
      data: (menuItems) => _buildContent(context, menuItems),
      error: (_, __) => _buildContent(context, placeholderMenu),
    );
  }

  void _setCategories(List<MenuItemEntity> items) {
    final dynamicCats =
        items.map((e) => e.category).whereType<String>().toSet().toList()
          ..sort();
    _categories = ['All', ...dynamicCats];
  }

  Widget _buildContent(
    BuildContext context,
    List<MenuItemEntity> menuItems,
    AsyncValue<List<MenuItemEntity>> trendingState,
  ) {
    final filteredMenuItems = _selectedCatIndex == 0
        ? menuItems
        : menuItems
              .where((item) => item.category == _categories[_selectedCatIndex])
              .toList();

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              trendingState.when(
                data: (trendingItems) => _buildTrendingSection(trendingItems),
                loading: () => _buildTrendingLoadingPlaceholder(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 40),
              const Text(
                "Popular Food Items",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _buildFoodGrid(filteredMenuItems),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: Colors.white70,
              size: 17,
            ),
            const SizedBox(width: 6),
            Text(
              "Mushin, Lagos.",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.expand_more, color: Colors.white38, size: 16),
            const Spacer(),
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                "https://i.imgur.com/your_avatar_image.jpg",
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          "Locate bukas in your area today.",
          style: TextStyle(color: Colors.white38, fontSize: 13),
        ),
        const SizedBox(height: 18),
        Text(
          "Good evening Mimi...",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFF1F1F2E),
            prefixIcon: const Icon(Icons.search, color: Colors.white38),
            hintText: "Search here",
            hintStyle: const TextStyle(color: Colors.white54, fontSize: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 16,
            ),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 22),
        SizedBox(
          height: 54,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) => _buildCategoryItem(index),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(int index) {
    final selected = index == _selectedCatIndex;
    final category = _categories[index];
    return GestureDetector(
      onTap: () {
        setState(() => _selectedCatIndex = index);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? Colors.white : const Color(0xFF29293A),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingSection(List<MenuItemEntity> trendingItems) {
    if (trendingItems.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Top rated bukas",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "See all",
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 225,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: trendingItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = trendingItems[index];
              return Container(
                width: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF28283D),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageWithShimmer(
                      imageUrl: item.imageUrl,
                      height: 120,
                      width: double.infinity,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.category ?? '',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "₹${item.price}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFoodGrid(List<MenuItemEntity> menuItems) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menuItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 260,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _buildFoodItemCard(item);
      },
    );
  }

  Widget _buildFoodItemCard(MenuItemEntity item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F2E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ImageWithShimmer(
                imageUrl: item.imageUrl,
                height: 140,
                width: double.infinity,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.black87,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.category ?? '',
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  "₹${item.price}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
              _buildNavItem(Icons.favorite_border, "Favourites", 2),
              _buildNavItem(Icons.person_outline, "Profile", 3),
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
    return Container(
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
      child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
    );
  }
}

class ImageWithShimmer extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const ImageWithShimmer({
    required this.imageUrl,
    required this.height,
    required this.width,
    this.borderRadius = BorderRadius.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        imageUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade900,
            highlightColor: Colors.grey.shade700,
            child: Container(
              height: height,
              width: width,
              color: Colors.grey.shade800,
            ),
          );
        },
        errorBuilder: (_, __, ___) => Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          color: Colors.white.withOpacity(0.08),
          child: Icon(
            Icons.fastfood,
            color: Colors.white.withOpacity(0.4),
            size: 32,
          ),
        ),
      ),
    );
  }
}

Widget _buildLoadingPlaceholder() {
  return Center(
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.grey.shade700,
      child: Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.grey.shade800,
        ),
      ),
    ),
  );
}


Widget _buildTrendingLoadingPlaceholder() {
  return SizedBox(
    height: 225,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(width: 14),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade900,
        highlightColor: Colors.grey.shade700,
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.grey.shade800,
          ),
        ),
      ),
    ),
  );
}
