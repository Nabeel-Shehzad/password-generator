import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../utils/password_generator.dart';
import '../widgets/password_display_card.dart';
import '../widgets/password_options.dart';
import '../widgets/particle_background.dart';
import '../utils/database_helper.dart';
import 'saved_passwords_screen.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() => _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen>
    with SingleTickerProviderStateMixin {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late AnimationController _animationController;
  late Animation<double> _animation;

  String _generatedPassword = '';
  double _passwordLength = AppConstants.defaultLength;
  bool _useUppercase = true;
  bool _useLowercase = true;
  bool _useNumbers = true;
  bool _useSpecialChars = true;
  bool _isPasswordCopied = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: AppConstants.animationDuration),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _generatePassword();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _generatePassword() {
    final password = PasswordGenerator.generate(
      length: _passwordLength,
      useUppercase: _useUppercase,
      useLowercase: _useLowercase,
      useNumbers: _useNumbers,
      useSpecialChars: _useSpecialChars,
    );

    setState(() {
      _generatedPassword = password;
      _isPasswordCopied = false;
    });
    _animationController.forward(from: 0);
  }

  Future<void> _copyToClipboard() async {
    if (_generatedPassword.isEmpty) return;
    
    await Clipboard.setData(ClipboardData(text: _generatedPassword));
    if (!mounted) return;
    
    setState(() {
      _isPasswordCopied = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(AppConstants.copiedToClipboard),
        action: SnackBarAction(
          label: AppConstants.ok,
          onPressed: () {},
        ),
      ),
    );
  }

  Future<void> _savePassword() async {
    if (_generatedPassword.isEmpty) return;

    final TextEditingController titleController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Password'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
            hintText: 'Enter a title for this password',
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == true && titleController.text.isNotEmpty && mounted) {
      await _databaseHelper.savePassword(titleController.text, _generatedPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedPasswordsScreen(),
                ),
              );
            },
            tooltip: 'View saved passwords',
          ),
        ],
      ),
      body: Stack(
        children: [
          ParticleBackground(
            particleColor: Theme.of(context).colorScheme.primary,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PasswordDisplayCard(
                        password: _generatedPassword,
                        animation: _animation,
                        passwordLength: _passwordLength,
                      ),
                      const SizedBox(height: 32),
                      PasswordOptions(
                        passwordLength: _passwordLength,
                        useUppercase: _useUppercase,
                        useLowercase: _useLowercase,
                        useNumbers: _useNumbers,
                        useSpecialChars: _useSpecialChars,
                        onLengthChanged: (value) {
                          setState(() {
                            _passwordLength = value;
                          });
                          _generatePassword();
                        },
                        onUppercaseChanged: (value) {
                          setState(() {
                            _useUppercase = value;
                          });
                          _generatePassword();
                        },
                        onLowercaseChanged: (value) {
                          setState(() {
                            _useLowercase = value;
                          });
                          _generatePassword();
                        },
                        onNumbersChanged: (value) {
                          setState(() {
                            _useNumbers = value;
                          });
                          _generatePassword();
                        },
                        onSpecialCharsChanged: (value) {
                          setState(() {
                            _useSpecialChars = value;
                          });
                          _generatePassword();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _generatePassword,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text(AppConstants.generateNewPassword),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _generatedPassword.isEmpty ? null : _copyToClipboard,
                      icon: const Icon(Icons.copy_rounded),
                      label: const Text(AppConstants.copyToClipboard),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Tooltip(
                      message: _isPasswordCopied ? 'Save this password' : 'Copy password first before saving',
                      child: OutlinedButton.icon(
                        onPressed: (_generatedPassword.isEmpty || !_isPasswordCopied) ? null : _savePassword,
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Save Password'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
