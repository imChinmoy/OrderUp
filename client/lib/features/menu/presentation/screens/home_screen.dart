import 'package:client/features/menu/presentation/providers/menu_provider.dart';
import 'package:client/features/menu/presentation/screens/food_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../domain/entities/menu_item_entity.dart';

class HomeScreenContent extends ConsumerStatefulWidget {
  const HomeScreenContent({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends ConsumerState<HomeScreenContent> {
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
      // bottomNavigationBar: _buildBottomNavigationBar(),
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
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
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 16),
              _buildFoodGrid(filteredMenuItems),
              const SizedBox(height: 30),
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
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: Colors.white70,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              "Mushin, Lagos.",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.expand_more, color: Colors.white38, size: 18),
            const Spacer(),
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                "https://i.imgur.com/your_avatar_image.jpg",
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          "Locate bukas in your area today.",
          style: TextStyle(color: Colors.white38, fontSize: 14),
        ),
        const SizedBox(height: 22),
        Text(
          "Good evening Mimi...",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1F1F2E),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white38,
              size: 26,
            ),
            hintText: "Search here",
            hintStyle: const TextStyle(color: Colors.white54, fontSize: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 20,
            ),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                right: index == _categories.length - 1 ? 0 : 14,
              ),
              child: _buildCategoryItem(index),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(int index) {
    final selected = index == _selectedCatIndex;
    final category = _categories[index];
    return GestureDetector(
      onTap: () => setState(() => _selectedCatIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? Colors.deepOrange : const Color(0xFF29293A),
          borderRadius: BorderRadius.circular(30),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.deepOrange.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: selected ? Colors.white : Colors.white70,
            letterSpacing: 0.4,
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
          children: [
            const Text(
              "Top rated bukas",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: handle see all tap
              },
              child: const Text(
                "See all",
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: trendingItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) =>
                _buildTrendingCard(trendingItems[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingCard(MenuItemEntity item) {
    return Container(
      width: 230,
      decoration: BoxDecoration(
        color: const Color(0xFF29293A),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: ImageWithShimmer(
              imageUrl: item.imageUrl,
              height: 140,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  item.category ?? '',
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const SizedBox(height: 10),
                Text(
                  "₹${item.price}",
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodGrid(List<MenuItemEntity> menuItems) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menuItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 280,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
      ),
      itemBuilder: (context, index) => _buildFoodCard(menuItems[index]),
    );
  }

  Widget _buildFoodCard(MenuItemEntity item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FoodDetailScreen(item: item)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF29293A),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.30),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: ImageWithShimmer(
                imageUrl: item.imageUrl,
                height: 160,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.category ?? '',
                    style: const TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "₹${item.price}",
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F2E),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 15,
            offset: const Offset(0, -7),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
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
      onTap: () => setState(() => _selectedBottomIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? Colors.deepOrange : Colors.white54,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.deepOrange : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withOpacity(0.5),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
    );
  }
}

class ImageWithShimmer extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;

  const ImageWithShimmer({
    required this.imageUrl,
    required this.height,
    required this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
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
            size: 36,
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
        width: 240,
        height: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          color: Colors.grey.shade800,
        ),
      ),
    ),
  );
}

Widget _buildTrendingLoadingPlaceholder() {
  return SizedBox(
    height: 240,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(width: 16),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade900,
        highlightColor: Colors.grey.shade700,
        child: Container(
          width: 230,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.grey.shade800,
          ),
        ),
      ),
    ),
  );
}
