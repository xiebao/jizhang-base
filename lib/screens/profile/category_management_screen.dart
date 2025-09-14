import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../database/database_helper.dart';
import '../../services/auth_service.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  List<Category> _incomeCategories = [];
  List<Category> _expenseCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final username = await AuthService.getCurrentUsername();
      if (username != null) {
        final incomeCategories = await DatabaseHelper().getCategoriesByType(username, 'income');
        final expenseCategories = await DatabaseHelper().getCategoriesByType(username, 'expense');

        setState(() {
          _incomeCategories = incomeCategories;
          _expenseCategories = expenseCategories;
        });
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addCategory(String type) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add ${type == 'income' ? 'Income' : 'Expense'} Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Category Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        final username = await AuthService.getCurrentUsername();
        if (username != null) {
          final category = Category(
            name: result,
            type: type,
            userId: username,
            createdAt: DateTime.now(),
          );

          await DatabaseHelper().insertCategory(category);
          _loadCategories();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add category')),
          );
        }
      }
    }
  }

  Future<void> _deleteCategory(Category category) async {
    // Don't allow deleting default categories
    if (category.userId == 'default') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot delete default categories')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await DatabaseHelper().deleteCategory(category.id!);
        _loadCategories();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete category')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Management'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCategories,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Income Categories
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Income Categories',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () => _addCategory('income'),
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ),
                        ..._incomeCategories.map((category) => ListTile(
                          title: Text(category.name),
                          trailing: category.userId != 'default'
                              ? IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteCategory(category),
                                )
                              : const Icon(Icons.lock, color: Colors.grey),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Expense Categories
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Expense Categories',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () => _addCategory('expense'),
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ),
                        ..._expenseCategories.map((category) => ListTile(
                          title: Text(category.name),
                          trailing: category.userId != 'default'
                              ? IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteCategory(category),
                                )
                              : const Icon(Icons.lock, color: Colors.grey),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
