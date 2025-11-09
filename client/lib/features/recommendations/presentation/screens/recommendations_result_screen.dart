import 'package:client/features/recommendations/domain/entities/recommendation_entity.dart';
import 'package:client/features/recommendations/presentation/providers/recommendation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecommendationsResultScreen extends ConsumerWidget {
  final Map<String, dynamic> params;
  const RecommendationsResultScreen({super.key, required this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recAsync = ref.watch(recommendationsProvider(params));

    return Scaffold(
      backgroundColor: const Color(0xFF16161F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F2E),
        title: const Text('Recommended Dishes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: recAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.deepOrange),
        ),
        error: (err, _) => Center(
          child: Text("Error: $err", style: TextStyle(color: Colors.redAccent)),
        ),
        data: (recommendations) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recommendations.length,
          itemBuilder: (_, i) {
            final item = recommendations[i];
            return _buildFoodCard(item);
          },
        ),
      ),
    );
  }

  //   Widget _buildSearchSummary() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFF1F1F2E),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         _buildSummaryItem(
  //           Icons.restaurant_menu,
  //           params['category'] as String,
  //         ),
  //         _buildSummaryItem(Icons.people, '${params['groupSize']} people'),
  //         _buildSummaryItem(
  //           Icons.currency_rupee,
  //           '₹${params['budget'].toInt()}',
  //         ),
  //         _buildSummaryItem(
  //           Icons.star,
  //           '${(params['rating'] as double).toStringAsFixed(1)}+',
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSummaryItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepOrange, size: 20),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildFoodCard(RecommendationEntity item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.white.withOpacity(0.1),
                  child: const Icon(
                    Icons.fastfood,
                    color: Colors.white54,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "₹${item.price}",
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      Text(
                        "${item.rating}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.white54,
                      ),
                      Text(
                        "${item.deliveryTime}m",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
