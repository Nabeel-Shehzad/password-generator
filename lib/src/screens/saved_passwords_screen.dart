import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../utils/database_helper.dart';

class SavedPasswordsScreen extends StatefulWidget {
  const SavedPasswordsScreen({super.key});

  @override
  State<SavedPasswordsScreen> createState() => _SavedPasswordsScreenState();
}

class _SavedPasswordsScreenState extends State<SavedPasswordsScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _savedPasswords;

  @override
  void initState() {
    super.initState();
    _savedPasswords = _databaseHelper.getSavedPasswords();
  }

  Future<void> _deletePassword(int id) async {
    await _databaseHelper.deletePassword(id);
    setState(() {
      _savedPasswords = _databaseHelper.getSavedPasswords();
    });
  }

  Future<void> _copyToClipboard(String password) async {
    await Clipboard.setData(ClipboardData(text: password));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Passwords'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _savedPasswords,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final passwords = snapshot.data;
          if (passwords == null || passwords.isEmpty) {
            return Center(
              child: Text(
                'No saved passwords',
                style: theme.textTheme.bodyLarge,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: passwords.length,
            itemBuilder: (context, index) {
              final password = passwords[index];
              final createdAt = DateTime.parse(password['created_at']);
              final formattedDate = DateFormat('MMM d, y HH:mm').format(createdAt);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(
                    password['title'],
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        password['password'],
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        formattedDate,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () => _copyToClipboard(password['password']),
                        tooltip: 'Copy password',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deletePassword(password['id']),
                        tooltip: 'Delete password',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
