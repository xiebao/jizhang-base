import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/theme_service.dart';
import '../../database/database_helper.dart';
import '../../models/user.dart';
import 'category_management_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;
  int _transactionCount = 0;
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await AuthService.getCurrentUser();
      if (user != null) {
        final transactionCount = await DatabaseHelper().getTransactionCount(user.username);
        final totalIncome = await DatabaseHelper().getTotalIncome(user.username);
        final totalExpense = await DatabaseHelper().getTotalExpense(user.username);

        setState(() {
          _currentUser = user;
          _transactionCount = transactionCount;
          _totalIncome = totalIncome;
          _totalExpense = totalExpense;
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

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AuthService.logout();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUserData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // User Info Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              _currentUser?.username.substring(0, 1).toUpperCase() ?? 'U',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _currentUser?.username ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _currentUser?.email ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Statistics Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Transactions',
                          _transactionCount.toString(),
                          Icons.receipt,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          'Total Income',
                          '\$${_totalIncome.toStringAsFixed(2)}',
                          Icons.arrow_upward,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Expense',
                          '\$${_totalExpense.toStringAsFixed(2)}',
                          Icons.arrow_downward,
                          Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          'Balance',
                          '\$${(_totalIncome - _totalExpense).toStringAsFixed(2)}',
                          Icons.account_balance_wallet,
                          _totalIncome - _totalExpense >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Settings
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Theme Toggle
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.palette),
                      title: const Text('Theme'),
                      subtitle: Consumer<ThemeService>(
                        builder: (context, themeService, child) {
                          return Text(
                            themeService.isDarkMode ? 'Dark Mode' : 'Light Mode',
                          );
                        },
                      ),
                      trailing: Consumer<ThemeService>(
                        builder: (context, themeService, child) {
                          return Switch(
                            value: themeService.isDarkMode,
                            onChanged: (value) {
                              themeService.toggleTheme();
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  // Category Management
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.category),
                      title: const Text('Category Management'),
                      subtitle: const Text('Manage income and expense categories'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CategoryManagementScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  // Logout
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: _logout,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
