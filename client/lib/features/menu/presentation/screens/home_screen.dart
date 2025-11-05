import 'package:client/features/menu/presentation/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/menu_item_entity.dart';


class HomeScreenContent extends ConsumerStatefulWidget {
  const HomeScreenContent({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends ConsumerState<HomeScreenContent> {
  //abhi ke liye bas sample data daala hai, until the backend is ready, tab tak, i am taking data from here
  List<MenuItemEntity> get placeholderMenu => [
    MenuItemEntity(
      id: "placeholder1",
      name: "Sample item 1",
      description: "Item not available yet",
      price: 124.50,
      imageUrl: "https://via.placeholder.com/200x200?text=No+Image",
      isTrending: true,
    ),
    MenuItemEntity(
      id: "placeholder2",
      name: "Sample item 2",
      description: "Item not available yet",
      price: 18.95,
      imageUrl: "https://via.placeholder.com/200x200?text=No+Image",
      isTrending: true,
    ),
    MenuItemEntity(
      id: "placeholder3",
      name: "Sample item 3",
      description: "Item not available yet",
      price: 15,
      imageUrl: "https://via.placeholder.com/200x200?text=No+Image",
      isTrending: true,
    ),
    MenuItemEntity(
      id: "placeholder4",
      name: "Sample item 4",
      description: "Item not available yet",
      price: 2.99,
      imageUrl: "https://via.placeholder.com/200x200?text=No+Image",
      isTrending: true,
    ),
    MenuItemEntity(
      id: "placeholder5",
      name: "Sample item 5",
      description: "Item not available yet",
      price: 29,
      imageUrl: "https://via.placeholder.com/200x200?text=No+Image",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);

    return menuState.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      ),
      data: (menuItems) => _buildContent(context, menuItems),
      error: (_, __) => _buildContent(context, placeholderMenu),
    );
  }

  // ---------------------------
  // MAIN SCREEN CONTENT BUILDER
  // ---------------------------
  Widget _buildContent(BuildContext context, List<MenuItemEntity> menuItems) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildTitle(),
            const SizedBox(height: 24),
            _buildTrendingSection(),
            const SizedBox(height: 40),

            // ✅ Popular Food Items Heading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Popular Food Items",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            _buildFoodGrid(menuItems),
            const SizedBox(height: 80), // Extra padding for bottom nav bar
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button (optional UI - keeping minimal)
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              // Navigate back if needed
            },
          ),

          // Search + Cart (NO BOXES)
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white, size: 26),
                onPressed: () {
                  // Open search
                },
              ),
              const SizedBox(width: 4),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: () {
                      // Navigate to cart
                    },
                  ),

                  // Cart indicator dot (optional)
                  Positioned(
                    right: 4,
                    top: 6,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.deepOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingSection() {
    final trendingItems = placeholderMenu
        .where((item) => item.isTrending == true)
        .toList();

    if (trendingItems.isEmpty) return const SizedBox.shrink();

    final controller = PageController(
      viewportFraction: 0.72, // Slightly narrower, like screenshot
      initialPage: 1000,
    );

    final total = trendingItems.length;

    return SizedBox(
      height: 260,
      child: PageView.builder(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final item = trendingItems[index % total];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22), // More rounded
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image
                  Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.white.withOpacity(0.05),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.fastfood,
                        color: Colors.white38,
                        size: 40,
                      ),
                    ),
                  ),

                  // Dark Fade Gradient Like Screenshot
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.9),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  // Text at Bottom
                  Positioned(
                    bottom: 20,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "₹${item.price}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------
  // TITLE SECTION
  // ---------------------------
  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Most Trending",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodGrid(List<MenuItemEntity> menuItems) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
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
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  item.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.restaurant,
                      color: Colors.white.withOpacity(0.2),
                      size: 40,
                    ),
                  ),
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
                  "₹${item.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 13),
                    const SizedBox(width: 4),
                    const Text(
                      "4.5",
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.access_time,
                      color: Colors.white.withOpacity(0.5),
                      size: 13,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "20 min",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}