import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../services/auth_service.dart';

class InitialBalanceDialog extends StatefulWidget {
  const InitialBalanceDialog({super.key});

  @override
  State<InitialBalanceDialog> createState() => _InitialBalanceDialogState();
}

class _InitialBalanceDialogState extends State<InitialBalanceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveInitialBalance() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final username = await AuthService.getCurrentUsername();
      if (username != null) {
        final amount = double.parse(_amountController.text);
        await DatabaseHelper().updateUserInitialBalance(username, amount);
        
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save initial balance')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Initial Balance'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Welcome to XMoneyNote! Please set your initial balance to get started.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Initial Balance',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
                hintText: '0.00',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Skip'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveInitialBalance,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
