//menu_screen.dart        - red screen fixed.
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
  bool _isLoading = false;
  int _displayedItemCount = 20;
  final int _loadIncrement = 20;

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

    setState(() {
      _displayedItemCount = _loadIncrement.clamp(0, _menuItems.length);
      _isLoading = false;
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
              itemCount: _displayedItemCount + 1,
              itemBuilder: (context, index) {
                if (index == _displayedItemCount) {
                  return _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                }

                final item = _menuItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.category),
                  trailing: Text('₹${item.price}'),
                );
              },
            ),
    );
  }
}