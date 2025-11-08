import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../providers/admin_menu_provider.dart';
import '../../data/models/menu_model.dart';

class AdminMenuScreen extends ConsumerStatefulWidget {
  const AdminMenuScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends ConsumerState<AdminMenuScreen> {
  String _selectedCategory = "All";

  List<String> _categoriesFrom(List<MenuModel> items) {
    final s = {"All", ...items.map((e) => e.category)};
    return s.toList()..sort();
  }



  List<MenuModel> _filtered(List<MenuModel> items) {
    if (_selectedCategory == "All") return items;
    return items.where((e) => e.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(adminMenuProvider);
    final cats = _categoriesFrom(items);

    return Column(
      children: [
        _header(context),
        _categoryFilter(cats),
        Expanded(child: _list(items)),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Menu Management",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)]),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.deepOrange.withOpacity(0.3), blurRadius: 10, offset: Offset(0, 4))],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _openAddItemSheet(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 20),
                      SizedBox(width: 4),
                      Text("Add Item", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
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

  Widget _categoryFilter(List<String> categories) {
    if (!categories.contains(_selectedCategory)) {
      _selectedCategory = "All";
    }
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.deepOrange.withOpacity(0.2) : const Color(0xFF1F1F2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? Colors.deepOrange : Colors.transparent, width: 1.5),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.deepOrange : Colors.white70,
                    fontSize: 14,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _list(List<MenuModel> all) {
    final items = _filtered(all);
    if (items.isEmpty) {
      return const Center(
        child: Text("No items found", style: TextStyle(color: Colors.white54)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      itemBuilder: (_, i) => _tile(items[i]),
    );
  }

  Widget _tile(MenuModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1F1F2E), borderRadius: BorderRadius.circular(16)),
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
                color: Colors.white.withOpacity(0.05),
                child: const Icon(Icons.restaurant, color: Colors.white38, size: 30),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Expanded(
                    child: Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.isAvailable ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.isAvailable ? "In Stock" : "Out",
                      style: TextStyle(
                        color: item.isAvailable ? Colors.green : Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(item.category, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text("₹${item.price.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.deepOrange, fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: Icon(item.isAvailable ? Icons.toggle_on : Icons.toggle_off, size: 28, color: Colors.deepOrange),
                    onPressed: () => ref.read(adminMenuProvider.notifier).toggleStock(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 22),
                    color: Colors.red,
                    onPressed: () => _confirmDelete(item),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(MenuModel item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Item", style: TextStyle(color: Colors.white)),
        content: Text("Are you sure you want to delete ${item.name}?", style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(adminMenuProvider.notifier).deleteItem(item);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${item.name} deleted"), backgroundColor: Colors.red),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _openAddItemSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1F1F2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _AddItemSheet(onSubmit: (payload) async {
        await ref.read(adminMenuProvider.notifier).addItem(payload);
        if (!mounted) return;
        Navigator.pop(ctx);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Item added successfully"), backgroundColor: Colors.green),
        );
      }),
    );
  }
}

class _AddItemSheet extends StatefulWidget {
  final Future<void> Function(Map<String, dynamic>) onSubmit;
  const _AddItemSheet({required this.onSubmit});

  @override
  State<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<_AddItemSheet> {
  final _formKey = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  final _image = TextEditingController();
  String _category = "Main Course";
  bool _isTrending = false;
  bool _isAvailable = true;
  bool _submitting = false;

  @override
  void dispose() {
    _id.dispose();
    _name.dispose();
    _desc.dispose();
    _price.dispose();
    _image.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text("Add Menu Item", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(children: [
                _field(_id, "ID (unique)", validator: (v) => v!.trim().isEmpty ? "Required" : null),
                _field(_name, "Name", validator: (v) => v!.trim().isEmpty ? "Required" : null),
                _field(_desc, "Description", maxLines: 3),
                _field(_price, "Price", keyboard: TextInputType.number, validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Required";
                  final val = double.tryParse(v);
                  if (val == null || val <= 0) return "Enter a valid price";
                  return null;
                }),
                _field(_image, "Image URL"),
                const SizedBox(height: 8),
                _dropdown(),
                const SizedBox(height: 8),
                _switches(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _submitting ? null : _submit,
                    child: Text(_submitting ? "Adding..." : "Add Item",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint,
      {String? Function(String?)? validator, TextInputType? keyboard, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: c,
        validator: validator,
        keyboardType: keyboard,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: const Color(0xFF2A2A3A),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  Widget _dropdown() {
    const options = ["Main Course", "Appetizers", "Desserts", "Beverages", "Sides"];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFF2A2A3A), borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonFormField<String>(
        value: _category,
        items: options.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.white)))).toList(),
        onChanged: (v) => setState(() => _category = v!),
        decoration: const InputDecoration(border: InputBorder.none),
        dropdownColor: const Color(0xFF2A2A3A),
        iconEnabledColor: Colors.white70,
      ),
    );
  }

  Widget _switches() {
    return Row(
      children: [
        Expanded(
          child: SwitchListTile(
            value: _isAvailable,
            onChanged: (v) => setState(() => _isAvailable = v),
            title: const Text("Available", style: TextStyle(color: Colors.white)),
            activeColor: Colors.deepOrange,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SwitchListTile(
            value: _isTrending,
            onChanged: (v) => setState(() => _isTrending = v),
            title: const Text("Trending", style: TextStyle(color: Colors.white)),
            activeColor: Colors.deepOrange,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final payload = {
      "id": _id.text.trim(),
      "name": _name.text.trim(),
      "description": _desc.text.trim(),
      "price": double.parse(_price.text.trim()),
      "imageUrl": _image.text.trim(),
      "category": _category,
      "isTrending": _isTrending,
      "isAvailable": _isAvailable,
    };

    try {
      await widget.onSubmit(payload);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to add item: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}
