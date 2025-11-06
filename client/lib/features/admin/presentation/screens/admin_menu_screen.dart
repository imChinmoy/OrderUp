import 'package:flutter/material.dart';
//TODO: FUnctionality to edit menu items add karni hai
class AdminMenuScreen extends StatefulWidget {
  const AdminMenuScreen({Key? key}) : super(key: key);

  @override
  State<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  String _selectedCategory = "All";
  final List<String> _categories = ["All", "Main Course", "Desserts", "Beverages", "Appetizers"];

  final List<Map<String, dynamic>> _menuItems = [
    {
      "id": "1",
      "name": "Butter Chicken",
      "category": "Main Course",
      "price": 299.0,
      "stock": true,
      "image": "https://via.placeholder.com/100x100?text=Food",
    },
    {
      "id": "2",
      "name": "Paneer Tikka",
      "category": "Appetizers",
      "price": 150.0,
      "stock": true,
      "image": "https://via.placeholder.com/100x100?text=Food",
    },
    {
      "id": "3",
      "name": "Gulab Jamun",
      "category": "Desserts",
      "price": 30.0,
      "stock": false,
      "image": "https://via.placeholder.com/100x100?text=Food",
    },
    {
      "id": "4",
      "name": "Mango Lassi",
      "category": "Beverages",
      "price": 49.0,
      "stock": true,
      "image": "https://via.placeholder.com/100x100?text=Food",
    },
    {
      "id": "5",
      "name": "Biryani",
      "category": "Main Course",
      "price": 250.0,
      "stock": true,
      "image": "https://via.placeholder.com/100x100?text=Food",
    },
  ];

  List<Map<String, dynamic>> get _filteredItems {
    if (_selectedCategory == "All") {
      return _menuItems;
    }
    return _menuItems.where((item) => item["category"] == _selectedCategory).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildCategoryFilter(),
        Expanded(child: _buildMenuList()),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Menu Management",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepOrange.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // TODO: Add new menu item
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Add new item feature coming soon"),
                      backgroundColor: Colors.deepOrange,
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 20),
                      SizedBox(width: 4),
                      Text(
                        "Add Item",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.deepOrange.withOpacity(0.2)
                    : const Color(0xFF1F1F2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Colors.deepOrange
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.deepOrange : Colors.white70,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return _buildMenuItem(item);
      },
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item["image"],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: Colors.white.withOpacity(0.05),
                child: const Icon(
                  Icons.restaurant,
                  color: Colors.white38,
                  size: 30,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item["name"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: item["stock"]
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item["stock"] ? "In Stock" : "Out",
                        style: TextStyle(
                          color: item["stock"] ? Colors.green : Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item["category"],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "₹${item["price"].toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    // Edit Button
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      color: Colors.blue,
                      onPressed: () {
                        _showEditDialog(item);
                      },
                    ),
                    // Delete Button
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: Colors.red,
                      onPressed: () {
                        _showDeleteDialog(item);
                      },
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

  void _showEditDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Edit Item",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Edit functionality for ${item['name']} coming soon",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Close",
              style: TextStyle(color: Colors.deepOrange),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Delete Item",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Are you sure you want to delete ${item['name']}?",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${item['name']} deleted"),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              "Delete",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}