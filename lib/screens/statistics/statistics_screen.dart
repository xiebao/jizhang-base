import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../database/database_helper.dart';
import '../../services/auth_service.dart';
import '../../models/transaction.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  String _selectedPeriod = 'month'; // month, year

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final username = await AuthService.getCurrentUsername();
      if (username != null) {
        final now = DateTime.now();
        DateTime startDate;
        
        if (_selectedPeriod == 'month') {
          startDate = DateTime(now.year, now.month, 1);
        } else {
          startDate = DateTime(now.year, 1, 1);
        }

        final transactions = await DatabaseHelper().getTransactionsByDateRange(
          username,
          startDate,
          now,
        );

        final totalIncome = await DatabaseHelper().getTotalIncome(username);
        final totalExpense = await DatabaseHelper().getTotalExpense(username);

        setState(() {
          _transactions = transactions.cast<Transaction>();
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

  List<PieChartSectionData> _getPieChartData() {
    final incomeTransactions = _transactions.where((t) => t.type == 'income').toList();
    final expenseTransactions = _transactions.where((t) => t.type == 'expense').toList();

    // Group by category
    final Map<String, double> incomeByCategory = {};
    final Map<String, double> expenseByCategory = {};

    for (var transaction in incomeTransactions) {
      incomeByCategory[transaction.category] = 
          (incomeByCategory[transaction.category] ?? 0) + transaction.amount;
    }

    for (var transaction in expenseTransactions) {
      expenseByCategory[transaction.category] = 
          (expenseByCategory[transaction.category] ?? 0) + transaction.amount;
    }

    // Create pie chart data for expenses (more meaningful for pie chart)
    final List<PieChartSectionData> sections = [];
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.teal,
    ];

    int colorIndex = 0;
    expenseByCategory.forEach((category, amount) {
      if (amount > 0) {
        sections.add(
          PieChartSectionData(
            color: colors[colorIndex % colors.length],
            value: amount,
            title: '${(amount / _totalExpense * 100).toStringAsFixed(1)}%',
            radius: 100,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
        colorIndex++;
      }
    });

    return sections;
  }

  double _getMaxY() {
    final maxAmount = _totalIncome > _totalExpense ? _totalIncome : _totalExpense;
    // 添加一些余量，让图表看起来更好
    return maxAmount * 1.2;
  }

  List<BarChartGroupData> _getBarChartData() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: _totalIncome,
            color: Colors.green,
            width: 40,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: _totalExpense,
            color: Colors.red,
            width: 40,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          DropdownButton<String>(
            value: _selectedPeriod,
            items: const [
              DropdownMenuItem(value: 'month', child: Text('This Month')),
              DropdownMenuItem(value: 'year', child: Text('This Year')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedPeriod = value!;
              });
              _loadStatistics();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStatistics,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance Card - Top Priority
                    _buildBalanceCard(),
                    const SizedBox(height: 24),

                    // Income and Expense Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            'Total Income',
                            _totalIncome,
                            Colors.green,
                            Icons.arrow_upward,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSummaryCard(
                            'Total Expense',
                            _totalExpense,
                            Colors.red,
                            Icons.arrow_downward,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Bar Chart
                    if (_transactions.isNotEmpty) ...[
                      const Text(
                        'Income vs Expense',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            height: 200,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: _getMaxY(),
                                titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        switch (value.toInt()) {
                                          case 0:
                                            return const Text('Income');
                                          case 1:
                                            return const Text('Expense');
                                          default:
                                            return const Text('');
                                        }
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          '\$${value.toInt()}',
                                          style: const TextStyle(fontSize: 10),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(show: true),
                                barGroups: _getBarChartData(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Pie Chart
                      const Text(
                        'Expense by Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            height: 300,
                            child: _transactions.where((t) => t.type == 'expense').isEmpty
                                ? const Center(
                                    child: Text('No expense data available'),
                                  )
                                : PieChart(
                                    PieChartData(
                                      sections: _getPieChartData(),
                                      centerSpaceRadius: 40,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ] else
                      const Center(
                        child: Text('No data available'),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBalanceCard() {
    final balance = _totalIncome - _totalExpense;
    final isPositive = balance >= 0;
    final color = isPositive ? Colors.green : Colors.red;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: color,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                'Current Balance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '\$${balance.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isPositive ? 'You are in good shape!' : 'You need to save more',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
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
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
