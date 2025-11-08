import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecommendationsResultScreen extends StatelessWidget {
  final Map<String, dynamic> params;

  const RecommendationsResultScreen({Key? key, required this.params})
    : super(key: key);

  List<Map<String, dynamic>> _generateDummyRecommendations() {
    return [
      {
        'name': 'Paneer Butter Masala',
        'description': 'Creamy paneer curry with rich tomato gravy',
        'price': 120,
        'rating': 4.3,
        'deliveryTime': 18,
        'image': '🍛',
      },
      {
        'name': 'Veg Biryani',
        'description': 'Aromatic rice with vegetables and Indian spices',
        'price': 100,
        'rating': 4.1,
        'deliveryTime': 20,
        'image': '🍚',
      },
      {
        'name': 'Masala Dosa',
        'description': 'Crispy dosa stuffed with flavored potatoes',
        'price': 60,
        'rating': 4.4,
        'deliveryTime': 12,
        'image': '🥞',
      },
      // Add more items as needed
    ];
  }

  @override
  Widget build(BuildContext context) {
    final recommendations = _generateDummyRecommendations();

    return Scaffold(
      backgroundColor: const Color(0xFF16161F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Recommendations',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchSummary(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                return _buildFoodCard(recommendations[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            Icons.restaurant_menu,
            params['category'] as String,
          ),
          _buildSummaryItem(Icons.people, '${params['groupSize']} people'),
          _buildSummaryItem(
            Icons.currency_rupee,
            '₹${params['budget'].toInt()}',
          ),
          _buildSummaryItem(
            Icons.star,
            '${(params['rating'] as double).toStringAsFixed(1)}+',
          ),
        ],
      ),
    );
  }

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

  Widget _buildFoodCard(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Image placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepOrange.withOpacity(0.3),
                    Colors.deepOrange.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  item['image'],
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Food details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '₹${item['price']}',
                          style: const TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['description'],
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        (item['rating'] as double).toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        color: Colors.white.withOpacity(0.5),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item['deliveryTime']} min',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
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
