import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../services/menu_service.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final MenuService _menuService = MenuService();
  final ScrollController _scrollController = ScrollController();
  List<MenuItem> _menuItems = [];
  Map<int, int> _selectedItems = {}; // Map to store item id and its quantity
  bool _isLoading = false;
  int _displayedItemCount = 20;
  final int _loadIncrement = 20;

  // Map to store items grouped by category
  Map<String, List<MenuItem>> _categorizedItems = {};

  @override
  void initState() {
    super.initState();
    _loadInitialItems();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialItems() async {
    setState(() {
      _isLoading = true;
    });

    _menuItems = await _menuService.getMenuItems();
    _categorizeItems(); // Categorize items after loading

    setState(() {
      _displayedItemCount = _loadIncrement.clamp(0, _menuItems.length);
      _isLoading = false;
    });
  }

  // Modified: Method to categorize items and sort items within categories
  void _categorizeItems() {
    _categorizedItems.clear();
    for (var item in _menuItems) {
      _categorizedItems.putIfAbsent(item.category, () => []).add(item);
    }
    // Sort items within each category alphabetically
    _categorizedItems.forEach((category, items) {
      items.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading || _displayedItemCount >= _menuItems.length) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _displayedItemCount = (_displayedItemCount + _loadIncrement).clamp(0, _menuItems.length);
      _isLoading = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreItems();
    }
  }

  void _updateItemQuantity(int itemId, int delta) {
    setState(() {
      _selectedItems.update(itemId, (value) => (value + delta).clamp(0, 99), ifAbsent: () => delta.clamp(0, 99));
      if (_selectedItems[itemId] == 0) {
        _selectedItems.remove(itemId);
      }
    });
  }

  Widget _buildMenuItem(MenuItem item) {
    final itemQuantity = _selectedItems[item.id] ?? 0;

    return ListTile(
      title: Text(item.name),
      subtitle: Text('₹${item.price}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (itemQuantity > 0) ...[
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => _updateItemQuantity(item.id, -1),
            ),
            Text('$itemQuantity'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _updateItemQuantity(item.id, 1),
            ),
          ] else
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () => _updateItemQuantity(item.id, 1),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Menu'),
      ),
      body: _menuItems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _categorizedItems.length + 1,
              itemBuilder: (context, index) {
                if (index == _categorizedItems.length) {
                  return _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                }

                final category = _categorizedItems.keys.elementAt(index);
                final categoryItems = _categorizedItems[category]!;

                return ExpansionTile(
                  title: Text(category),
                  children: categoryItems.map((item) => _buildMenuItem(item)).toList(),
                );
              },
            ),
    );
  }
}