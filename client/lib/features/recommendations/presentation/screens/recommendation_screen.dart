import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'recommendations_result_screen.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({Key? key}) : super(key: key);

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  String? _selectedCategory;
  int _groupSize = 1;
  final TextEditingController _budgetController = TextEditingController();
  double _rating = 3.0;
  final TextEditingController _deliveryTimeController = TextEditingController();

  final List<String> _categories = [
    'Biryani',
    'Brownie',
    'Burger',
    'Tea',
    'Ice Cream',
    'Pizza',
    'Cold Coffee',
    'Salad',
    'Pasta',
    'Sandwich',
  ];

  @override
  void dispose() {
    _budgetController.dispose();
    _deliveryTimeController.dispose();
    super.dispose();
  }

  void _getRecommendations() {
    // Validate inputs
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a food category'),
          backgroundColor: Colors.deepOrange,
        ),
      );
      return;
    }

    if (_budgetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your budget'),
          backgroundColor: Colors.deepOrange,
        ),
      );
      return;
    }

    if (_deliveryTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter delivery time'),
          backgroundColor: Colors.deepOrange,
        ),
      );
      return;
    }

    //  recommendation ke parameters
    final params = {
      'category': _selectedCategory,
      'groupSize': _groupSize,
      'budget': double.parse(_budgetController.text),
      'rating': _rating,
      'deliveryTime': int.parse(_deliveryTimeController.text),
    };

    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendationsResultScreen(params: params),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Get Recommendations',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Food Category'),
            const SizedBox(height: 12),
            _buildCategoryDropdown(),
            const SizedBox(height: 28),
            
            _buildSectionTitle('Group Size'),
            const SizedBox(height: 12),
            _buildGroupSizeStepper(),
            const SizedBox(height: 28),
            
            _buildSectionTitle('Budget (₹)'),
            const SizedBox(height: 12),
            _buildBudgetInput(),
            const SizedBox(height: 28),
            
            _buildSectionTitle('Rating (1-5)'),
            const SizedBox(height: 12),
            _buildRatingSlider(),
            const SizedBox(height: 28),
            
            _buildSectionTitle('Delivery Time (minutes)'),
            const SizedBox(height: 12),
            _buildDeliveryTimeInput(),
            const SizedBox(height: 40),
            
            _buildGetRecommendationsButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Select a category',
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
          ),
          isExpanded: true,
          dropdownColor: const Color(0xFF1F1F2E),
          icon: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.keyboard_arrow_down, color: Colors.white.withOpacity(0.5)),
          ),
          items: _categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  category,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue;
            });
          },
        ),
      ),
    );
  }

  Widget _buildGroupSizeStepper() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Number of people',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          Row(
            children: [
              _buildStepperButton(
                Icons.remove,
                () {
                  if (_groupSize > 1) {
                    setState(() {
                      _groupSize--;
                    });
                  }
                },
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF16161F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _groupSize.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildStepperButton(
                Icons.add,
                () {
                  setState(() {
                    _groupSize++;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepperButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.deepOrange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.deepOrange.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(icon, color: Colors.deepOrange, size: 20),
      ),
    );
  }

  Widget _buildBudgetInput() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _budgetController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Enter budget amount',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Text(
              '₹',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildRatingSlider() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Minimum rating',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Row(
                children: [
                  Text(
                    _rating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.star, color: Colors.deepOrange, size: 20),
                ],
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.deepOrange,
              inactiveTrackColor: Colors.white.withOpacity(0.1),
              thumbColor: Colors.deepOrange,
              overlayColor: Colors.deepOrange.withOpacity(0.2),
              trackHeight: 4,
            ),
            child: Slider(
              value: _rating,
              min: 1.0,
              max: 5.0,
              divisions: 40,
              onChanged: (value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryTimeInput() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _deliveryTimeController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Enter delivery time',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              'min',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ),
          suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildGetRecommendationsButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _getRecommendations,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            alignment: Alignment.center,
            child: const Text(
              'Get Recommendations',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}