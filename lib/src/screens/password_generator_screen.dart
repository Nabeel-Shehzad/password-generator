import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../utils/password_generator.dart';
import '../widgets/password_display_card.dart';
import '../widgets/password_options.dart';
import '../widgets/particle_background.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() => _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  String _generatedPassword = '';
  double _passwordLength = AppConstants.defaultLength;
  bool _useUppercase = true;
  bool _useLowercase = true;
  bool _useNumbers = true;
  bool _useSpecialChars = true;

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
    });
    _animationController.forward(from: 0);
  }

  Future<void> _copyToClipboard() async {
    if (_generatedPassword.isEmpty) return;
    
    await Clipboard.setData(ClipboardData(text: _generatedPassword));
    if (!mounted) return;
    
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
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
              ElevatedButton.icon(
                onPressed: _generatePassword,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(AppConstants.generateNewPassword),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _generatedPassword.isEmpty ? null : _copyToClipboard,
                icon: const Icon(Icons.copy_rounded),
                label: const Text(AppConstants.copyToClipboard),
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
