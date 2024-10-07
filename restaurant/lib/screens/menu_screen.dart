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
  List<MenuItem> _menuItems = [];
  bool _isLoading = false;
  int _displayedItemCount = 20;
  final int _loadIncrement = 20;

  @override
  void initState() {
    super.initState();
    _loadMoreItems();
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    if (_menuItems.isEmpty) {
      _menuItems = await _menuService.getMenuItems();
    }

    setState(() {
      _displayedItemCount = (_displayedItemCount + _loadIncrement).clamp(0, _menuItems.length);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Menu'),
      ),
      body: ListView.builder(
        itemCount: _displayedItemCount + 1,
        itemBuilder: (context, index) {
          if (index == _displayedItemCount) {
            if (_displayedItemCount < _menuItems.length) {
              _loadMoreItems();
              return const Center(child: CircularProgressIndicator());
            } else {
              return const SizedBox.shrink();
            }
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